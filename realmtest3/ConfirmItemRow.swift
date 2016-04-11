//
//  ConfirmItemRow.swift
//  realmtest3
//
//  Created by Ashlee Beggs on 3/28/16.
//  Copyright © 2016 Ashlee Beggs. All rights reserved.
//


import UIKit

class ConfirmItemRow: UITableViewCell {
    
    @IBOutlet weak var confirmLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    
    func updateView(labelName:String){
        confirmLabel.text = labelName
    }
    
    
}