//
//  LoginViewController.swift
//  Angliru
//
//  Created by Juanra Fernández on 25/07/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController {

    @IBOutlet weak var imageViewMail: UIImageView!
    @IBOutlet weak var textFieldMail: UITextField!
    @IBOutlet weak var viewMailHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewPassword: UIImageView!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var viewPasswordHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var buttonGoogleLogin: UIButton!
    @IBOutlet weak var buttonSignIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    func initializeInterface() {
        navigationController?.navigationBar.isHidden = true
        buttonLogin.layer.cornerRadius = 10
        buttonGoogleLogin.layer.cornerRadius = 10
        buttonGoogleLogin.layer.borderColor = UIColor.white.cgColor
        buttonGoogleLogin.layer.borderWidth = 1.0
        buttonSignIn.layer.cornerRadius = 10
        buttonSignIn.layer.borderColor = UIColor.white.cgColor
        buttonSignIn.layer.borderWidth = 1.0
        
        textFieldMail.attributedPlaceholder = NSAttributedString(string: "mail",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textFieldPassword.attributedPlaceholder = NSAttributedString(string: "contraseña",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    // MARK: interface events
    
    @IBAction func buttonLogin_clicked(_ sender: Any) {
        guard let email = textFieldMail.text else { return }
        guard let password = textFieldPassword.text else { return }
        
        logUserIn(withEmail: email, password: password)
    }
    
    @IBAction func buttonGoogleLogin_clicked(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func buttonSignIn_clicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        var currentViewController : SignInViewController? = nil
        for viewController in navigationController!.children {
            if(viewController.isKind(of: SignInViewController.self)){
                currentViewController = viewController as? SignInViewController
                break
            }
        }
        
        if currentViewController == nil {
            currentViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController
            navigationController?.pushViewController(currentViewController!, animated: true)
        } else {
            navigationController?.popToViewController(currentViewController!, animated: true)
        }
    }
    
    // MARK: - API
    
    func logUserIn(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if let error = error {
                print("Failed to sign user in with error: ", error.localizedDescription)
                return
            }
            
            guard let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else { return }
            guard let controller = navController.viewControllers[0] as? AccessViewController else { return }
           // controller.configureViewComponents()
            
            // forgot to add this in video
            controller.loadUserData()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func postToken(token: String) {
        print("FCM Token: \(token)")
        //let dbRef = Database.database().reference()
        //dbRef.child("fcmToken").child(Messaging.messaging().fcmToken!).setValue(Token)
        if let uid = UserDefaults.standard.string(forKey: CURRENT_UID) {
            Firestore.firestore().collection("users").document(uid).setData([
                "fcmToken":token
                ], merge: true, completion: { (err) in
                    if let err = err {
                        print("Error adding document: \(err)")
                        return
                    } else {
                        print("Added push notification token")
                    }
            })
        }
    }
}

extension LoginViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print("Failed to sign in with error:", error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        //let token : [String: AnyObject] = [Messaging.messaging().fcmToken!: Messaging.messaging().fcmToken as AnyObject]
        let token = Messaging.messaging().fcmToken!
        
        Auth.auth().signInAndRetrieveData(with: credential) { (result, error) in
            
            if let error = error {
                print("Failed to sign in and retrieve data with error:", error)
                return
            }
            
            guard let uid = result?.user.uid else { return }
            UserDefaults.standard.set(uid, forKey:CURRENT_UID)
            guard let email = result?.user.email else { return }
            guard let username = result?.user.displayName else { return }
            
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
                        
                        self.postToken(token: token)
                        
                        // forgot to add this in video
                        controller.loadUserData()
                        
                        self.dismiss(animated: true, completion: nil)
                    }
            })
            
           /* Database.database().reference().child("users").child(uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
                guard let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else { return }
                guard let controller = navController.viewControllers[0] as? AccessViewController else { return }
               // controller.configureViewComponents()
                
                self.postToken(Token: token)
                
                // forgot to add this in video
                controller.loadUserData()
                
                self.dismiss(animated: true, completion: nil)
            }) */
        }
    }
}
