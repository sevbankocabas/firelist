//
//  TasksController.swift
//  firelist
//
//  Created by Sevban Kocabaş on 30.12.2018.
//  Copyright © 2018 Sevban Kocabaş. All rights reserved.
//

import UIKit
import Firebase

class TasksController: UITableViewController {
    
    var tasks = [Task]()
    var categoryID: String?
    var categoryName: String?
    var ref: DatabaseReference?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.navigationItem.title = categoryName
        
        
        
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
        let cell = super.tableView.cellForRow(at: indexPath) as! TaskCell
        cell.titleTextLabel.text = tasks[indexPath.row].title
        if tasks[indexPath.row].isDone == true {
        cell.checkmarkTextLabel.text = ""
        } else {
           cell.checkmarkTextLabel.text = ""
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }
    
    

    

}
