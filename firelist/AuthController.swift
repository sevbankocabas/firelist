//
//  AuthController.swift
//  firelist
//
//  Created by Sevban Kocabaş on 30.12.2018.
//  Copyright © 2018 Sevban Kocabaş. All rights reserved.
//

import UIKit

class AuthController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func segmentValueChanged(_ sender: Any) {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            
            loginButton.isHidden = false
            registerButton.isHidden = true
            
            
        } else if segmentedControl.selectedSegmentIndex == 1 {
            
            loginButton.isHidden = true
            registerButton.isHidden = false
            
            
        }
        
    }
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
    }
    @IBAction func registerButtonPressed(_ sender: Any) {
    }
    
    
    

    

}
