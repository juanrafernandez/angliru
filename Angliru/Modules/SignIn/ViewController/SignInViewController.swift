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
import SVProgressHUD

class SignInViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var labelInstructions: UILabel!
    @IBOutlet weak var labelUser: UILabel!
    @IBOutlet weak var textFieldUser: UITextField!
    @IBOutlet weak var viewUserHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewUserSeparator: UIView!
    @IBOutlet weak var labelUserError: UILabel!
    @IBOutlet weak var buttonUserClean: UIButton!
    @IBOutlet weak var labelMail: UILabel!
    @IBOutlet weak var textFieldMail: UITextField!
    @IBOutlet weak var viewMailHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewMailSeparator: UIView!
    @IBOutlet weak var labelMailError: UILabel!
    @IBOutlet weak var buttonMailClean: UIButton!
    @IBOutlet weak var labelPassword: UILabel!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var viewPasswordHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewPasswordSeparator: UIView!
    @IBOutlet weak var labelPasswordError: UILabel!
    @IBOutlet weak var buttonPasswordClean: UIButton!
    @IBOutlet weak var buttonPasswordShow: UIButton!
    @IBOutlet weak var labelRePassword: UILabel!
    @IBOutlet weak var textFieldRePassword: UITextField!
    @IBOutlet weak var viewRePasswordHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewRePasswordSeparator: UIView!
    @IBOutlet weak var labelRePasswordError: UILabel!
    @IBOutlet weak var buttonRePasswordClean: UIButton!
    @IBOutlet weak var buttonRePasswordShow: UIButton!
    @IBOutlet weak var buttonSignIn: UIButton!
    @IBOutlet weak var buttonLogin: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeInterface()
        //GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    func initializeInterface() {
        self.setNavigationBar()
        
        buttonLogin.layer.cornerRadius = 5
        //buttonGoogleSignIn.layer.cornerRadius = 5
        buttonSignIn.layer.cornerRadius = 10
        textFieldUser.delegate = self
        textFieldMail.delegate = self
        textFieldPassword.delegate = self
        textFieldRePassword.delegate = self
        
        textFieldUser.attributedPlaceholder = NSAttributedString(string: "Nombre de usuario",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textFieldMail.attributedPlaceholder = NSAttributedString(string: "Correo electrónico",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textFieldPassword.attributedPlaceholder = NSAttributedString(string: "Contraseña",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textFieldRePassword.attributedPlaceholder = NSAttributedString(string: "Repetir contraseña",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    // MARK interface events
    
    @IBAction func buttonUserClean_clicked(_ sender: Any) {
        labelUser.isHidden = false
        labelUserError.isHidden = true
        textFieldUser.text = ""
    }
    
    @IBAction func buttonMailClean_clicked(_ sender: Any) {
        labelMail.isHidden = false
        labelMailError.isHidden = true
        textFieldMail.text = ""
    }
    
    @IBAction func buttonPasswordClean_clicked(_ sender: Any) {
        labelPassword.isHidden = false
        labelPasswordError.isHidden = true
        textFieldPassword.text = ""
    }
    
    @IBAction func buttonRePasswordClean_clean(_ sender: Any) {
        labelRePassword.isHidden = false
        labelRePasswordError.isHidden = true
        textFieldRePassword.text = ""
    }
    
    @IBAction func buttonPasswordShow_clicked(_ sender: Any) {
        textFieldPassword.isSecureTextEntry = textFieldPassword.isSecureTextEntry
    }
    
    @IBAction func buttonRePasswordShow_clicked(_ sender: Any) {
        textFieldRePassword.isSecureTextEntry = !textFieldRePassword.isSecureTextEntry
    }
    
    @IBAction func buttonSignIn_clicked(_ sender: Any) {
        let email = textFieldMail.text
        if email != "" {
            labelMailError.isHidden = true
        } else {
            labelMailError.textColor = .red
            labelMailError.text = "Campo obligatorio"
            labelMailError.isHidden = false
            return
        }
        
        let password = textFieldPassword.text
        if password != "" {
            labelPasswordError.isHidden = true
        }
        else {
            labelPasswordError.textColor = .red
            labelPasswordError.text = "Campo obligatorio"
            labelPasswordError.isHidden = false
            return
        }
        
        let rePassword = textFieldRePassword.text
        if rePassword != "" {
            labelRePasswordError.isHidden = true
        } else {
            labelRePasswordError.textColor = .red
            labelRePasswordError.text = "Campo obligatorio"
            labelRePasswordError.isHidden = false
            return
        }
        
        let username = textFieldUser.text
        if username != "" {
            labelUserError.isHidden = false
        } else {
            labelUserError.textColor = .red
            labelUserError.text = "Campo obligatorio"
            labelUserError.isHidden = false
            return
        }
        
        if password == rePassword {
            labelRePasswordError.isHidden = true
            SVProgressHUD.show()
            createUser(withEmail: email!, password: password!, username: username!)
        } else {
            labelRePasswordError.text = "Contraseña errónea"
            labelRePasswordError.textColor = .red
            labelRePasswordError.isHidden = false
        }
        
    }
    
//    @IBAction func buttonGoogleSignIn_clicked(_ sender: Any) {
//    GIDSignIn.sharedInstance()?.signIn()
//    }
    
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
                SVProgressHUD.dismiss()
                self.showAlert(title: "", message: error.localizedDescription, buttonText: "Aceptar")
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
    
    //MARK: UITextFieldDelegate methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == textFieldUser {
            labelUserError.isHidden = true
            labelUser.isHidden = false
            buttonUserClean.isHidden = false
            viewUserHeightConstraint.constant = 2
            viewUserSeparator.backgroundColor = .black
        } else if textField == textFieldMail {
            labelMailError.isHidden = true
            labelMail.isHidden = false
            buttonMailClean.isHidden = false
            viewMailHeightConstraint.constant = 2
            viewMailSeparator.backgroundColor = .black
        } else if textField == textFieldPassword {
            labelPasswordError.isHidden = true
            labelPassword.isHidden = false
            buttonPasswordClean.isHidden = false
            buttonPasswordShow.isHidden = false
            viewPasswordHeightConstraint.constant = 2
            viewPasswordSeparator.backgroundColor = .black
        } else if textField == textFieldRePassword {
            labelRePasswordError.isHidden = true
            labelRePassword.isHidden = false
            buttonRePasswordClean.isHidden = false
            buttonRePasswordShow.isHidden = false
            viewRePasswordHeightConstraint.constant = 2
            viewRePasswordSeparator.backgroundColor = .black
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == textFieldUser {
            viewUserHeightConstraint.constant = 1
            viewUserSeparator.backgroundColor = COLOR_GRAY
            if textField.text == "" {
                labelUser.isHidden = true
                buttonUserClean.isHidden = true
            } else {
                labelUser.isHidden = false
                buttonUserClean.isHidden = false
            }
            
        } else if textField == textFieldMail {
            viewMailHeightConstraint.constant = 1
            viewMailSeparator.backgroundColor = COLOR_GRAY
            if textField.text == "" {
                labelMail.isHidden = true
                buttonMailClean.isHidden = true
            } else {
                labelMail.isHidden = false
                buttonMailClean.isHidden = false
            }
            
        } else if textField == textFieldPassword {
            viewPasswordHeightConstraint.constant = 1
            viewPasswordSeparator.backgroundColor = COLOR_GRAY
            if textField.text == "" {
                labelPassword.isHidden = true
                buttonPasswordClean.isHidden = true
                buttonPasswordShow.isHidden = true
            } else {
                labelPassword.isHidden = false
                buttonPasswordClean.isHidden = false
                buttonPasswordShow.isHidden = false
            }
            
        } else if textField == textFieldRePassword {
            viewRePasswordHeightConstraint.constant = 1
            viewRePasswordSeparator.backgroundColor = COLOR_GRAY
            if textField.text == "" {
                labelRePassword.isHidden = true
                buttonRePasswordClean.isHidden = true
                buttonRePasswordShow.isHidden = true
            } else {
                labelRePassword.isHidden = false
                buttonRePasswordClean.isHidden = false
                buttonRePasswordShow.isHidden = false
            }
    
        }
        checkAllFillds()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func checkAllFillds() {
        if textFieldUser.text != "" && textFieldMail.text != "" && textFieldPassword.text != "" && textFieldRePassword.text != "" {
            buttonSignIn.backgroundColor = COLOR_GREEN
            buttonSignIn.isEnabled = true
        } else {
            buttonSignIn.backgroundColor = COLOR_GRAY
            buttonSignIn.isEnabled = false
        }
    }
}
