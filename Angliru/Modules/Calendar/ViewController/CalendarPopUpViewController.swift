//
//  CalendarPopUpViewController.swift
//  Angliru
//
//  Created by Juanra Fernández on 30/12/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import UIKit

class CalendarPopUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CalendarPresenterOutput{
    
    @IBOutlet weak var viewPopUpHeightConstraint: NSLayoutConstraint!
    @IBOutlet var viewBackground: UIView!
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var viewTargetShadow: UIView!
    @IBOutlet weak var viewTarget: UIView!
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var labelMonth: UILabel!
    @IBOutlet weak var labelYear: UILabel!
    @IBOutlet weak var labelDay: UILabel!
    @IBOutlet weak var labelRaceName: UILabel!
    @IBOutlet weak var labelRaceDate: UILabel!
    @IBOutlet weak var labelRaceType: UILabel!
    @IBOutlet weak var labelRaceCountry: UIImageView!
    @IBOutlet weak var labelRaceDistance: UILabel!
    @IBOutlet weak var viewRaceStatus: UIView!
    @IBOutlet weak var labelRaceStatus: UILabel!
    @IBOutlet weak var labelTeams: UILabel!
    @IBOutlet weak var buttonTeams: UIButton!
    @IBOutlet weak var labelWeb: UILabel!
    @IBOutlet weak var buttonWeb: UIButton!
    @IBOutlet weak var labelSocialNetworks: UILabel!
    @IBOutlet weak var buttonTwitter: UIButton!
    @IBOutlet weak var buttonFacebook: UIButton!
    @IBOutlet weak var labelStages: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonBet: UIButton!
    @IBOutlet weak var buttonClassification: UIButton!
    
    var race = Race()
    var presenter = CalendarPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeInterfaz()
        fillRaceData()
    }
    
    func initializeInterfaz() {
        buttonBet.layer.cornerRadius = 15
        buttonClassification.layer.cornerRadius = 15
        buttonBet.layer.borderColor = COLOR_GRAY.cgColor
        buttonBet.layer.borderWidth = 2
        
        viewRaceStatus.layer.cornerRadius = 10
        viewPopup.layer.cornerRadius = 10
        viewTarget.layer.cornerRadius = 10
        viewTargetShadow.layer.cornerRadius = 10
        viewTargetShadow.layer.cornerRadius = 10
        
        viewTargetShadow.layer.shadowColor = UIColor.gray.cgColor
        viewTargetShadow.layer.shadowOpacity = 0.3
        viewTargetShadow.layer.shadowOffset = CGSize.zero
        viewTargetShadow.layer.shadowRadius = 6
        
        labelRaceName.text = race.name
        //viewBackground.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
        viewTarget.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
        viewTarget.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
        
        presenter.output = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        var viewExtra = viewPopUpHeightConstraint.constant
        if race.stages.count>1 {
            viewExtra = viewPopUpHeightConstraint.constant + CGFloat((race.stages.count - 1) * 54)
        }
        let maxSize = UIScreen.main.bounds.size.height - 80
        
        if viewExtra >= maxSize {
            viewPopUpHeightConstraint.constant = maxSize
        } else {
            viewPopUpHeightConstraint.constant = viewExtra
        }
    }
    
    @objc func dismissOnTapOutside(){
       self.dismiss(animated: true, completion: nil)
    }
    
    func fillRaceData() {
        var position = race.dateStart.firstIndex(of: ".") ?? race.dateStart.endIndex
        let dateNumber = String(race.dateStart[..<position])
        position = race.dateStart.index(position, offsetBy: 1)
        let dateMonth = String(race.dateStart[position...])
        
        labelDay.text = dateNumber
        labelMonth.text = MONTHS_SHORT[Int(dateMonth)!-1]
        var dateNumberEnd = ""
        var dateMonthEnd = ""
        if race.dateEnd != "" {
            var positionEnd = race.dateEnd.firstIndex(of: ".") ?? race.dateEnd.endIndex
            dateNumberEnd = String(race.dateEnd[..<positionEnd])
            positionEnd = race.dateEnd.index(positionEnd, offsetBy: 1)
            dateMonthEnd = String(race.dateEnd[positionEnd...])
            labelRaceDate.text = "\(dateNumber) \(MONTHS_SHORT[Int(dateMonth)!]) - \(dateNumberEnd) \(MONTHS_SHORT[Int(dateMonthEnd)!])"
        } else {
            labelRaceDate.text = "\(dateNumber) \(MONTHS_SHORT[Int(dateMonth)!])"
        }
        if race.distance != 0 {
            labelRaceDistance.isHidden = false
            labelRaceDistance.text = "\(String(race.distance)) km"
        } else {
            labelRaceDistance.isHidden = true
        }

        if race.stages.count > 0 {
            labelRaceType.text = "\(race.stages.count) ETAPAS"
            labelStages.text = "ETAPAS (\(race.stages.count))"
        } else {
            labelRaceType.text = "CLÁSICA"
            labelStages.text = "ETAPAS (1)"
        }
        
        buttonTeams.setTitle("\(race.teams.count)", for: .normal)
    }
    
    @IBAction func buttonTeams_clicked(_ sender: Any) {
    
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
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    //MARK: CalendarPresenterOutput methods
    func presenterDidReceiveCalendarRaces(calendarRaces: Array<Race>) {
        
    }
    
    func presenterDidReceiveCalendarRacesError(error: Error) {
        
    }
}
