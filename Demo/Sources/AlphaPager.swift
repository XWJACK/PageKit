//
//  AhaPager.swift
//  PageDemo
//
//  Created by Jack on 3/30/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit
import PageKit

class AhaPager: Pager {
    
    override func pageWillSwitch(from fromController: UIViewController?, fromIndex: Int,
                                 to nextController: UIViewController?, nextIndex: Int,
                                 completed percent: CGFloat) {
        
        fromController?.view.alpha = 1 - percent
        nextController?.view.alpha = percent
    }
}
