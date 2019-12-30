//
//  SignInViewController.swift
//  Angliru
//
//  Created by Juanra Fernández on 26/07/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SignInViewController: UIViewController {

    @IBOutlet weak var imageViewUser: UIImageView!
    @IBOutlet weak var textFieldUser: UITextField!
    @IBOutlet weak var viewUserHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewMail: UIImageView!
    @IBOutlet weak var textFieldMail: UITextField!
    @IBOutlet weak var viewMailHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewPassword: UIImageView!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var viewPasswordHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonSignIn: UIButton!
    @IBOutlet weak var buttonGoogleSignIn: UIButton!
    @IBOutlet weak var buttonLogin: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeInterface()
        //GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    func initializeInterface() {
        navigationController?.navigationBar.isHidden = true
        buttonLogin.layer.cornerRadius = 5
        buttonGoogleSignIn.layer.cornerRadius = 5
        textFieldUser.attributedPlaceholder = NSAttributedString(string: "usuario",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textFieldMail.attributedPlaceholder = NSAttributedString(string: "mail",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textFieldPassword.attributedPlaceholder = NSAttributedString(string: "contraseña",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    // MARK interface events
    @IBAction func buttonSignIn_clicked(_ sender: Any) {
        guard let email = textFieldMail.text else { return }
        guard let password = textFieldPassword.text else { return }
        guard let username = textFieldUser.text else { return }
        
        createUser(withEmail: email, password: password, username: username)
    }
    
    @IBAction func buttonGoogleSignIn_clicked(_ sender: Any) {
    GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func buttonLogin_clicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var currentViewController : LoginViewController? = nil
        for viewController in navigationController!.children {
            if(viewController.isKind(of: LoginViewController.self)){
                currentViewController = viewController as? LoginViewController
                break
            }
        }
        if currentViewController == nil {
            currentViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
            navigationController?.pushViewController(currentViewController!, animated: true)
        } else {
            navigationController?.popToViewController(currentViewController!, animated: true)
        }
    }
    
    // MARK: - API
    
    func createUser(withEmail email: String, password: String, username: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            if let error = error {
                print("Failed to sign user up with error: ", error.localizedDescription)
                return
            }
            
            guard let uid = result?.user.uid else { return }
            UserDefaults.standard.set(uid, forKey: CURRENT_UID)
            let values = ["email": email, "username": username]
            
            Firestore.firestore().collection("users").document(uid).setData([
                "username":username,
                "email":email
                ], merge: true, completion: { (err) in
                    if let err = err {
                        print("Error adding document: \(err)")
                        return
                    } else {
                        guard let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else { return }
                        guard let controller = navController.viewControllers[0] as? AccessViewController else { return }
                        //controller.configureViewComponents()
                        
                        // forgot to add this in video
                        controller.loadUserData()
                        
                        self.dismiss(animated: true, completion: nil)
                    }
            })
            
       /* Database.database().reference().child("users").child(uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
                if let error = error {
                    print("Failed to update database values with error: ", error.localizedDescription)
                    return
                }
                
                guard let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else { return }
                guard let controller = navController.viewControllers[0] as? AccessViewController else { return }
                //controller.configureViewComponents()
                
                // forgot to add this in video
                controller.loadUserData()
                
                self.dismiss(animated: true, completion: nil)
            }) */
            
        }
        
    }
}
