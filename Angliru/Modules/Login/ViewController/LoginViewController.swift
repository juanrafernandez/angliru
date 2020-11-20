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

class LoginViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var viewMailSeparator: UIView!
    @IBOutlet weak var viewPasswordSeparator: UIView!
    @IBOutlet weak var labelMail: UILabel!
    @IBOutlet weak var textFieldMail: UITextField!
    @IBOutlet weak var labelMailError: UILabel!
    @IBOutlet weak var buttonMailClean: UIButton!
    @IBOutlet weak var viewMailHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var labelPassword: UILabel!
    @IBOutlet weak var labelPasswordError: UILabel!
    @IBOutlet weak var buttonPasswordShow: UIButton!
    @IBOutlet weak var viewPasswordHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var buttonGoogleLogin: UIButton!
    @IBOutlet weak var buttonSignIn: UIButton!
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var imageLogoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageLogoWidthConstraint: NSLayoutConstraint!
    var showing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        //GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func initializeInterface() {
        navigationController?.navigationBar.isHidden = true
        buttonLogin.layer.cornerRadius = 10
//        buttonGoogleLogin.layer.cornerRadius = 10
//        buttonGoogleLogin.layer.borderColor = UIColor.white.cgColor
//        buttonGoogleLogin.layer.borderWidth = 1.0
        buttonSignIn.layer.cornerRadius = 10
        buttonSignIn.layer.borderColor = UIColor.white.cgColor
        buttonSignIn.layer.borderWidth = 1.0
        setUpTextFields()
    }
    
    func setUpTextFields() {
        textFieldMail.delegate = self
        textFieldPassword.delegate = self

        //textFieldMail.clearButtonMode = .always
        //textFieldMail.clearButtonMode = .whileEditing
        //textFieldPassword.clearButtonMode = .always
        //textFieldPassword.clearButtonMode = .whileEditing
        textFieldMail.tintColor = .white
        textFieldPassword.tintColor = .white
        
//        let clearButton = UIButton(type: .custom)
//        clearButton.setImage(UIImage(named:"ic_clear_text"), for: .normal)
//        clearButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
//        clearButton.contentMode = .scaleAspectFit
//        clearButton.addTarget(self, action: #selector(clear(sender:)), for: .touchUpInside)
//        textFieldMail.rightView = clearButton
//        textFieldMail.rightViewMode = .whileEditing
//        textFieldPassword.rightView = clearButton
//        textFieldPassword.rightViewMode = .whileEditing
                
        textFieldMail.attributedPlaceholder = NSAttributedString(string: "Correo electrónico",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textFieldPassword.attributedPlaceholder = NSAttributedString(string: "Contraseña",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    @objc func clear(sender : AnyObject) {
        let textField = sender.superview as! UITextField
        textField.text = ""
    }
    
    func showKeyboard(show: Bool) {
        UIView.animate(withDuration: 0.2) {
            var t = self.imageLogo.transform
            if show && !self.showing {
                t = t.scaledBy(x: 0.5, y: 0.5)
                self.showing = true
            } else if !show && self.showing{
                t = t.scaledBy(x: 2, y: 2)
                self.showing = false
            }
            //t = t.rotated(by: CGFloat(M_PI_4))
            self.imageLogo.transform = t;
        }
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
    
    @IBAction func buttonMailClean_clicked(_ sender: Any) {
        textFieldMail.text = ""
    }
    
    @IBAction func buttonPasswordShow_clicked(_ sender: Any) {
        textFieldPassword.isSecureTextEntry = !textFieldPassword.isSecureTextEntry
    }
    
    @IBAction func buttonSignIn_clicked(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        
//        var currentViewController : SignInViewController? = nil
//        for viewController in navigationController!.children {
//            if(viewController.isKind(of: SignInViewController.self)){
//                currentViewController = viewController as? SignInViewController
//                break
//            }
//        }
//        
//        if currentViewController == nil {
//            currentViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController
//            navigationController?.pushViewController(currentViewController!, animated: true)
//        } else {
//            navigationController?.popToViewController(currentViewController!, animated: true)
//        }
    }
    
    // MARK: - TextFieldDelegate methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //imageLogoHeightConstraint.constant = 35
        //imageLogoWidthConstraint.constant = 80
        showKeyboard(show: true)
        if textFieldMail == textField{
            labelMail.isHidden = false
            buttonMailClean.isHidden = false
            viewMailHeightConstraint.constant = 2
            //viewMailSeparator.backgroundColor = COLOR_ORANGE
        } else {
            labelPassword.isHidden = false
            buttonPasswordShow.isHidden = false
            viewPasswordHeightConstraint.constant = 2
            //viewPasswordSeparator.backgroundColor = COLOR_ORANGE
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //imageLogoHeightConstraint.constant = 58
        //imageLogoWidthConstraint.constant = 177
        
        if textFieldMail == textField{
            if textFieldMail.text == "" {
                labelMail.isHidden = true
                buttonMailClean.isHidden = true
            }
            viewMailHeightConstraint.constant = 1
            //viewMailSeparator.backgroundColor = UIColor.white
        } else {
            if textFieldPassword.text == "" {
                labelPassword.isHidden = true
                buttonPasswordShow.isHidden = true
            }
            viewPasswordHeightConstraint.constant = 1
            //viewPasswordSeparator.backgroundColor = UIColor.white
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textFieldMail == textField{
            textFieldPassword.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            showKeyboard(show: false)
        }
        
        if textFieldPassword.text != "" && textFieldMail.text != "" {
            buttonLogin.backgroundColor = UIColor.white
        }
        
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textFieldPassword.text != "" && textFieldMail.text != "" {
            buttonLogin.backgroundColor = UIColor.white
        } else {
            buttonLogin.backgroundColor = COLOR_GRAY_ALPHA
        }
    }
    
    // MARK: - API
    
    func logUserIn(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if let error = error {
                self.showAlert(title: "No se ha podido acceder", message: "Comprueba que has introducido correctamente el usuario y la contraseña de Angliru", buttonText: "Volver a acceder")
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
        }
    }
}
