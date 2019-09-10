//
//  CalendarCell.swift
//  Angliru
//
//  Created by Juanra Fernández on 31/07/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import FoldingCell
import UIKit

class CalendarCell: FoldingCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var closeNumberLabel: UILabel!
    @IBOutlet var openNumberLabel: UILabel!
    @IBOutlet weak var labelTitleDateNumber: UILabel!
    @IBOutlet weak var labelTitleDateMonth: UILabel!
    @IBOutlet weak var labelTitleName: UILabel!
    @IBOutlet weak var labelTitleDate: UILabel!
    @IBOutlet weak var labelTitleDistance: UILabel!
    @IBOutlet weak var labelTitleNumberStages: UILabel!
    @IBOutlet weak var labelTitleRaceStatus: UILabel!
    @IBOutlet weak var imageViewFlag: UIImageView!
    @IBOutlet weak var labelExtensionTitle: UILabel!
    @IBOutlet weak var labelExtensionDateFromTitle: UILabel!
    @IBOutlet weak var labelExtensionDateFrom: UILabel!
    @IBOutlet weak var labelExtensionDateToTitle: UILabel!
    @IBOutlet weak var labelExtensionDateTo: UILabel!
    @IBOutlet weak var labelExtensionDistanceTitle: UILabel!
    @IBOutlet weak var labelExtensionDistance: UILabel!
    @IBOutlet weak var labelExtensionInformation: UILabel!
    @IBOutlet weak var labelExtensionInfoStages: UILabel!
    @IBOutlet weak var labelExtensionInfoTeams: UILabel!
    @IBOutlet weak var labelExtensionInfoStatus: UILabel!
    @IBOutlet weak var buttonTwitter: UIButton!
    @IBOutlet weak var buttonWeb: UIButton!
    @IBOutlet weak var buttonShowTeams: UIButton!
    @IBOutlet weak var buttonWebHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelStages: UILabel!
    @IBOutlet weak var tableViewStages: UITableView!
    @IBOutlet weak var buttonClassifications: UIButton!
    @IBOutlet weak var labelTitleDateTopConstraint: NSLayoutConstraint!
    var webURL = ""
    var twitterURL = ""
    var stages = Array<String>()
    var actionClassificationBlock: (() -> Void)? = nil
    var actionStageBlock: ((String) -> Void)? = nil
    var actionShowTeamsBlock: (() -> Void)? = nil
    
   /* var number: Int = 0 {
        didSet {
            closeNumberLabel.text = String(number)
            openNumberLabel.text = String(number)
        }
    }*/
    
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        tableViewStages.delegate = self
        tableViewStages.dataSource = self
        super.awakeFromNib()
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
    
    func setStages (newStages: Array<String>) {
        stages = newStages
        tableViewStages.reloadData()
    }
    
    // MARK: - Actions ⚡️
    @IBAction func buttonClassification_clicked(sender: UIButton) {
        actionClassificationBlock?()
    }
    
    @IBAction func buttonTwitter_clicked(_ sender: Any) {
        if twitterURL != "" {
            Utils.launchSafari(decodedURL: twitterURL)
        }
    }
    
    @IBAction func buttonWeb_clicked(_ sender: Any) {
        if webURL != "" {
            Utils.launchSafari(decodedURL: webURL)
        }
    }
    
    @IBAction func buttonShowTeams_clicked(_ sender: Any) {
        actionShowTeamsBlock?()
    }
    
    
    //MARK: UITableViewDelegate methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StageCell", for: indexPath) as! StageCell
        let stage = stages[indexPath.row]
        cell.labelStageName.text = stage
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(stages[indexPath.row]) seleccionada!")
        actionStageBlock?(stages[indexPath.row])
    }
    
}
