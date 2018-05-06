//
//  CallUsViewController.swift
//  Puradom
//
//  Created by Lakeba_26 on 18/04/18.
//  Copyright © 2018 Lakeba_26. All rights reserved.
//

import UIKit
import MessageUI
class CallUsViewController: UIViewController,MFMailComposeViewControllerDelegate {

    @IBOutlet var tbl_Address: UITableView!
    @IBOutlet var callus_MapView: GMSMapView!
    let UserInfoDict = ["address","mobile","phone_call","fax","email_call"]
    let dictImage = ["black_home","black_phone","black_phone","black_phone","Mail"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadNavView()
        self.NavigationControllerMenu()
        self.tbl_Address.tableFooterView = UIView()
        tbl_Address.register(UINib(nibName: "CallusTableViewCell", bundle: nil), forCellReuseIdentifier: "callus")
        
        // Do any additional setup after loading the view.
    }
    
     func loadNavView() {
        
        let camera = GMSCameraPosition.camera(withLatitude: 18.486058,
                                              longitude: -69.931212,
                                              zoom: 10)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 18.486058, longitude: -69.931212)
        marker.appearAnimation = .pop
        marker.map = callus_MapView
        callus_MapView.animate(to: camera)
        CATransaction.begin()
        CATransaction.setValue(3.0, forKey: kCATransactionAnimationDuration)
        callus_MapView.animate(toZoom: 17)
        CATransaction.commit()
    }
    
    //Navigation Menu
    func NavigationControllerMenu()
    {
        self.navigationItem.hidesBackButton = true
        self.title = NSLocalizedString("call_us", comment: "")
        self.navigationItem.hidesBackButton = true
        let flipButton = UIBarButtonItem.init(image: UIImage.init(named: "Back"), style: .plain, target: self, action: #selector(backHome))
        flipButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = flipButton
    }
    @objc func backHome()
    {
        self.navigationController?.popToRootViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Mail Composer Delegate methods
    //Send mail
    func sendMail()
    {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients(["ventas@puradom.com"])
        composeVC.setSubject("")
        composeVC.setMessageBody("", isHTML: false)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    //Mail composer Delegate method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func resultString(result: MFMailComposeResult)
    {
        switch result {
        case MFMailComposeResult.sent:
            //print("Mail Sent")
            Utilities.showAlert("Mail sent successfully")
            break
        case .saved:
            //print("You saved a draft of this email")
            Utilities.showAlert("You saved a draft of this email")
            break
        case .cancelled:
            //print("You cancelled sending this email.")
            Utilities.showAlert("You cancelled sending this email.")
            break
        case .failed:
            //print("Mail failed:  An error occurred when trying to compose this email")
            Utilities.showAlert("Mail failed:  An error occurred when trying to compose this email")
            break
        }
        
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

extension CallUsViewController : UITableViewDelegate,UITableViewDataSource
{
    //MARK: - Tableview Datasource and Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserInfoDict.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifierChilds = "callus"
        let cellChild: CallusTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierChilds) as! CallusTableViewCell
        cellChild.call_us_Label.text = NSLocalizedString(UserInfoDict[indexPath.row], comment: "")
        cellChild.call_us_img?.image = UIImage(named: dictImage[indexPath.row])
        return cellChild
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0 || indexPath.row == 4)
        {
        return UITableViewAutomaticDimension
        }
        else
        {
            return 50
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            tableView.deselectRow(at: indexPath, animated: true)
            if(indexPath.row == 2)
            {
                UIApplication.shared.openURL(URL(string: "tel://3052241779")!)
                
            }
            else if(indexPath.row == 1) //About US
            {
                UIApplication.shared.openURL(URL(string: "tel://8095659599")!)

            }
            else if(indexPath.row == 4)
            {
                //MailComposer validate
                let mailComposerVC = MFMailComposeViewController()
                mailComposerVC.mailComposeDelegate = self
                //Mail ID check Login or not
                if(MFMailComposeViewController.canSendMail())
                {
                    sendMail()
                }
            }
    }
}
