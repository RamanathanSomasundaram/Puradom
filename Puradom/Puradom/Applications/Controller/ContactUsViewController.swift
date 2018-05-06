//
//  ContactUsViewController.swift
//  Puradom
//
//  Created by Lakeba_26 on 18/04/18.
//  Copyright © 2018 Lakeba_26. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {

    @IBOutlet var txt_Name: SkyFloatingLabelTextField!
    @IBOutlet var txt_Email: SkyFloatingLabelTextField!
    @IBOutlet var txt_Phone: SkyFloatingLabelTextField!
    @IBOutlet var txtView_Message: SkyFloatingLabelTextField!
    @IBOutlet var txt_Subject: SkyFloatingLabelTextField!
    var globalProduct_ID : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.NavigationControllerMenu()
        let UserDetails = (UserDefaults.standard.dictionary(forKey: "UserDetails"))
        if(UserDetails != nil)
        {
            txt_Name.text = (UserDetails!["UserName"] as! String)
            txt_Email.text = (UserDetails!["Email"] as! String)
            txt_Phone.text = (UserDetails!["Phone"] as! String)
        }
        txt_Name.placeholder = NSLocalizedString("name", comment: "")
        txt_Email.placeholder = NSLocalizedString("email", comment: "")
        txt_Phone.placeholder = NSLocalizedString("phone", comment: "")
        txt_Subject.placeholder = NSLocalizedString("tema", comment: "")
        txtView_Message.placeholder = NSLocalizedString("message", comment: "")
        // Do any additional setup after loading the view.
    }
    
    //Navigation Menu
    func NavigationControllerMenu()
    {
        self.navigationItem.hidesBackButton = true
        self.title = "Contact Us"
        self.navigationItem.hidesBackButton = true
        let flipButton = UIBarButtonItem.init(image: UIImage.init(named: "Back"), style: .plain, target: self, action: #selector(backHome))
        flipButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = flipButton
    }
    
    @objc func backHome()
    {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func sendMessage_Action(_ sender: Any) {
        
        if(self.allfieldsValidation())
        {
        if(!(txt_Name.text?.isEmpty)! && !(txt_Email.text?.isEmpty)! && !(txt_Phone.text?.isEmpty)!)
        {
        let userInfo = ["UserName" : txt_Name.text! , "Email" : txt_Email.text! , "Phone" : txt_Phone.text!]
        UserDefaults.standard.set(userInfo, forKey: "UserDetails")
        UserDefaults.standard.synchronize()
            if(globalProduct_ID != nil)
            {
            self.sendMessageAPI(username: txt_Name.text!, Email: txt_Email.text!, Phone: txt_Phone.text!, Subject: txt_Subject.text!, Message: txtView_Message.text!, Product_ID: globalProduct_ID! )
            }
            else
            {
                self.sendMessageAPI(username: txt_Name.text!, Email: txt_Email.text!, Phone: txt_Phone.text!, Subject: txt_Subject.text!, Message: txtView_Message.text!, Product_ID: "33" )
            }
        }
        }
        
    }
    
    func sendMessageAPI(username: String, Email : String, Phone : String , Subject : String , Message : String , Product_ID : String)
    {
        
        let AppendAPI = "name=\(username)&email=\(Email)&phone=\(Phone)&subject=\(Subject)&message=\(Message)&product_id=\(Product_ID)"
        if(Utilities.checkForInternet())
        {
            Utilities.showLoading()
            Alamofire.request(CONTACT_US+AppendAPI).responseJSON { response in
                let error = response.result.error
                if response.response?.statusCode == -1001
                {
                    Utilities.hideLoading()
                    self.noInternetConnection()
                    return
                }
                if error != nil
                {
                    Utilities.hideLoading()
                    Utilities.showAlert(error! as! String)
                    return
                }
                if let json = response.result.value {
                    let jsonResult = ((json as AnyObject).value(forKey: "message")! as! String)
                    Utilities.showAlertToast(title: "Success", message: jsonResult, type: .success)
                }
                let dispatchTime = DispatchTime.now()
                DispatchQueue.main.asyncAfter(deadline: dispatchTime , execute: {
                    Utilities.hideLoading()
                    //commonAppDelegate.window?.makeToast(message: Message, duration: 1.0, position: "center" as AnyObject)
                })
            }
        }
        else
        {
            self.noInternetConnection()
        }
        
    }
    
    func allfieldsValidation()->Bool
    {
        let inputFileds = [txt_Name, txt_Email,txt_Phone,txt_Subject]
        for fields in inputFileds
        {
            if (fields?.text?.isEmpty)!
            {
                Utilities.AnimationShakeTextField(textField: fields!)
                //CRNotifications.showNotification(type: .error, title: "Warning", message: "Required field", dismissDelay: 3.0)
                Utilities.showAlertToast(title: "Warning", message: "Required field", type: .warning)
                fields?.errorMessage = ""
                return false
            }
        }
        return true
    }
    
    //No Internet Connection
    func noInternetConnection()
    {
        Utilities.showAlertToast(title: "Error", message: "No Internet Connection", type: .error)
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

extension ContactUsViewController : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        txt_Subject.errorMessage = ""
        txtView_Message.errorMessage = ""

    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        textField.endEditing(true)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    /// Implementing a method on the UITextFieldDelegate protocol. This will notify us when something has changed on the textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
          if floatingLabelTextField.tag == 101
          {
            if(floatingLabelTextField.text!.count > 3)
            {
                if !userTextFieldValidation.isValidFullName(UserName: floatingLabelTextField.text!)
                {
                    floatingLabelTextField.errorMessage = "Enter the name more than 3 characters"
                }
                
            }
            else
            {
                floatingLabelTextField.errorMessage = ""
            }
            }
            if floatingLabelTextField.tag == 102
            {
                if !userTextFieldValidation.isValidEmail(Email: floatingLabelTextField.text!)
                {
                    floatingLabelTextField.errorMessage = "Invalid Email Address"
                }
                else
                {
                        floatingLabelTextField.errorMessage = ""
                }
            }
            
           if floatingLabelTextField.tag == 103
           {
                if !userTextFieldValidation.validatePhoneNumber(PhoneNumber: floatingLabelTextField.text!)
                {
                    floatingLabelTextField.errorMessage = "Invalid Mobile Number"
                }
                else
                {
                    floatingLabelTextField.errorMessage = ""
                }
            }
           
        }
        return true
    }
}

