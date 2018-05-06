//
//  NoInternetViewController.swift
//  Puradom
//
//  Created by Lakeba_26 on 05/05/18.
//  Copyright © 2018 Lakeba_26. All rights reserved.
//

import UIKit
protocol internetConnectionDelegate {
    func internetHandling(internetView : NoInternetViewController)
}
class NoInternetViewController: UIViewController {

    @IBOutlet var btn_reload: UIButton!
    @IBOutlet var contentView: UIView!
    var internetDelegate : internetConnectionDelegate?
    var rootVC : UIViewController!
    init(nibName nibNameOrNil: String, root parentViewController: UIViewController) {
        super.init(nibName: nibNameOrNil, bundle: nil)
        self.rootVC = parentViewController
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func reload_action(_ sender: Any) {
        self.internetDelegate?.internetHandling(internetView: self)
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
