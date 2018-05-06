//
//  ProductDescriptionViewController.swift
//  Puradom
//
//  Created by Lakeba_26 on 19/04/18.
//  Copyright © 2018 Lakeba_26. All rights reserved.
//

import UIKit

class ProductDescriptionViewController: UIViewController {
    @IBOutlet var bottomSpace: NSLayoutConstraint!
    @IBOutlet var txtView_content: UITextView!
    var detailString: String!
    override func viewDidLoad() {
        super.viewDidLoad()
//        if(UIScreen.main.bounds.size.height == 812.0)
//        {
//            bottomSpace.constant = 210
//        }
//        else
//        {
//            bottomSpace.constant = 160
//        }
        txtView_content.text = detailString!
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
