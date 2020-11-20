//
//  AccessViewController.swift
//  Angliru
//
//  Created by Juanra Fernández on 25/07/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import UIKit
import Firebase

class AccessViewController: UIViewController {

    // MARK: - Properties
    let imageView = UIImageView()
    let imageViewEnd = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        runInitialAnimation()
    }
    
    func authenticateUserAndConfigureView() {
        //configureViewComponents()
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                var currentViewControllers = self.navigationController?.viewControllers
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                let navController = UINavigationController(rootViewController: loginViewController)
                //navController.navigationBar.barStyle = .blackTranslucent
                currentViewControllers?.append(loginViewController)
                //self.present(navController, animated: false, completion: nil)
                self.navigationController?.setViewControllers(currentViewControllers!, animated: false)

            }
        } else {
            //configureViewComponents()
            loadUserData()
            //signOut()
        }
    }
    
    func loadUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserDefaults.standard.set(uid, forKey:CURRENT_UID)
        
        Firestore.firestore().collection("users").document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                let username = document.data()!["username"] as? String ?? ""
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let tabBarController = storyboard.instantiateViewController(withIdentifier: "BubbleTabBarController")
                    //self.navigationController?.pushViewController(tabBarController, animated: true)
                    self.navigationController?.setViewControllers([tabBarController], animated: true)
                    
                   // self.signOut()
                })
            } else {
                print("User does not exist")
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            navigationController?.setViewControllers([loginViewController], animated: true)
        } catch let error {
            print("Failed to sign out with error..", error)
        }
    }
    
    func runInitialAnimation() {
        view.backgroundColor = UIColor(displayP3Red: 240/255, green: 119/255, blue: 68/255, alpha: 1)
        
        imageView.frame = view.frame
        imageView.alpha = 0.3
        imageViewEnd.frame = view.frame
        imageViewEnd.alpha = 0
        let random = arc4random_uniform(3)

        switch random {
          case 0:
              imageView.image = UIImage(named: "00_Splash_A.png")
          case 1:
              imageView.image = UIImage(named: "00_Splash_B.png")
          default:
              imageView.image = UIImage(named: "00_Splash_C.png")
        }
        //imageView.image = UIImage(named: "00_Splash_C.png")
        imageViewEnd.image = UIImage(named: "00_Splash_E.png")
        
        navigationItem.title = "Firebase Login"
        navigationItem.leftBarButtonItem?.tintColor = .white
        view.addSubview(imageView)
        view.addSubview(imageViewEnd)
        runFadeInAnimation()
    }
    
    func runFadeInAnimation () {
        UIView.animate(withDuration: 2, delay: 0.0, options: .curveEaseIn, animations: {
             self.imageView.alpha = 1
        }) { (done) in
            if Auth.auth().currentUser == nil {
                self.runFadeOutAnimation()
            } else {
                self.loadUserData()
            }
        }
    }
    
    func runFadeOutAnimation () {
        UIView.animate(withDuration: 1, delay: 0.5, options: .curveEaseOut, animations: {
            self.imageView.alpha = 0.0
            self.view.backgroundColor = UIColor.black
            self.imageViewEnd.alpha = 1.0
        }) { (done) in
            self.authenticateUserAndConfigureView()
        }
    }
}
