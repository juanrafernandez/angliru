//
//  AccessViewController.swift
//  Angliru
//
//  Created by Juanra Fernández on 25/07/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import UIKit
import Firebase
import RAMAnimatedTabBarController

class AccessViewController: UIViewController {

    // MARK: - Properties
    
    var welcomeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        authenticateUserAndConfigureView()
    }
    
    func authenticateUserAndConfigureView() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                let navController = UINavigationController(rootViewController: loginViewController)
                navController.navigationBar.barStyle = .blackTranslucent
                self.present(navController, animated: false, completion: nil)
            }
        } else {
            configureViewComponents()
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
                self.welcomeLabel.text = "Bienvenido, \(username)"
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.welcomeLabel.alpha = 1
                })
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    //let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
                    let tabBarController = storyboard.instantiateViewController(withIdentifier: "RAMAnimatedTabBarController")
                    self.navigationController?.pushViewController(tabBarController, animated: true)
                    
                })
            } else {
                print("User does not exist")
            }
        }
    }
        
        
      /*  Database.database().reference().child("users").child(uid).child("username").observeSingleEvent(of: .value) { (snapshot) in
            guard let username = snapshot.value as? String else { return }
            print(username)
            self.welcomeLabel.text = "Bienvenido, \(username)"
            
            UIView.animate(withDuration: 0.5, animations: {
                self.welcomeLabel.alpha = 1
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                //let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
                let tabBarController = storyboard.instantiateViewController(withIdentifier: "RAMAnimatedTabBarController")
                self.navigationController?.pushViewController(tabBarController, animated: true)
                
            })
        }
    } */
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            navigationController?.pushViewController(loginViewController, animated: true)
            
            //let navController = UINavigationController(rootViewController: LoginViewController())
            //navController.navigationBar.barStyle = .black
            self.present(loginViewController, animated: true, completion: nil)
        } catch let error {
            print("Failed to sign out with error..", error)
        }
    }
    
    func configureViewComponents() {
        view.backgroundColor = UIColor.blue
                
        navigationItem.title = "Firebase Login"
        
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        
        view.addSubview(welcomeLabel)
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
