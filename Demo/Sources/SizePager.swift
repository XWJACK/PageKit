//
//  SizePager.swift
//  PageDemo
//
//  Created by Jack on 3/30/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit
import PageKit

class SizePager: Pager {
    override func pageWillSwitch(from fromController: UIViewController?, fromIndex: Int,
                                 to nextController: UIViewController?, nextIndex: Int,
                                 completed percent: CGFloat) {
        
        fromController?.view.frame = CGRect(x: CGFloat(fromIndex) * frame.width + frame.width / 2 * percent,
                                            y: center.y * percent,
                                            width: frame.width * (1 - percent),
                                            height: frame.height * (1 - percent))
        nextController?.view.frame = CGRect(x: CGFloat(nextIndex) * frame.width + frame.width / 2 * (1 - percent),
                                          y: center.y * (1 - percent),
                                          width: frame.width * percent,
                                          height: frame.height * percent)
    }
}
