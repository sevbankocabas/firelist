//
//  TasksController.swift
//  firelist
//
//  Created by Sevban Kocabaş on 30.12.2018.
//  Copyright © 2018 Sevban Kocabaş. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class TasksController: SwipeViewController {
    
    var tasks = [Task]()
    var categoryID: String?
    var categoryName: String?
    var numberOfTasks: Int?
    var ref: DatabaseReference?
    var userID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        userID = Auth.auth().currentUser!.uid
        self.navigationItem.title = categoryName
        loadTasks()
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel!.text = tasks[indexPath.row].title
        if tasks[indexPath.row].isDone == true {
        cell.accessoryType = .checkmark
        } else {
          cell.accessoryType = .none
        }
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! TaskCell
//        cell.titleTextLabel.text = tasks[indexPath.row].title
//        if tasks[indexPath.row].isDone == true {
//            cell.checkmarkTextLabel.text = ""
//        } else {
//            cell.checkmarkTextLabel.text = "✔︎"
//        }
//        return cell
//        
//        
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let key = tasks[indexPath.row].id else {return}
        let name = tasks[indexPath.row].title
        let isDone = !tasks[indexPath.row].isDone!
        let update = ["id": key, "title": name!, "isDone": isDone] as [String: AnyObject]
        SVProgressHUD.show()
        self.ref!.child("Tasks").child(self.userID!).child(self.categoryID!).child(key).updateChildValues(update)
        tasks[indexPath.row].isDone = !tasks[indexPath.row].isDone!
        let alert = UIAlertController(title: "Status has changed", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            self.tableView.reloadData()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        SVProgressHUD.dismiss()
        
        
    }
    
    func loadTasks() {
        
        ref?.child("Tasks").child(userID!).child(categoryID!).observe(.childAdded, with: { (snapshot) in
            
            let data = snapshot.value as? [String: AnyObject] ?? [:]
            let id = data["id"] as? String
            let title = data["title"] as? String
            let isDone = data["isDone"] as? Bool
            let dic = ["id": id as AnyObject, "title": title as AnyObject, "isDone": isDone as AnyObject]
            let task = Task(dictionary: dic)
            self.tasks.append(task)
            self.tableView.reloadData()
            
        })
        
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Task", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let name = textField.text!
            let isDone = false
            
            let key = self.ref!.child("Tasks").child(self.userID!).child(self.categoryID!).childByAutoId().key
            let post = ["id": key!, "title": name, "isDone": isDone] as [String: AnyObject]
            let number = self.numberOfTasks! + 1
            self.numberOfTasks = number
            let update = ["id": self.categoryID! as AnyObject, "title": self.categoryName! as AnyObject, "numberOfTasks": number as AnyObject]
            self.ref!.child("Tasks").child(self.userID!).child(self.categoryID!).child(key!).setValue(post)
            
            self.ref!.child("Categories").child(self.userID!).child(self.categoryID!).updateChildValues(update)
            self.tableView.reloadData()
            
        }
        let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action2) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(action)
        alert.addAction(action2)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add new task"
        }
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        guard let taskIdForDeletion = self.tasks[indexPath.row].id else { return}
        ref!.child("Tasks").child(self.userID!).child(self.categoryID!).child(taskIdForDeletion).removeValue()
        let number = self.numberOfTasks! - 1
        self.numberOfTasks = number
        let update = ["id": self.categoryID! as AnyObject, "title": self.categoryName! as AnyObject, "numberOfTasks": number as AnyObject]
        ref!.child("Categories").child(self.userID!).child(self.categoryID!).updateChildValues(update)
        tasks.remove(at: indexPath.row)
        print(taskIdForDeletion)
        
    }
    
    
        
    

    

}
