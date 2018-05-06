//
//  LanguageSettingsViewController.swift
//  Puradom
//
//  Created by Lakeba_26 on 05/05/18.
//  Copyright © 2018 Lakeba_26. All rights reserved.
//

import UIKit
protocol LanguageSettingsDelegate: NSObjectProtocol {
    func LanguageMenuList(_ optionMenu: LanguageSettingsViewController, didSelectRowAt indexPath: IndexPath)
}
class LanguageSettingsViewController: UIView {
    var OptionTable : UITableView!
    weak var OptionDelegate : LanguageSettingsDelegate?
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    let languageArray = ["english", "spanish"]
    
    //Init frame on tableview controller
    override init(frame: CGRect) {
        super.init(frame: frame)
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)
        {
            self.OptionTable = UITableView.init(frame: CGRect(x: 0, y: 0, width: screenWidth / 2, height: screenHeight - 68) , style: .plain)
        }else
        {
            self.OptionTable = UITableView.init(frame: CGRect(x: 0, y: 0, width: screenWidth / 2, height: screenHeight - 68) , style: .plain)
        }
        commonAppDelegate = UIApplication.shared.delegate as! AppDelegate
        self.OptionTable.translatesAutoresizingMaskIntoConstraints = false
        self.OptionTable.delegate = self
        self.OptionTable.dataSource = self
        self.OptionTable.backgroundColor = UIColor.white
        self.OptionTable.separatorStyle = .singleLine
        self.addSubview(self.OptionTable)
        self.OptionTable.tableFooterView = UIView.init(frame: .zero)
        let views = ["view": self, "new_view": OptionTable ] as [String : Any]
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[new_view]-(0)-|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: views)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[new_view]-(0)-|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: views)
        self.addConstraints(horizontalConstraints)
        self.addConstraints(verticalConstraints)
        self.OptionTable.register(UITableViewCell.self, forCellReuseIdentifier: "EditorListCell1")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension LanguageSettingsViewController : UITableViewDataSource, UITableViewDelegate{
    //MARK: - Table View Datasource and Delegate methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad) ? 60 : 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorInset = .zero
        var cell = tableView.dequeueReusableCell(withIdentifier: "EditorListCell1")
        if(cell == nil)
        {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "EditorListCell1")
        }
        cell?.textLabel?.text = NSLocalizedString(languageArray[indexPath.row], comment: "")
        cell?.textLabel?.adjustsFontSizeToFitWidth = true
        cell?.backgroundColor = UIColor.clear
        cell?.textLabel?.textColor = UIColor.black
        tableView.separatorColor = UIColor.black
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.OptionDelegate?.LanguageMenuList(self, didSelectRowAt: indexPath)
    }
}
