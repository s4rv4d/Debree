//
//  LoginViewController.swift
//  Debree
//
//  Created by Sarvad shetty on 3/18/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - IBOutlets
    //user
    @IBOutlet weak var usernameTextview: UIView!
    @IBOutlet weak var usernameTextField: TextField!
    //pass
    @IBOutlet weak var passwordTextview: UIView!
    @IBOutlet weak var passwordTextField: TextField!
    //sign up button outlet
    @IBOutlet weak var signInButtonOutlet: UIButton!
    
    //MARK: - Main
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textfieldDelegateSetup()
        textFieldSetup()
        observeNotification()
        buttonSetup()
    }
    
    //MARK: - Functions
    func buttonSetup(){
        signInButtonOutlet.layer.shadowColor = UIColor.init(51, 1, 54, 0.6).cgColor
        signInButtonOutlet.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        signInButtonOutlet.layer.shadowOpacity = 1.0
        signInButtonOutlet.layer.shadowRadius = 3.0
        signInButtonOutlet.layer.masksToBounds = false
        signInButtonOutlet.layer.cornerRadius = 8
    }
    
    //MARK: - IBActionS
    @IBAction func signInTapped(_ sender: UIButton) {
        //firebase stuff
    }
    
}

//MARK: - Extensions
extension LoginViewController: UITextFieldDelegate{
    
    func textfieldDelegateSetup(){
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldSetup(){
        //for username textfield when not selected
        usernameTextField.backgroundColor = UIColor.init(238.0, 238.0, 238.0, 1.0)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "profile")
        imageView.image = image
        usernameTextField.leftView = imageView
        usernameTextField.leftViewMode = .always
        usernameTextField.layoutIfNeeded()
        usernameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "USERNAME", attributes: [NSAttributedString.Key.foregroundColor:UIColor(97, 50, 100, 0.59)])
        usernameTextField.layer.cornerRadius = 9
        usernameTextField.layer.masksToBounds = false
        usernameTextField.defaultTextAttributes.updateValue(2.0, forKey: NSAttributedString.Key.kern)
        
