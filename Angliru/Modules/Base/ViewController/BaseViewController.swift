//
//  BaseViewController.swift
//  Angliru
//
//  Created by Juanra Fernández on 04/12/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import UIKit
import Firebase

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            //navigationController?.pushViewController(loginViewController, animated: true)
            navigationController?.setViewControllers([loginViewController], animated: true)
            //self.present(loginViewController, animated: true, completion: nil)
        } catch let error {
            print("Failed to sign out with error..", error)
        }
    }
}
