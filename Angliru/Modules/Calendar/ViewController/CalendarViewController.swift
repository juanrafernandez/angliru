//
//  CalendarViewController.swift
//  Angliru
//
//  Created by Juanra Fernández on 31/07/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import UIKit
import FoldingCell
import SVProgressHUD

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CalendarPresenterOutput {

    @IBOutlet weak var tableView: UITableView!
    
    enum Const {
        static let closeCellHeight: CGFloat = 110
        static let openCellHeight: CGFloat = 488
        static let rowsCount = 10
    }
    
    var cellHeights: [CGFloat] = []
    var races = Array<Race>()
    var presenter = CalendarPresenter()
    var cellOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: Helpers
    private func setup() {
        presenter.output = self
        SVProgressHUD.show()
        presenter.getCalendarRaces(season: "2019")
        //cellHeights = Array(repeating: Const.closeCellHeight, count: Const.rowsCount)
        tableView.estimatedRowHeight = Const.closeCellHeight
        tableView.rowHeight = UITableView.automaticDimension
        //tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        if #available(iOS 10.0, *) {
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
    }
    
    // MARK: Actions
    @objc func refreshHandler() {
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
            if #available(iOS 10.0, *) {
                self?.tableView.refreshControl?.endRefreshing()
            }
            self?.tableView.reloadData()
        })
    }
    
    //MARK: UITableViewDelegate methods
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return races.count
    }
    
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as CalendarCell = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == Const.closeCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
        //cell.number = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! CalendarCell
        let race = races[indexPath.row]
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        cell.labelTitleName.text = race.name
        
        let numberOfLines = Utils.getNumberOfLinesInLabel(label: cell.labelTitleName, text: "\(race.name)   ")
        if numberOfLines >= 2 {
            cell.labelTitleDateTopConstraint.constant = 5
        } else {
            cell.labelTitleDateTopConstraint.constant = 15
        }
        
        var position = race.dateStart.firstIndex(of: ".") ?? race.dateStart.endIndex
        let dateNumber = String(race.dateStart[..<position])
        position = race.dateStart.index(position, offsetBy: 1)
        let dateMonth = String(race.dateStart[position...])
        
        cell.labelTitleDateNumber.text = dateNumber
        cell.labelTitleDateMonth.text = MONTHS_SHORT[Int(dateMonth)!-1]
        var dateNumberEnd = ""
        var dateMonthEnd = ""
        if race.dateEnd != "" {
            var positionEnd = race.dateEnd.firstIndex(of: ".") ?? race.dateEnd.endIndex
            dateNumberEnd = String(race.dateEnd[..<positionEnd])
            positionEnd = race.dateEnd.index(positionEnd, offsetBy: 1)
            dateMonthEnd = String(race.dateEnd[positionEnd...])
            cell.labelTitleDate.text = "\(dateNumber) \(MONTHS_SHORT[Int(dateMonth)!]) - \(dateNumberEnd) \(MONTHS_SHORT[Int(dateMonthEnd)!])"
        } else {
            cell.labelTitleDate.text = "\(dateNumber) \(MONTHS_SHORT[Int(dateMonth)!])"
        }
        if race.distance != 0 {
            cell.labelTitleDistance.isHidden = false
            cell.labelTitleDistance.text = "\(String(race.distance)) km"
        } else {
            cell.labelTitleDistance.isHidden = true
        }
        
        if race.stages.count > 0 {
            cell.labelTitleNumberStages.text = "\(race.stages.count) Etapas"
        } else {
            cell.labelTitleNumberStages.text = "Clásica"
        }
        
        cell.labelExtensionTitle.text = race.name
        cell.labelExtensionDateFrom.text = "\(dateNumber) \(MONTHS_SHORT[Int(dateMonth)!])"
        if race.dateEnd != "" {
            cell.labelExtensionDateTo.isHidden = false
            cell.labelExtensionDateTo.text = "\(dateNumberEnd) \(MONTHS_SHORT[Int(dateMonthEnd)!])"
        } else {
            cell.labelExtensionDateTo.isHidden = true
        }
        cell.labelExtensionDistance.text = "\(String(race.distance)) km"
        
        if race.stages.count > 0 {
            cell.labelExtensionInfoStages.text = "Carrera de \(race.stages.count) etapas"
        } else {
            cell.labelExtensionInfoStages.text = "Carrera de una etapa"
        }
        
        cell.setStages(newStages: race.stages)
        cell.labelExtensionInfoTeams.text = "Participan \(race.teams.count) Equipos"
        cell.labelExtensionInfoStatus.text = "Finalizada"
        
        if race.web != "" {
            cell.webURL = race.web
            cell.buttonWeb.isHidden = false
            cell.buttonWebHeightConstraint.constant = 30
        } else {
            cell.buttonWeb.isHidden = true
            cell.buttonWebHeightConstraint.constant = 0
        }
        if race.twitter != "" {
            cell.twitterURL = race.twitter
            cell.buttonTwitter.isHidden = false
        } else {
            cell.buttonTwitter.isHidden = true
        }
        cell.actionClassificationBlock = {
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ClassificationViewController") as! ClassificationViewController
            viewController.raceName = race.name
            viewController.season = "2019"
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        cell.actionStageBlock = { (result : String) in
            
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "StageViewController") as! StageViewController
            viewController.stageName = result
            viewController.raceName = race.name
            viewController.season = "2019"
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        cell.actionShowTeamsBlock = {
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "BetsTeamsViewController") as! BetsTeamsViewController
            viewController.race = race 
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        return cell
    }
    
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! CalendarCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == Const.closeCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = Const.openCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = Const.closeCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
            
            // fix https://github.com/Ramotion/folding-cell/issues/169
            if ((cell.frame.maxY > tableView.frame.maxY) && !self.cellOpen) {
                self.cellOpen = true
                tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
            } else if ((cell.frame.maxY > tableView.frame.maxY) && self.cellOpen) {
                self.cellOpen = false
            }
        }, completion: nil)
    }
    
    //MARK: CalendarPresenterOutput methods
    
    func presenterDidReceiveCalendarRaces(calendarRaces: Array<Race>) {
        races = calendarRaces.sorted{$0.position < $1.position}
        
        cellHeights = Array(repeating: Const.closeCellHeight, count: races.count)
        tableView.reloadData()
        SVProgressHUD.dismiss()
    }
    
    func presenterDidReceiveCalendarRacesError(error:Error) {
        SVProgressHUD.dismiss()
    }
}