        //password
        passwordTextField.backgroundColor = UIColor.init(238.0, 238.0, 238.0, 1.0)
        let imageView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        imageView2.contentMode = .scaleAspectFill
        let image2 = UIImage(named: "key")
        imageView2.image = image2
        passwordTextField.leftView = imageView2
        passwordTextField.leftViewMode = .always
        passwordTextField.layoutIfNeeded()
        //to move image 10 pts
        passwordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "PASSWORD", attributes: [NSAttributedString.Key.foregroundColor:UIColor(97, 50, 100, 0.59)])
        passwordTextField.layer.cornerRadius = 9
        passwordTextField.layer.masksToBounds = false
        passwordTextField.defaultTextAttributes.updateValue(2.0, forKey: NSAttributedString.Key.kern)
        
        //corner radius for all view
        usernameTextview.backgroundColor = UIColor.init(238.0, 238.0, 238.0, 1.0)
        usernameTextview.layer.cornerRadius = 9
        usernameTextview.layer.masksToBounds = false
        usernameTextview.layer.shadowRadius = 3.0
        usernameTextview.layer.shadowColor = UIColor.init(51, 1, 54, 0.16).cgColor
        usernameTextview.layer.shadowOffset = CGSize(width: 0, height: 3)
        usernameTextview.layer.shadowOpacity = 1.0
        
        passwordTextview.backgroundColor = UIColor.init(238.0, 238.0, 238.0, 1.0)
        passwordTextview.layer.cornerRadius = 9
        passwordTextview.layer.masksToBounds = false
        passwordTextview.layer.shadowRadius = 3.0
        passwordTextview.layer.shadowColor = UIColor.init(51, 1, 54, 0.16).cgColor
        passwordTextview.layer.shadowOffset = CGSize(width: 0, height: 3)
        passwordTextview.layer.shadowOpacity = 1.0
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == usernameTextField{
            print("user stuff here")
            //
            usernameTextField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor:UIColor(97, 50, 100, 0.59)])
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "PASSWORD", attributes: [NSAttributedString.Key.foregroundColor:UIColor(97, 50, 100, 0.59)])
            //animation
            UIView.animate(withDuration: 0.4) {
                self.usernameTextview.backgroundColor = UIColor.init(97, 50, 100, 1.0)
                self.passwordTextview.backgroundColor = UIColor.init(238.0, 238.0, 238.0, 1.0)
                //edits
                UIView.animate(withDuration: 0.1, animations: {
                    self.usernameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(25, 0, 0)
                    self.passwordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
                },completion:nil)
                
                
            }
        }else{
            print("password stuff here")
            //
            usernameTextField.attributedPlaceholder = NSAttributedString(string: "USERNAME", attributes: [NSAttributedString.Key.foregroundColor:UIColor(97, 50, 100, 0.59)])
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor:UIColor(97, 50, 100, 0.59)])
            UIView.animate(withDuration: 0.4) {
                self.passwordTextview.backgroundColor = UIColor.init(97, 50, 100, 1.0)
                self.usernameTextview.backgroundColor = UIColor.init(238.0, 238.0, 238.0, 1.0)
                UIView.animate(withDuration: 0.1, animations: {
                    self.passwordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(25, 0, 0)
                    self.usernameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
                },completion:nil)
            }
        }
    }
    
    //MARK: - Textfield notification properties
    func observeNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardShow(){
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: -100, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
        
    }
    @objc func keyboardWillHide(){
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField{
            usernameTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
            usernameTextview.backgroundColor = UIColor.init(238.0, 238.0, 238.0, 1.0)
            if usernameTextField.text == ""{
                usernameTextField.attributedPlaceholder = NSAttributedString(string: "USERNAME", attributes: [NSAttributedString.Key.foregroundColor:UIColor(97, 50, 100, 0.59)])
                self.usernameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
            }
        }else{
            passwordTextview.backgroundColor = UIColor.init(238.0, 238.0, 238.0, 1.0)
            if passwordTextField.text == ""{
                passwordTextField.attributedPlaceholder = NSAttributedString(string: "PASSWORD", attributes: [NSAttributedString.Key.foregroundColor:UIColor(97, 50, 100, 0.59)])
                self.passwordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
            }
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
        usernameTextview.backgroundColor = UIColor.init(238.0, 238.0, 238.0, 1.0)
        self.usernameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        passwordTextview.backgroundColor = UIColor.init(238.0, 238.0, 238.0, 1.0)
        self.passwordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        if usernameTextField.text == ""{
            print("here 1")
            usernameTextField.attributedPlaceholder = NSAttributedString(string: "USERNAME", attributes: [NSAttributedString.Key.foregroundColor:UIColor(97, 50, 100, 0.59)])
        }
        if passwordTextField.text == ""{
            print("herer")
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "PASSWORD", attributes: [NSAttributedString.Key.foregroundColor:UIColor(97, 50, 100, 0.59)])
        }
    }
    
    func clearFields(){
        self.usernameTextField.text = ""
        self.passwordTextField.text = ""
        
        if usernameTextField.text == ""{
            usernameTextview.backgroundColor = UIColor.init(238.0, 238.0, 238.0, 1.0)
            usernameTextField.attributedPlaceholder = NSAttributedString(string: "USERNAME", attributes: [NSAttributedString.Key.foregroundColor:UIColor(97, 50, 100, 0.59)])
            self.usernameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        }
        
        if passwordTextField.text == ""{
            passwordTextview.backgroundColor = UIColor.init(238.0, 238.0, 238.0, 1.0)
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "PASSWORD", attributes: [NSAttributedString.Key.foregroundColor:UIColor(97, 50, 100, 0.59)])
            self.passwordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        }
        
    }


}
