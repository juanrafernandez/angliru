//
//  CalendarRaceViewController.swift
//  Angliru
//
//  Created by Juanra Fernández on 08/04/2020.
//  Copyright © 2020 JRLabs. All rights reserved.
//

import UIKit

class CalendarRaceViewController : BaseViewController, UITableViewDelegate, UITableViewDataSource, CalendarPresenterOutput {
    
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var labelRaceName: UILabel!
    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var labelStart: UILabel!
    @IBOutlet weak var labelStartInfo: UILabel!
    @IBOutlet weak var labelEnd: UILabel!
    @IBOutlet weak var labelEndInfo: UILabel!
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var labelDistanceInfo: UILabel!
    @IBOutlet weak var labelTeams: UILabel!
    @IBOutlet weak var labelTeamsInfo: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelStatusInfo: UILabel!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var labelWeb: UILabel!
    @IBOutlet weak var buttonWeb: UIButton!
    @IBOutlet weak var buttonTwitter: UIButton!
    @IBOutlet weak var labelStages: UILabel!
    @IBOutlet weak var buttonImageCountry: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonBet: UIButton!
    @IBOutlet weak var buttonClassification: UIButton!
    
    var race = Race()
    var presenter = CalendarPresenter()
    var navigationParent : UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeInterface()
        fillRaceData()
    }
    
    func initializeInterface() {
        buttonBet.layer.cornerRadius = 10
        buttonClassification.layer.cornerRadius = 10
        //buttonBet.layer.borderColor = COLOR_GRAY.cgColor
        buttonBet.layer.borderWidth = 2
        viewStatus.layer.cornerRadius = 10
        
        presenter.output = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func fillRaceData() {
        var position = race.dateStart.firstIndex(of: ".") ?? race.dateStart.endIndex
        let dateNumber = String(race.dateStart[..<position])
        position = race.dateStart.index(position, offsetBy: 1)
        let dateMonth = String(race.dateStart[position...])
        var year = UserDefaults.standard.string(forKey: SEASON_SELECTED)
        if (year != nil) {
            year = CURRENT_SEASON
        }
        year = String(year?.suffix(2) ?? "18")
        //labelDay.text = dateNumber
        //labelMonth.text = MONTHS_SHORT[Int(dateMonth)!-1]
        labelStartInfo.text = "\(dateNumber) \(MONTHS_SHORT[Int(dateMonth)!-1]) '\(year!)"
        
        var dateNumberEnd = ""
        var dateMonthEnd = ""
        
        if race.dateEnd != "" {
            var positionEnd = race.dateEnd.firstIndex(of: ".") ?? race.dateEnd.endIndex
            dateNumberEnd = String(race.dateEnd[..<positionEnd])
            positionEnd = race.dateEnd.index(positionEnd, offsetBy: 1)
            dateMonthEnd = String(race.dateEnd[positionEnd...])
            
            labelEndInfo.text = "\(dateNumberEnd) \(MONTHS_SHORT[Int(dateMonthEnd)!]) '\(year!)"
            //labelEndInfo.text = "\(dateNumber) \(MONTHS_SHORT[Int(dateMonth)!]) - \(dateNumberEnd) \(MONTHS_SHORT[Int(dateMonthEnd)!])"
        } else {
            labelEndInfo.text = "\(dateNumber) \(MONTHS_SHORT[Int(dateMonth)!]) '\(year!)"
        }
        if race.distance != 0 {
            labelDistanceInfo.text = "\(String(race.distance)) km"
        } else {
            labelDistanceInfo.isHidden = true
        }

        if race.stages.count > 0 {
            //labelRaceType.text = "\(race.stages.count) ETAPAS"
            labelStages.text = "ETAPAS (\(race.stages.count))"
        } else {
            //labelRaceType.text = "CLÁSICA"
            labelStages.text = "ETAPAS (1)"
        }
        labelTeamsInfo.text = "\(race.numTeams)"
        //buttonTeams.setTitle("\(race.numTeams)", for: .normal)
        
        let raceStatus = Utils.getRaceStatus(raceDayStart: dateNumber, raceMonthStart: dateMonth, raceDayEnd: dateNumberEnd, raceMonthEnd: dateMonthEnd)
        
        switch raceStatus {
        case RACE_END:
            viewTitle.backgroundColor = COLOR_ORANGE
            viewStatus.backgroundColor = COLOR_ORANGE
            buttonBet.layer.borderColor = COLOR_ORANGE.cgColor
            buttonBet.setTitleColor(COLOR_ORANGE, for: .normal)
            buttonClassification.backgroundColor = COLOR_ORANGE
            break
        case RACE_ACTIVE:
            viewTitle.backgroundColor = COLOR_ORANGE
            viewStatus.backgroundColor = COLOR_ORANGE
            buttonBet.layer.borderColor = COLOR_ORANGE.cgColor
            buttonBet.setTitleColor(COLOR_ORANGE, for: .normal)
            buttonClassification.backgroundColor = COLOR_ORANGE
            break
        case RACE_INACTIVE:
            viewTitle.backgroundColor = COLOR_GREEN
            viewStatus.backgroundColor = COLOR_GREEN
            buttonBet.layer.borderColor = COLOR_GREEN.cgColor
            buttonBet.setTitleColor(COLOR_GREEN, for: .normal)
            buttonClassification.backgroundColor = COLOR_GREEN
            break
        default:
            viewTitle.backgroundColor = COLOR_GRAY
            viewStatus.backgroundColor = COLOR_GRAY
            buttonBet.layer.borderColor = COLOR_GRAY.cgColor
            buttonBet.setTitleColor(COLOR_GRAY, for: .normal)
            buttonClassification.backgroundColor = COLOR_GRAY
            break
        }
    }
    
    //MARK: UIButton methods
    @IBAction func buttonClose_clicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonWeb_clicked(_ sender: Any) {
    }
    
    @IBAction func buttonTwitter_clicked(_ sender: Any) {
    }
    
    @IBAction func buttonBet_clicked(_ sender: Any) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "BetsTeamsViewController") as! BetsTeamsViewController
        viewController.race = race
        self.navigationParent?.pushViewController(viewController, animated: true)
    }
   
    @IBAction func buttonClassification_clicked(_ sender: Any) {
    }
    
    //MARK: UITableViewDelegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if race.stages.count > 0 {
            return race.stages.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        if race.stages.count > 0 {
            cell.textLabel?.text = "\(indexPath.row+1). \(race.stages[indexPath.row].origin) - \(race.stages[indexPath.row].destiny)"
        } else {
            cell.textLabel?.text = "\(indexPath.row+1). \(race.name)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if race.stages.count > 0 {
            let stage = race.stages[indexPath.row]
            let name = "\(indexPath.row+1). \(race.stages[indexPath.row].origin) - \(race.stages[indexPath.row].destiny)"
            viewStage(stage: stage, stageName: name)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func viewStage (stage: Stage, stageName: String) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "StageViewController") as! StageViewController
        viewController.stage = stage
        viewController.stageName = stageName
        self.navigationParent?.pushViewController(viewController, animated: true)
    }
    
    //MARK: CalendarPresenterOutput methods
    func presenterDidReceiveCalendarRaces(calendarRaces: Array<Race>) {
        
    }
    
    func presenterDidReceiveCalendarRacesError(error: Error) {
        
    }
    
    func presenterDidCheckCalendarRacesUpdates(updated: String) {
        
    }
    
    func presenterDidCheckCalendarRacesUpdatesError(error: Error) {
        
    }
}
