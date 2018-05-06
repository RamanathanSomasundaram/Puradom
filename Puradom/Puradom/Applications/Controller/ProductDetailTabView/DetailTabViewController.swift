//
//  DetailTabViewController.swift
//  Puradom
//
//  Created by Lakeba_26 on 20/04/18.
//  Copyright © 2018 Lakeba_26. All rights reserved.
//

import UIKit

class DetailTabViewController: UIViewController {
    @IBOutlet var bottom_space: NSLayoutConstraint!
    @IBOutlet var desc_text: UITextView!
    @IBOutlet var img_View: UIImageView!
    var image_string : String!
    var desc_string : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if(UIScreen.main.bounds.size.height == 812.0)
//        {
//            bottom_space.constant = 210
//        }
//        else
//        {
//            bottom_space.constant = 160
//        }
        self.desc_text.text = desc_string!
        let image : UIImage = UIImage(named: "sampleImage.png")!
        img_View.kf.indicatorType = .activity
        img_View.kf.setImage(with: URL(string: image_string!), placeholder: image, options: nil, progressBlock: nil, completionHandler: nil)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
}

}
