//
//  AuthController.swift
//  firelist
//
//  Created by Sevban Kocabaş on 30.12.2018.
//  Copyright © 2018 Sevban Kocabaş. All rights reserved.
//

import UIKit
import Firebase

class AuthController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    var ref: DatabaseReference?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ref = Database.database().reference()
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
        guard let email = emailTextField.text?.lowercased() else {return}
        guard let password = passwordTextField.text else {return}
        
        login(email: email, password: password)
        
        
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        
        guard let email = emailTextField.text?.lowercased() else {return}
        guard let password = passwordTextField.text else {return}
        registerUser(email: email, password: password)
        
        
    }
    
    func registerUser(email: String, password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                print(error ?? "")
                return
            }
            guard let uid = result?.user.uid else {return}
            let dic = ["email": email] as [String: AnyObject]
            
            self.saveUserIntoDatabase(uid, dic)
            
        }
        
    }
    
    fileprivate func saveUserIntoDatabase(_ id: String, _ dictionary: [String: AnyObject]) {
        
        let userRef = ref?.child("users").child(id)
        userRef?.updateChildValues(dictionary, withCompletionBlock: { (error, reference) in
            
            if error != nil {
                print(error ?? "")
                return
            }
            
            //Success
            print("Success Register")
            
        })
        
    }
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error)
                return
            }
            //Success
            print("Success Login")
        }
    }
    

    

}
