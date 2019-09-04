//
//  LoginViewController.swift
//  Gigs
//
//  Created by Marc Jacques on 9/4/19.
//  Copyright © 2019 Marc Jacques. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    var gigController: GigController?
    var loginType = LoginType.signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
        signUpButton.tintColor = .white
        signUpButton.layer.cornerRadius = 8.0
        
        
        segmentedController.backgroundColor = .white
        segmentedController.tintColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
        
    }
    
    // MARK: Action Handlers
    
    @IBAction func segmentedControllerTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signUpButton.setTitle("Sign Up", for: .normal)
        } else {
            
            loginType = .signIn
            signUpButton.setTitle("Sign In", for: .normal)
        }
    }
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        
        guard let username = usernameTextfield.text,
        let password = passwordTextfield.text,
        !username.isEmpty,
        !password.isEmpty else { return }
        
        let user = User(username: username, password: password)
        
        if loginType == .signUp {
            gigController?.signUP(with: user, completion: { (networkError) in
                
                if let error = networkError {
                    NSLog("Error occurred during sign up: \(error)")
                } else {
                    
                    let alert = UIAlertController(title: "Sign up Successful", message: "Now please sign in", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okAction)
                    
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: {
                            self.loginType = .signIn
                            self.segmentedController.selectedSegmentIndex = 1
                            self.signUpButton.setTitle("Sign In", for: .normal)
                        })
                    }
                }
            })
        } else if loginType == .signIn {
            gigController?.login(with: user, completion: { (netowrkError) in
                if let error = netowrkError {
                    NSLog("Error occurred during login: \(error)")
                } else {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            })
        }
    }
    

}

