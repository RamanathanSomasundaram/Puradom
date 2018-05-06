//
//  CategoriesViewController.swift
//  Puradom
//
//  Created by Lakeba_26 on 18/04/18.
//  Copyright © 2018 Lakeba_26. All rights reserved.
//

import UIKit
class NodeIdentifier : NSObject{
    var identifier : String!
    
    init(withIdentifier identifier: String)
    {
        self.identifier = identifier
    }
}
class CategoriesViewController: UIViewController,internetConnectionDelegate {

    
    @IBOutlet var tbl_MenuList: UITableView!
    var CategoryName : String!
    var menuList : NSMutableArray!
    var productArray : NSMutableArray!
    var kjtreeInstance: KJTree = KJTree()
    var arrayParents: NSArray?
    override func viewDidLoad() {
        super.viewDidLoad()
        menuList = NSMutableArray()
        productArray = NSMutableArray()
        tbl_MenuList.tableFooterView = UIView()
        self.NavigationControllerMenu()
        self.CategoriesList(URLString: CAT_LIST)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Navigation Menu
    func NavigationControllerMenu()
    {
        //Utilities.homeNavigationMenu(rootVC: self)
        self.navigationItem.hidesBackButton = true
        self.title = NSLocalizedString("category_lsit", comment: "")
        self.navigationItem.hidesBackButton = true
        let flipButton = UIBarButtonItem.init(image: UIImage.init(named: "Back"), style: .plain, target: self, action: #selector(backHome))
        flipButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = flipButton
    }
    @objc func backHome()
    {
        self.navigationController?.popViewController(animated: true)
    }
    //Categories List
    func CategoriesList(URLString : String)
    {
        if(Utilities.checkForInternet())
        {
        Utilities.showLoading()
        Alamofire.request(URLString, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler:{ response in
            let error = response.result.error
            if response.response?.statusCode == -1001
            {
                Utilities.hideLoading()
                self.nointernetconnection()
                return
            }
            if error != nil
            {
                Utilities.hideLoading()
                self.nointernetconnection()
                return
            }
            if let json = response.result.value {
                let jsonResult = ((json as AnyObject).value(forKey: "mainCategory")! as! [Any])
                self.menuList = NSMutableArray.init(array: jsonResult)
                let dispatchTime = DispatchTime.now()
                DispatchQueue.main.asyncAfter(deadline: dispatchTime , execute: {
                    if let arrayOfParents = (json as AnyObject).value(forKey: "mainCategory")! as? NSArray {
                        self.arrayParents = arrayOfParents
                    }
                    if let arrayOfParents = self.arrayParents {
                        self.kjtreeInstance = KJTree(parents: arrayOfParents, childrenKey: "subcateg", expandableKey: "parent_id")
                    }
                    self.tbl_MenuList.reloadData()
                    Utilities.hideLoading()
                })
            }
        })
        }
        else
        {
            self.nointernetconnection()
        }
    }
    
    //no Internet Connection
    func nointernetconnection()
    {
        let internet = NoInternetViewController.init(nibName: "NoInternetViewController", root: self)
        internet.internetDelegate = self
        self.view.addSubview(internet.view)
        self.addChildViewController(internet)
    }
    
    func internetHandling(internetView: NoInternetViewController) {
        internetView.view.removeFromSuperview()
        menuList.removeAllObjects()
        productArray.removeAllObjects()
        self.CategoriesList(URLString: CAT_LIST)
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
extension CategoriesViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kjtreeInstance.tableView(tableView, numberOfRowsInSection: section)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let node = kjtreeInstance.cellIdentifierUsingTableView(tableView, cellForRowAt: indexPath)
        let indexTuples = node.index.components(separatedBy: ".")
        let arrayParent = (arrayParents!.object(at: (indexTuples[0] as NSString).integerValue) as! NSDictionary)
        
        let arrayName = (arrayParent.value(forKey: "subcateg") as? NSArray)
        let cellIdentifierChilds = "childCell"
        var cellChild: ListChildTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifierChilds) as? ListChildTableViewCell
        if cellChild == nil {
            tableView.register(UINib(nibName: "ListChildTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifierChilds)
            cellChild = tableView.dequeueReusableCell(withIdentifier: cellIdentifierChilds) as? ListChildTableViewCell
        }
        cellChild?.childTitle.textColor = UIColor.init(red: 33.0 / 255.0, green: 150.0 / 255.0, blue: 243.0 / 255.0, alpha: 1.0)
        // You can return different cells for Parents, childs, subchilds, .... as below.
        if indexTuples.count == 1 {
            // return cell for Parents and subchilds at level 4. (For Level-1 and Internal level-4)
            cellChild?.childTitle.text = (arrayParent.value(forKey: "catname") as! String)
            cellChild?.cellLeadingConstraint.constant = 0
            cellChild?.childTitle.textColor = UIColor.init(red: 33.0 / 255.0, green: 150.0 / 255.0, blue: 243.0 / 255.0, alpha: 1.0)
        }else if indexTuples.count == 2{
            cellChild?.childTitle.text = ((arrayName?.object(at: (indexTuples[1] as NSString).integerValue) as! NSDictionary).value(forKey: "catname") as! String)
            cellChild?.cellLeadingConstraint.constant = 10
            cellChild?.childTitle.textColor = UIColor.init(red: 255.0 / 255.0, green: 166.0 / 255.0, blue: 67.0 / 255.0, alpha: 1.0)
            //return cellChild! 255,166,67
            // return cell for Childs of Parents. (Level-2)
        }else if indexTuples.count == 3{
            // return cell for Subchilds of Childs inside Parent. (Level-3)
            let childArray = ((arrayName?.object(at: (indexTuples[1] as NSString).integerValue) as! NSDictionary).value(forKey: "subcateg") as? NSArray)
            cellChild?.childTitle.text = ((childArray?.object(at: (indexTuples[2] as NSString).integerValue) as! NSDictionary).value(forKey: "catname") as! String)
            cellChild?.cellLeadingConstraint.constant = 20
            cellChild?.childTitle.textColor = UIColor.black
        }
        else if(indexTuples.count == 4)
        {
            let Childarray = ((arrayName?.object(at: (indexTuples[1] as NSString).integerValue) as! NSDictionary).value(forKey: "subcateg") as? NSArray)
            let ChildArray1 = ((Childarray?.object(at: (indexTuples[2] as NSString).integerValue) as! NSDictionary).value(forKey: "subcateg") as? NSArray)
            cellChild?.childTitle.text = ((ChildArray1?.object(at: (indexTuples[3] as NSString).integerValue) as! NSDictionary).value(forKey: "catname") as! String)
            cellChild?.cellLeadingConstraint.constant = 30
            cellChild?.childTitle.textColor = UIColor.brown
        }
        else if(indexTuples.count == 5)
        {
            let Childarray = ((arrayName?.object(at: (indexTuples[1] as NSString).integerValue) as! NSDictionary).value(forKey: "subcateg") as? NSArray)
            let ChildArray1 = ((Childarray?.object(at: (indexTuples[2] as NSString).integerValue) as! NSDictionary).value(forKey: "subcateg") as? NSArray)
            let ChildArray2 = ((ChildArray1?.object(at: (indexTuples[3] as NSString).integerValue) as! NSDictionary).value(forKey: "subcateg") as? NSArray)
            cellChild?.childTitle.text = ((ChildArray2?.object(at: (indexTuples[1] as NSString).integerValue) as! NSDictionary).value(forKey: "catname") as! String)
            cellChild?.cellLeadingConstraint.constant = 40
            cellChild?.childTitle.textColor = UIColor.red
        }
        else
        {
            //Level -6
        }
        
        if node.state == .open {
            cellChild?.img_view?.image = UIImage(named: "Menu-1")
        }else if node.state == .close {
            cellChild?.img_view?.image = UIImage(named: "Menu")
        }else{
            cellChild?.img_view?.image = nil
        }
        
        cellChild?.selectionStyle = .none
        tbl_MenuList.separatorStyle = .singleLine
        return cellChild!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let node = kjtreeInstance.tableView(tableView, didSelectRowAt: indexPath)
        let indexTuples = node.index.components(separatedBy: ".")
        let arrayParent = (arrayParents!.object(at: (indexTuples[0] as NSString).integerValue) as! NSDictionary)
        if (arrayParent.value(forKey: "subcateg") as? NSArray) == nil {
            let nodeID = (arrayParent.value(forKey: "id") as? String)
            self.CallCategoryClass(CategoryID : nodeID!)
        }
        else {
            let arrayName = (arrayParent.value(forKey: "subcateg") as? NSArray)
            if(indexTuples.count == 2)
            {
                if ((arrayName?.object(at: (indexTuples[1] as NSString).integerValue) as! NSDictionary).value(forKey: "subcateg") as? NSArray) == nil
                {
                    let nodeID =  ((arrayName?.object(at: (indexTuples[1] as NSString).integerValue) as! NSDictionary).value(forKey: "id") as! String)
                    self.CallCategoryClass(CategoryID : nodeID)
                }
            }
            else if(indexTuples.count == 3)
            {
                let Childarray = ((arrayName?.object(at: (indexTuples[1] as NSString).integerValue) as! NSDictionary).value(forKey: "subcateg") as? NSArray)
                let ChildArray1 = ((Childarray?.object(at: (indexTuples[2] as NSString).integerValue) as! NSDictionary).value(forKey: "subcateg") as? NSArray)
                if ( ChildArray1 == nil)
                {
                    let nodeID =  ((Childarray?.object(at: (indexTuples[2] as NSString).integerValue) as! NSDictionary).value(forKey: "id") as! String)
                    self.CallCategoryClass(CategoryID : nodeID)
                }
            }
            else if(indexTuples.count == 4)
            {
                let Childarray = ((arrayName?.object(at: (indexTuples[1] as NSString).integerValue) as! NSDictionary).value(forKey: "subcateg") as? NSArray)
                let ChildArray1 = ((Childarray?.object(at: (indexTuples[2] as NSString).integerValue) as! NSDictionary).value(forKey: "subcateg") as? NSArray)
                let ChildArray2 = ((ChildArray1?.object(at: (indexTuples[3] as NSString).integerValue) as! NSDictionary).value(forKey: "subcateg") as? NSArray)
                if ( ChildArray2 == nil)
                {
                    let nodeID =  ((ChildArray1?.object(at: (indexTuples[3] as NSString).integerValue) as! NSDictionary).value(forKey: "id") as! String)
                    self.CallCategoryClass(CategoryID : nodeID)
                }
            }
            else if (indexTuples.count == 4)
            {
                let Childarray = ((arrayName?.object(at: (indexTuples[1] as NSString).integerValue) as! NSDictionary).value(forKey: "subcateg") as? NSArray)
                let ChildArray1 = ((Childarray?.object(at: (indexTuples[2] as NSString).integerValue) as! NSDictionary).value(forKey: "subcateg") as? NSArray)
                let ChildArray2 = ((ChildArray1?.object(at: (indexTuples[3] as NSString).integerValue) as! NSDictionary).value(forKey: "subcateg") as? NSArray)
                let ChildArray3 = ((ChildArray2?.object(at: (indexTuples[4] as NSString).integerValue) as! NSDictionary).value(forKey: "subcateg") as? NSArray)
                if ( ChildArray3 == nil)
                {
                    let nodeID =  ((ChildArray2?.object(at: (indexTuples[4] as NSString).integerValue) as! NSDictionary).value(forKey: "id") as! String)
                    self.CallCategoryClass(CategoryID : nodeID)
                }
            }
        }
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func CallCategoryClass(CategoryID : String)
    {
        print("Category ID \(CategoryID)")
        let searchProduct = self.storyboard?.instantiateViewController(withIdentifier: "SearchProductViewController") as! SearchProductViewController
        searchProduct.product_ID = CategoryID
        self.navigationController?.pushViewController(searchProduct, animated: true)
    }
}
