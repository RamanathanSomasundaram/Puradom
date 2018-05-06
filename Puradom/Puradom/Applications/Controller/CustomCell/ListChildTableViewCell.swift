//
//  ListChildTableViewCell.swift
//  XpressDeal
//
//  Created by Lakeba_26 on 12/11/17.
//  Copyright © 2017 spiksolutions. All rights reserved.
//

import UIKit

class ListChildTableViewCell: UITableViewCell {

    @IBOutlet var img_view: UIImageView?
    @IBOutlet var childTitle: UILabel!
    @IBOutlet var cellLeadingConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
