//
//  VPPopOver.swift
//  VoicePRO
//
//  Created by Lakeba_26 on 25/01/18.
//  Copyright © 2018 Lakeba_26. All rights reserved.
//

import UIKit

enum screenType{
    case FULL_SCREEN
    case HALF_SCREEN
}
class VPPopOver: UIView {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        // Remove already visible popup view in window.
        let popView = (UIApplication.shared.keyWindow?.viewWithTag(1300))
        if(popView != nil)
        {
            popView?.removeFromSuperview()
        }
        // Creting new pop up view
        let windowRect = UIApplication.shared.keyWindow?.bounds
        self.backgroundColor = UIColor.init(white: 0, alpha:0.40)
        self.frame = windowRect!
        self.tag = 1301
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewController view: UIView, withFullScreen screen: screenType)
    {

        self.init()
        // Loading new view inside popup view
        let viewSize = self.frame.size
        var listView : UIView!
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            switch(screen)
            {
            case .FULL_SCREEN :
                listView = UIView.init(frame: CGRect(x: viewSize.width / 2, y: 44, width: viewSize.width / 2, height: 100))
                
            case .HALF_SCREEN:
                listView = UIView.init(frame: CGRect(x: viewSize.width / 2, y: 64, width: viewSize.width / 2, height: 100))
            }
            
        }
        else
        {
            switch(screen)
            {
            case .FULL_SCREEN :
                listView = UIView.init(frame: CGRect(x: viewSize.width / 2, y: 44, width: viewSize.width / 2, height: 100))
                
            case .HALF_SCREEN:
                listView = UIView.init(frame: CGRect(x: viewSize.width / 2, y: 64, width: viewSize.width / 2, height: 100))
            }
        }
        listView.backgroundColor = UIColor.clear
        view.backgroundColor = listView.backgroundColor
        view.frame = listView.bounds
        listView.addSubview(view)
        self.addSubview(listView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view == self {
            removeFromSuperview()
        }
    }
    func dismiss()
    {
        self.removeFromSuperview()
    }
    
}
