//
//  CategoryCell.swift
//  firelist
//
//  Created by Sevban Kocabaş on 30.12.2018.
//  Copyright © 2018 Sevban Kocabaş. All rights reserved.
//

import UIKit
import SwipeCellKit

class CategoryCell: SwipeTableViewCell {
    
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var numberTextLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
