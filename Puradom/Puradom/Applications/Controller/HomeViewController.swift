//
//  HomeViewController.swift
//  Puradom
//
//  Created by Lakeba_26 on 18/04/18.
//  Copyright © 2018 Lakeba_26. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var img_slideshow: ImageSlideshow!
    @IBOutlet var lbl_top_product: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    var collectionFlowLayout : UICollectionViewFlowLayout!
    var popOver : VPPopOver!
    let titleArray = ["FLECK 5600","A. CLACK WS1.5","A. CLACK WS2H","A. CLACK WS2L","A. FLECK 2850","A. FLECK 2900 NT"]
    let imageArray = ["http://www.puradom.com/assets/site/img/latest/prod1.png","http://www.puradom.com/assets/site/img/latest/prod2.png","http://www.puradom.com/assets/site/img/latest/prod3.png","http://www.puradom.com/assets/site/img/latest/prod4.png","http://www.puradom.com/assets/site/img/latest/prod5.png","http://www.puradom.com/assets/site/img/latest/prod6.png"]
    var imageSource = [InputSource]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.NavigationControllerMenu()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        collectionFlowLayout = UICollectionViewFlowLayout()
        let size = (self.view.frame.size.width - 4 ) / 2
        collectionFlowLayout.itemSize = CGSize(width: size, height: size * 1.4)
        collectionFlowLayout.minimumLineSpacing = 1
        collectionFlowLayout.minimumInteritemSpacing = 1
        self.collectionView.collectionViewLayout = collectionFlowLayout
        self.collectionView.register(UINib.init(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
        self.collectionView.reloadData()
        
        //Load Image Slide show
        img_slideshow.pageControlPosition = PageControlPosition.underScrollView
        img_slideshow.pageControl.currentPageIndicatorTintColor = UIColor.init(red: 18.0 / 255.0, green: 151.0 / 255.0, blue: 236.0 / 255.0, alpha: 1.0)
        img_slideshow.pageControl.pageIndicatorTintColor = UIColor.lightGray
        img_slideshow.contentScaleMode = UIViewContentMode.scaleToFill
        img_slideshow.slideshowInterval = 2.0
        imageSource = [ImageSource(image: UIImage(named: "sample1.png")!), ImageSource(image: UIImage(named: "sample2.png")!), ImageSource(image: UIImage(named: "sample3.png")!), ImageSource(image: UIImage(named: "sample4.png")!)]
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        img_slideshow.activityIndicator = DefaultActivityIndicator()
        img_slideshow.setImageInputs(imageSource)
        // Do any additional setup after loading the view.
    }

    func NavigationControllerMenu()
    {
        //Utilities.homeNavigationMenu(rootVC: self)
        self.navigationItem.hidesBackButton = true
        self.title = NSLocalizedString("home", comment: "")
        //self.navigationController?.title = "Home"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        let flipButton = UIBarButtonItem.init(image: UIImage.init(named: "slidemenu"), style: .plain, target: self, action: #selector(leftMenuAction))
        flipButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = flipButton
        let flipRightButton = UIBarButtonItem.init(image: UIImage.init(named: "More"), style: .plain, target: self, action: #selector(rightMenuAction))
        flipRightButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = flipRightButton
        Utilities.LeftSideMenu(rootVC: self)
    }

    @objc func leftMenuAction()
    {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @objc func rightMenuAction()
    {
        let LanguageMenu = LanguageSettingsViewController()
        LanguageMenu.OptionDelegate = self
        self.showPopupWithView(LanguageMenu)
    }
    //Popover initailaize
    func showPopupWithView(_ view : UIView)
    {
        
        popOver = VPPopOver.init(viewController: view, withFullScreen: screenType.HALF_SCREEN)
        UIApplication.shared.keyWindow?.addSubview(popOver!)
    }
    @IBAction func call_us_action(_ sender: Any) {
        
        let callus = self.storyboard?.instantiateViewController(withIdentifier: "CallUsViewController") as! CallUsViewController
        self.navigationController?.pushViewController(callus, animated: true)
        
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
extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titleArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCollectionViewCell
        let image : UIImage = UIImage(named: "sampleImage.png")!
        cell.Product_icon.kf.indicatorType = .activity
        cell.Product_icon.kf.setImage(with: URL(string: (self.imageArray[indexPath.row] as String)), placeholder: image, options: nil, progressBlock: nil, completionHandler: nil)
        cell.btn_Consult.tag = indexPath.row
        cell.btn_Consult.addTarget(self, action: #selector(btn_Consult_Action), for: .touchUpInside)
        cell.lbl_Product_Name.text = (self.titleArray[indexPath.row] as String)
        cell.layoutIfNeeded()
        cell.setNeedsLayout()
        return cell
    }
    
    @objc func btn_Consult_Action()
    {
        let consult = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
        consult.globalProduct_ID = "8d2cd315462769e4"
        self.navigationController?.pushViewController(consult, animated: true)
    }
}

//Localization Delegate Methods
extension HomeViewController : LanguageSettingsDelegate{
    func LanguageMenuList(_ optionMenu: LanguageSettingsViewController, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0)
        {
            Utilities.changeLanguage(Language: "en")
        }
        else if(indexPath.row == 1)
        {
            Utilities.changeLanguage(Language: "es")
        }
        Utilities.showAlertToast(title: "Success", message: "Language changed", type: .success)
    }
}
