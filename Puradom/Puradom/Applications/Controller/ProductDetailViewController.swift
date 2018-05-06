//
//  ProductDetailViewController.swift
//  Puradom
//
//  Created by Lakeba_26 on 18/04/18.
//  Copyright © 2018 Lakeba_26. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {

    var tc : TabPageViewController!
    @IBOutlet var pageViewController: UIView!
    var productDetailArray : NSDictionary!
    var imageURL : String!
    var tabItemsArray : NSMutableArray!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.NavigationControllerMenu()
        tabItemsArray = NSMutableArray()
        if((productDetailArray!.value(forKey: "tabs") as? NSArray) != nil)
        {
            tabItemsArray = NSMutableArray.init(array: productDetailArray!.value(forKey: "tabs")as! [Any])
        }
        self.loadPageViewController()
        // Do any additional setup after loading the view.
    }
    
    //Navigation Menu
    func NavigationControllerMenu()
    {
        self.navigationItem.hidesBackButton = true
        //self.title = (self.productDetailArray.value(forKey: "product_title")! as! String)
        let titleLabel = UILabel()
        //titleLabel.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height * 2)
        titleLabel.frame = CGRect(x: 50, y: 0, width: self.view.frame.size.width - 50, height: self.view.frame.height * 2)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.text = (self.productDetailArray.value(forKey: "product_title")! as! String)
        navigationItem.titleView = titleLabel
        self.navigationItem.hidesBackButton = true
        let flipButton = UIBarButtonItem.init(image: UIImage.init(named: "Back"), style: .plain, target: self, action: #selector(backHome))
        flipButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = flipButton
    }
    @objc func backHome()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Load page view controller - Tabpageviewcontroller class
    func loadPageViewController()
    {
        tc = TabPageViewController.create()
        var tabItems:[(viewController: UIViewController, title: String)] = []
        for i in 0..<self.tabItemsArray.count
        {
            let DetailTab = self.storyboard?.instantiateViewController(withIdentifier: "ProductDescriptionViewController") as! ProductDescriptionViewController
            let tabs = self.tabItemsArray.object(at: i) as! NSDictionary
            tabItems.append((viewController: DetailTab, title: (tabs.value(forKey: "tab_name") as! String)))
            DetailTab.detailString = (tabs.value(forKey: "tab_detail") as! String)
        }
        let DescTab = self.storyboard?.instantiateViewController(withIdentifier: "DetailTabViewController") as! DetailTabViewController
        DescTab.desc_string = (self.productDetailArray.value(forKey: "product_descplace")! as! String)
        DescTab.image_string = imageURL + "\((self.productDetailArray.value(forKey: "product_img")! as! String))"
        tabItems.insert((viewController: DescTab, title: "Description"), at: 0)
        tc.tabItems = tabItems
        var option = TabPageOption()
        option.tabBackgroundColor = UIColor.init(red: 18.0 / 255.0, green: 151.0 / 255.0, blue: 236.0 / 255.0, alpha: 1.0) //33,150,243
        option.tabHeight = 50.0
        option.tabWidth = view.frame.width / CGFloat(tabItems.count)
        option.currentColor = UIColor.white //255,183,77
        option.tabMargin = 20.0
        tc.option = option
        tc.view.frame = self.pageViewController.frame
        //self.addChildViewController(tc)
        self.pageViewController.addSubview(tc.view)
        //self.pageViewController.insertSubview(tc.view, at: 0) // Insert the page controller view below the navigation buttons
        //tc.didMove(toParentViewController: self)
    }
    
    @IBAction func btn_consult_now_Action(_ sender: Any) {
        let contact = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
        contact.globalProduct_ID = (productDetailArray!.value(forKey: "product_id") as! String)
        self.navigationController?.pushViewController(contact, animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
