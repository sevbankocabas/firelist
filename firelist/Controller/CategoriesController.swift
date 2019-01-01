//
//  CategoriesController.swift
//  firelist
//
//  Created by Sevban Kocabaş on 30.12.2018.
//  Copyright © 2018 Sevban Kocabaş. All rights reserved.
//

import UIKit
import Firebase

class CategoriesController: SwipeViewController {
    
    var categories = [Category]()
    var ref: DatabaseReference?
    var userID: String?
    var selectedCategoryID: String?
    var selectedCategoryName: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        userID = Auth.auth().currentUser!.uid
        loadCategories()
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories[indexPath.row].title!
        return cell

    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! CategoryCell
//        let number = String(describing: categories[indexPath.row].numberOfTasks!)
//        cell.titleTextLabel?.text = categories[indexPath.row].title
//        cell.numberTextLabel.text = number
//        return cell
//
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategoryID = categories[indexPath.row].id
        selectedCategoryName = categories[indexPath.row].title
        performSegue(withIdentifier: "goToTasks", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTasks" {
        let TasksVC = segue.destination as! TasksController
        TasksVC.categoryID = selectedCategoryID
        TasksVC.categoryName = selectedCategoryName
        } else {
            handleLogout()
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let name = textField.text!
            let numberOfTasks = 0
            
            let key = self.ref!.child("Categories").child(self.userID!).childByAutoId().key
            let post = ["id": key!, "title": name, "numberOfTasks": numberOfTasks] as [String: AnyObject]
            let childUpdates = ["/Categories/\(self.userID!)/\(key!)": post]
            self.ref!.updateChildValues(childUpdates)
            self.tableView.reloadData()
            
        }
        let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action2) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(action)
        alert.addAction(action2)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add new category"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func loadCategories() {
        
        ref?.child("Categories").child(userID!).observe(.childAdded, with: { (snapshot) in
            
            let data = snapshot.value as? [String: AnyObject] ?? [:]
            let id = data["id"] as? String
            let title = data["title"] as? String
            let dic = ["id": id as AnyObject, "title": title as AnyObject]
            let category = Category(dictionary: dic)
            self.categories.append(category)
            self.tableView.reloadData()
            
        })
        
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        guard let categoryIdForDeletion = self.categories[indexPath.row].id else { return}
        ref!.child("Categories").child(userID!).child(categoryIdForDeletion).removeValue()
        ref!.child("Tasks").child(userID!).child(categoryIdForDeletion).removeValue()
        categories.remove(at: indexPath.row)
        print(categoryIdForDeletion)
        
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToAuth", sender: self)
    }
    func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let loggOutError {
            print(loggOutError)
        }
    }
    
    
    
    

   

}
