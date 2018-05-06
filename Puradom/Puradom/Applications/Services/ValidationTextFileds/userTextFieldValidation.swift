//
//  userTextFieldValidation.swift
//  XpressDeal
//
//  Created by Lakeba_26 on 26/11/17.
//  Copyright © 2017 spiksolutions. All rights reserved.
//

import UIKit

class userTextFieldValidation: NSObject {
    
    //singleton Instance
    class func sharedInstance() -> userTextFieldValidation {
        var ValidationClass: userTextFieldValidation?
        if(ValidationClass == nil)
        {
            ValidationClass = userTextFieldValidation()
        }
        return ValidationClass!
    }
    
    //MARK: - Check Validate Username
    class func isValidFullName(UserName : String) -> Bool
    {
        let RegEx = "\\A\\w{2,18}\\z"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: UserName)
    }
    
    //MARK: - Email verification
    class func isValidEmail(Email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9-]+\\.[A-Za-z]{2,3}"
        let pred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return pred.evaluate(with: Email)
    }
    
    //MARK: - Password verification
    class func isPasswordValid(password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,20}")
        return passwordTest.evaluate(with: password)
    }
    
    //MARK: - PhoneNumber verification
    class func validatePhoneNumber(PhoneNumber: String) -> Bool {
        
        //WithCountry Code verfication use this -> "^((\\+)|(00))[0-9]{6,14}$"
        //Without Country Code verfication use this -> "^[0-9]{6,14}$"
        let PHONE_REGEX = "^[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        return phoneTest.evaluate(with: PhoneNumber)
    }
    
    //MARK: - Pincode Verfication
    class func isValidPincode(pincode: String) -> Bool {
        if pincode.count == 6{
            return true
        }
        else{
            return false
        }
    }
    
}
