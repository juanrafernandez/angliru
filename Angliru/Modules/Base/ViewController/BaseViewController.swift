//
//  BaseViewController.swift
//  Angliru
//
//  Created by Juanra Fernández on 04/12/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

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
    
    func setNavigationBar() {

        self.navigationItem.setHidesBackButton(true, animated:false)

        //your custom view for back image with custom size
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let imageView = UIImageView(frame: CGRect(x: -5, y: 10, width: 20, height: 20))

        if let imgBackArrow = UIImage(named: "ic_back_green") {
            imageView.image = imgBackArrow
        }
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)

        let backTap = UITapGestureRecognizer(target: self, action: #selector(backToMain))
        view.addGestureRecognizer(backTap)

        let leftBarButtonItem = UIBarButtonItem(customView: view ?? UIView())
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func backToMain() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAlert(title:String, message:String, buttonText: String) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: buttonText, style: .default))
        alertController.view.tintColor = COLOR_GREEN
        self.present(alertController, animated: true, completion: nil)
    }
}
