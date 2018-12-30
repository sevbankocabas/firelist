//
//  AuthController.swift
//  firelist
//
//  Created by Sevban Kocabaş on 30.12.2018.
//  Copyright © 2018 Sevban Kocabaş. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD


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
        SVProgressHUD.show()
        guard let email = emailTextField.text?.lowercased() else {return}
        guard let password = passwordTextField.text else {return}
        
        login(email: email, password: password)
        
        
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        SVProgressHUD.show()
        guard let email = emailTextField.text?.lowercased() else {return}
        guard let password = passwordTextField.text else {return}
        
        registerUser(email: email, password: password)
        
        
    }
    
    func registerUser(email: String, password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                print(error ?? "")
                SVProgressHUD.dismiss()
                let alert = UIAlertController(title: "Error", message: "Registration is unsuccessful", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            
            guard let uid = result?.user.uid else {return}
            let dic = ["email": email] as [String: AnyObject]
            
            self.saveUserIntoDatabase(uid, dic)
            SVProgressHUD.dismiss()
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
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let controller: CategoriesController = storyboard.instantiateViewController(withIdentifier: "CategoriesVC") as! CategoriesController
            let navigationViewController = UINavigationController(rootViewController: controller)
            self.present(navigationViewController, animated: true, completion: nil)
            SVProgressHUD.dismiss()
            
            
//            print("Success Register")
//            SVProgressHUD.dismiss()
//            let alert = UIAlertController(title: "Success", message: "Registration is successful", preferredStyle: .alert)
//            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alert.addAction(action)
//            self.present(alert, animated: true, completion: nil)
            
        })
        
    }
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error ?? "")
                SVProgressHUD.dismiss()
                let alert = UIAlertController(title: "Error", message: "Login is unsuccessful", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                return
            }
            //Success
            
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let controller: CategoriesController = storyboard.instantiateViewController(withIdentifier: "CategoriesVC") as! CategoriesController
            let navigationViewController = UINavigationController(rootViewController: controller)
            self.present(navigationViewController, animated: true, completion: nil)
            SVProgressHUD.dismiss()
//            print("Success Login")
//            SVProgressHUD.dismiss()
//            let alert = UIAlertController(title: "Success", message: "Login is successful", preferredStyle: .alert)
//            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alert.addAction(action)
//            self.present(alert, animated: true, completion: nil)
        }
    }
    

    

}
