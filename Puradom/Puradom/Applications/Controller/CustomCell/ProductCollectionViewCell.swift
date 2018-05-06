//
//  ProductCollectionViewCell.swift
//  Puradom
//
//  Created by Lakeba_26 on 18/04/18.
//  Copyright © 2018 Lakeba_26. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet var Product_icon: UIImageView!
    @IBOutlet var lbl_Product_Name: UILabel!
    @IBOutlet var btn_Consult: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btn_Consult.setTitle(NSLocalizedString("btn_consult", comment: ""), for: .normal)
        // Initialization code
    }

    @IBAction func btn_Consult_Action(_ sender: Any) {
    }
}
