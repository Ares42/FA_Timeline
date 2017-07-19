//
//  FA_TableViewCell.swift
//  iOSEngineeringTest
//
//  Created by Luke Solomon on 7/13/17.
//  Copyright © 2017 FrontApp. All rights reserved.
//

import UIKit

class FA_TableViewCell: UITableViewCell {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

