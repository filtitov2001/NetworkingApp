//
//  SignInViewController.swift
//  Networking
//
//  Created by Felix Titov on 6/28/22.
//  Copyright © 2022 Felix Titov. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    var activityIndicator: UIActivityIndicatorView!
    
    lazy var continueButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.center = CGPoint(x: view.center.x, y: view.frame.height - 100)
        button.backgroundColor = .white
        
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(secondaryColor, for: .normal)
        
        button.layer.cornerRadius = 4
        button.alpha = 0.5
        button.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        view.addSubview(continueButton)
        setContinueButton(enabled: false)
        
        emailTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(
            self,
            selector:#selector(keyboardWillAppear),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    private func setContinueButton(enabled: Bool) {
        
        if enabled {
            continueButton.alpha = 1.0
            continueButton.isEnabled = true
        } else {
            continueButton.alpha = 0.5
            continueButton.isEnabled = false
        }
    }
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = secondaryColor
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = continueButton.center
        
        view.addSubview(activityIndicator)
    }
    
    @objc func keyboardWillAppear(notification: NSNotification){
        
        let userInfo = notification.userInfo!
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        continueButton.center = CGPoint(x: view.center.x,
                                        y: view.frame.height - keyboardFrame.height - 16.0 - continueButton.frame.height / 2)
        activityIndicator.center = continueButton.center
    }
    
    @objc private func textFieldChanged() {
        
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
        else { return }
        
        let formFilled = !(email.isEmpty) && !(password.isEmpty)
        
        setContinueButton(enabled: formFilled)
    }
    
    @objc private func handleSignIn() {
        setContinueButton(enabled: false)
        continueButton.setTitle("", for: .normal)
        activityIndicator.startAnimating()
        
        guard let email = emailTextField.text,
              let password = passwordTextField.text
        else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error {
                print(error.localizedDescription)
                
                self.setContinueButton(enabled: true)
                self.continueButton.setTitle("Continue", for: .normal)
                self.activityIndicator.stopAnimating()
                
                return
            }
            
            print("Succesfull")
            self.presentingViewController?.presentingViewController?.dismiss(animated: true)
        }
    }
}
