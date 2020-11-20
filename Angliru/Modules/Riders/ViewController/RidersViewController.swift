//
//  RidersViewController.swift
//  Angliru
//
//  Created by Juanra Fernández on 06/08/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import UIKit
import SVProgressHUD

class RidersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RidersPresenterOutput, UISearchBarDelegate {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var riders = Array<[Rider]>()
    var allRiders = [Rider]()
    var presenter = RidersPresenter()
    var indexedRiders = [String: [Rider]]()
    var indexedRidersFiltered = [String: [Rider]]()
    var riderSectionTitles = [String]()
    let sectionTitles = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeVariables()
        
        tableView.register(UINib(nibName: "RiderInfoCell", bundle: nil), forCellReuseIdentifier: "RiderInfoCell")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        presenter.output = self
        presenter.checkRidersUpdates(season: CURRENT_SEASON)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //SVProgressHUD.show()
        
        //reloadInfo()
    }
    
  
    func initializeVariables() {
        for rider in allRiders {
            let key = String(rider.name.first!)
            
            if var values = indexedRiders[key] {
                values.append(rider)
                indexedRiders[key] = values
            } else {
                indexedRiders[key] = [rider]
            }
        }
        
        riderSectionTitles = [String](indexedRiders.keys)
        riderSectionTitles.sort() { $0 < $1 }
        indexedRidersFiltered = indexedRiders
        tableView.reloadData()
    }
        
    func reloadInfo(cache: Bool) {
        SVProgressHUD.show()
        tableView.reloadData()
        for i in 0..<CATEGORIES.count {
            presenter.getAllRiders(category: CATEGORIES[i], season: CURRENT_SEASON, cache: cache)
        }
    }
    
    //MARK: UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = riderSectionTitles[section]
        let sectionRiders = indexedRidersFiltered[sectionTitle]
        return sectionRiders?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RiderInfoCell", for: indexPath) as! RiderInfoCell
        let sectionTitle = riderSectionTitles[indexPath.section]
        let sectionRiders = indexedRidersFiltered[sectionTitle]
        let rider = sectionRiders![indexPath.row]
        
        cell.imageViewCountry.image = UIImage(named: rider.country)
        cell.labelName.text = rider.name
        
        return cell
    }
    
    // 4
    func numberOfSections(in tableView: UITableView) -> Int {
        //sectionTitles.count
        return riderSectionTitles.count
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return riderSectionTitles
    }
    
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        //sectionTitles[section]
        riderSectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionTitle = riderSectionTitles[indexPath.section]
        let sectionRiders = indexedRidersFiltered[sectionTitle]
        let rider = sectionRiders![indexPath.row]
        viewRiderInfo(rider: rider)
    }
    
    func viewRiderInfo(rider:Rider) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "RiderInfoViewController") as! RiderInfoViewController
        viewController.rider = rider
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: RidersPresenterOutput methods
    
    func presenterDidGetRiderInfo(rider:Rider) {
        SVProgressHUD.dismiss()
    }
    
    func presenterDidGetRiderInfoError(error:Error) {
        SVProgressHUD.dismiss()
    }
    
    func presenterDidGetAllRiders(result:Array<Rider>,category:String) {
        let index = CATEGORIES.firstIndex(of: category)
        //riders[index!] = result
        allRiders.append(contentsOf: result)
        //allRiders = allRiders.sorted { $0.name < $1.name }
        //tableView.reloadData()
        initializeVariables()
        SVProgressHUD.dismiss()
    }
    
    func presenterDidGetAllRidersError(error:Error) {
        SVProgressHUD.dismiss()
    }
    
    func presenterDidCheckRidersUpdates(updated: String) {

        let savedDate = UserDefaults.standard.string(forKey: "\(LAST_UPDATE_RIDERS_KEY)\(CURRENT_SEASON)") ?? ""
        if savedDate == "" || Utils.getDateFrom(stringDate: savedDate) > Utils.getDateFrom(stringDate: updated) {
            //Request info from server
            UserDefaults.standard.set(updated, forKey: "\(LAST_UPDATE_RIDERS_KEY)\(CURRENT_SEASON)")
            //presenter.getCalendarRaces(season: CURRENT_SEASON, cache: false)
            reloadInfo(cache: false)
        } else {
            //presenter.getCalendarRaces(season: CURRENT_SEASON, cache: true)
            reloadInfo(cache: true)
        }
    }
    
    func presenterDidCheckRidersUpdatesError(error: Error) {
        SVProgressHUD.dismiss()
    }
    
    //MARK:UISearchBarDelegate methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            indexedRidersFiltered = indexedRiders
        } else {
            indexedRidersFiltered = [String: [Rider]]()
            for section in riderSectionTitles {
                let sectionRiders = indexedRiders[section]?.filter({$0.name.uppercased().contains(searchText.uppercased())})
                if sectionRiders!.count > 0 {
                    indexedRidersFiltered[section] = sectionRiders
                }
            }
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
