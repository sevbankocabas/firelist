//
//  Category.swift
//  firelist
//
//  Created by Sevban Kocabaş on 30.12.2018.
//  Copyright © 2018 Sevban Kocabaş. All rights reserved.
//

import UIKit

class Category: NSObject {
    
    var id: String?
    var title: String?
    var numberOfTasks: Int?
    init(dictionary: [String: AnyObject]) {
        
        self.id = dictionary["id"] as? String
        self.title = dictionary["title"] as? String
        self.numberOfTasks = dictionary["numberOfTasks"] as? Int
        
    }
    
}
