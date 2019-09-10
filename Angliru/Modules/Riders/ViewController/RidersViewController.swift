//
//  RidersViewController.swift
//  Angliru
//
//  Created by Juanra Fernández on 06/08/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import UIKit
import SVProgressHUD

class RidersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RidersPresenterOutput {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var riders = Array<[Rider]>()
    var presenter = RidersPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        presenter.output = self
        initializeVariables()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SVProgressHUD.show()
        
        reloadInfo()
    }
    
    func initializeVariables (){
        for _ in 0..<CATEGORIES.count {
            let auxRider = [Rider]()
            riders.append(auxRider)
        }
    }
    
    func reloadInfo() {
        SVProgressHUD.show()
        tableView.reloadData()
        for i in 0..<CATEGORIES.count {
            presenter.getAllRiders(category: CATEGORIES[i], season: "2019")
        }
    }
    
    // MARK: TableView delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return CATEGORIES.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return riders[section].count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return CATEGORIES[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = riders[indexPath.section][indexPath.row].name
        cell.imageView?.image = UIImage(named: riders[indexPath.section][indexPath.row].country)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //viewRiderInfo(rider: riders[indexPath.section][indexPath.row])
    }
    
    func viewRiderInfo(rider:Rider) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "RiderInfoViewController") as! RiderInfoViewController
        //viewController.rider = rider
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
        riders[index!] = result
        tableView.reloadData()
        SVProgressHUD.dismiss()
    }
    
    func presenterDidGetAllRidersError(error:Error) {
        SVProgressHUD.dismiss()
    }
}
