//
//  SlideMenuListController.swift
//  Puradom
//
//  Created by Lakeba_26 on 18/04/18.
//  Copyright © 2018 Lakeba_26. All rights reserved.
//

import UIKit
import MessageUI
class SlideMenuListController: UIViewController,MFMailComposeViewControllerDelegate {

    @IBOutlet var btn_email: UIButton!
    @IBOutlet var tbl_slideMenu: UITableView!
    var firstSectionTitle = ["home","product","about_us","contact_us"]
    var firstSectionImage = ["home","productlist","about","contact"]
    var firstSectionHighlightImage = ["shome","sproductlist","sabout","scontact"]
    var secondSectionTitle = ["Share"]
    var secondSectionImage = ["share"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btn_email_action(_ sender: Any) {
        //MailComposer validate
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        //Mail ID check Login or not
        if(MFMailComposeViewController.canSendMail())
        {
            sendMail()
        }
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
            self.navigationController?.popToRootViewController(animated: true)
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

extension SlideMenuListController : UITableViewDelegate,UITableViewDataSource
{
    //MARK: - Tableview Datasource and Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0)
        {
            return firstSectionTitle.count
        }
        else
        {
            return secondSectionTitle.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier = "RecordListCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier)
        if cell == nil{
            cell = UITableViewCell.init(style: .default, reuseIdentifier:CellIdentifier )
        }
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 15.0)
        //cell?.textLabel?.font = UIFont(name: "Helvetica", size: 15.0)
        cell?.textLabel?.textColor = UIColor.darkGray
        cell?.imageView?.tintColor = UIColor.lightGray
        if(indexPath.section == 0)
        {
            cell?.textLabel?.text = NSLocalizedString((firstSectionTitle[indexPath.row] as String), comment: "")
            cell?.imageView?.image = UIImage.init(named: (firstSectionImage[indexPath.row] as String))
            cell?.imageView?.highlightedImage = UIImage.init(named: (firstSectionHighlightImage[indexPath.row] as String))
        }
        else
        {
            cell?.textLabel?.text = (secondSectionTitle[indexPath.row] as String)
            cell?.imageView?.image = UIImage.init(named: (secondSectionImage[indexPath.row] as String))
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 1)
        {
            return 40
        }
        else
        {
            return 0.5
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(section == 1)
        {
            let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
            let lineLable = UILabel.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height:1))
            lineLable.backgroundColor = UIColor.lightGray
            headerView.addSubview(lineLable)
            headerView.backgroundColor = UIColor.white
            let titleLable = UILabel.init(frame: CGRect(x: 10, y: 0, width: tableView.frame.size.width, height: 40))
            titleLable.font = UIFont.systemFont(ofSize: 15.0)
            titleLable.text = "Communicate"
            titleLable.textColor = UIColor.lightGray
            headerView.addSubview(titleLable)
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0)
        {
            if(indexPath.row == 0)
            {
                tableView.deselectRow(at: indexPath, animated: true)
                let homePage = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                self.navigationController?.pushViewController(homePage, animated: true)
            }
            else if(indexPath.row == 1)
            {
                //Product List
                
                let productList = self.storyboard?.instantiateViewController(withIdentifier: "ProductListController") as! ProductListController
                self.navigationController?.pushViewController(productList, animated: true)
                
            }
            else if(indexPath.row == 2) //About US
            {
                let About = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
                self.navigationController?.pushViewController(About, animated: true)
                
            }
            else //Contact US
            {
                let contactUS = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
                self.navigationController?.pushViewController(contactUS, animated: true)
            }
        }
        else if(indexPath.section == 1)
        {
            if(indexPath.row == 0)
            {
                //Share file
                self.sharewith()
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    //MARK: - Share a file action
    func sharewith()
    {
        DispatchQueue.main.async(execute: {() -> Void in
            let currentFileName = "https://itunes.apple.com/us/app/Puradom/id1290367397?mt=8"
            let sharingText = "Let me recommend you this application"
            let sharingImage = UIImage.init(named: "MenuLogo.png")!
            let sharingURL = URL.init(string: currentFileName)
            //let sharingItems:[AnyObject?] = [ sharingText,sharingImage as AnyObject,sharingURL as AnyObject]
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [sharingText, sharingURL!, sharingImage], applicationActivities: nil)
            //let activityViewController = UIActivityViewController(activityItems: sharingItems.flatMap({$0}), applicationActivities: nil)
            if UIDevice.current.userInterfaceIdiom == .pad {
                activityViewController.popoverPresentationController?.sourceView = self.view
                let popup = UIPopoverController.init(contentViewController: activityViewController) as UIPopoverController
                popup.present(from: CGRect(x: CGFloat(self.view.frame.size.width / 2), y: CGFloat(self.view.frame.size.height / 4), width: CGFloat(0), height: CGFloat(0)), in: self.view, permittedArrowDirections: .any, animated: true)
            }
            else{
                self.present(activityViewController, animated: true, completion: {
                    self.navigationController?.popToRootViewController(animated: true)
                })
                //self.present(activityViewController, animated: true, completion: nil)
            }
        })
    }
}
