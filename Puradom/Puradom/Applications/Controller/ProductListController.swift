//
//  ProductListController.swift
//  Puradom
//
//  Created by Lakeba_26 on 18/04/18.
//  Copyright © 2018 Lakeba_26. All rights reserved.
//

import UIKit

class ProductListController: UIViewController,internetConnectionDelegate {

    
    @IBOutlet var cv_Product_list: UICollectionView!
    var collectionFlowLayout : UICollectionViewFlowLayout!
    var productList : NSMutableArray!
    var imageBaseURL : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.productList = NSMutableArray()
        self.NavigationControllerMenu()
        self.loadProductList()
        self.cv_Product_list.delegate = self
        self.cv_Product_list.dataSource = self
        collectionFlowLayout = UICollectionViewFlowLayout()
        let size = (self.view.frame.size.width - 4 ) / 2
        collectionFlowLayout.itemSize = CGSize(width: size, height: size * 1.5)
        collectionFlowLayout.minimumLineSpacing = 1
        collectionFlowLayout.minimumInteritemSpacing = 1
        self.cv_Product_list.collectionViewLayout = collectionFlowLayout
        
        // Do any additional setup after loading the view.
    }
    
    //Get Product List
    func loadProductList()
    {
        if(Utilities.checkForInternet())
        {
            Utilities.showLoading()
            Alamofire.request(ALL_PRODUCT_LIST).responseJSON { response in
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
                    let jsonResult = ((json as AnyObject).value(forKey: "productList")! as! [Any])
                    self.imageBaseURL = ((json as AnyObject).value(forKey: "baseURL")! as! String)
                    self.productList = NSMutableArray(array: jsonResult)
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                }
                let dispatchTime = DispatchTime.now()
                DispatchQueue.main.asyncAfter(deadline: dispatchTime , execute: {
                    Utilities.LeftSideMenu(rootVC: self)
                    self.cv_Product_list.register(UINib.init(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
                    self.cv_Product_list.reloadData()
                    Utilities.hideLoading()
                })
            }
        }
        else
        {
            self.nointernetconnection()
        }
    }
    
    //Navigation Menu
    func NavigationControllerMenu()
    {
        //Utilities.homeNavigationMenu(rootVC: self)
        self.navigationItem.hidesBackButton = true
        self.title = NSLocalizedString("product_list", comment: "")//"Product Listing"
        self.navigationItem.hidesBackButton = true
        let flipButton = UIBarButtonItem.init(image: UIImage.init(named: "Back"), style: .plain, target: self, action: #selector(backHome))
        flipButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = flipButton
        let flipRightButton = UIBarButtonItem.init(image: UIImage.init(named: "More"), style: .plain, target: self, action: #selector(rightMenuAction))
        flipRightButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = flipRightButton        
    }
    @objc func backHome()
    {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @objc func rightMenuAction()
    {
        let categoryClass = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesViewController") as! CategoriesViewController
        self.navigationController?.pushViewController(categoryClass, animated: true)
    }
    
    //no Internet Connection
    func nointernetconnection()
    {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        let internet = NoInternetViewController.init(nibName: "NoInternetViewController", root: self)
        internet.internetDelegate = self
        self.view.addSubview(internet.view)
        self.addChildViewController(internet)
    }
    func internetHandling(internetView: NoInternetViewController) {
        internetView.view.removeFromSuperview()
        self.productList.removeAllObjects()
        self.loadProductList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
extension ProductListController : UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCollectionViewCell
        let dictValues = (self.productList.object(at: indexPath.row) as! NSDictionary)
        let image : UIImage = UIImage(named: "sampleImage.png")!
        cell.Product_icon.kf.indicatorType = .activity
        cell.Product_icon.kf.setImage(with: URL(string: imageBaseURL + "\(dictValues.value(forKey: "product_img") as! String)"), placeholder: image, options: nil, progressBlock: nil, completionHandler: nil)
        cell.btn_Consult.tag = indexPath.row
        cell.btn_Consult.addTarget(self, action: #selector(btn_Consult_Action(_:)), for: .touchUpInside)
        cell.lbl_Product_Name.text = (dictValues.value(forKey: "product_title") as! String)
        cell.layoutIfNeeded()
        cell.setNeedsLayout()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ProductDetail = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        ProductDetail.productDetailArray = (self.productList.object(at: indexPath.row) as! NSDictionary)
        ProductDetail.imageURL = self.imageBaseURL
        self.navigationController?.pushViewController(ProductDetail, animated: true)
    }
    @objc func btn_Consult_Action(_ sender : UIButton)
    {
        let dict = (self.productList.object(at: sender.tag) as! NSDictionary)
        let product_id = (dict.value(forKey: "product_id") as! String)
        let consult = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
        consult.globalProduct_ID = product_id
        self.navigationController?.pushViewController(consult, animated: true)
    }
}

