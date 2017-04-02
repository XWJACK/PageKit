//
//  NormalIndicatorViewController.swift
//  PageDemo
//
//  Created by Jack on 4/1/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit
import PageKit

class NormalIndicatorViewController: CustomViewController<NormalIndicatorHeader, Pager> {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func header(_ header: Header, sizeForIndicator indicator: UIView, underTitle: UIControl, with index: Int) -> CGSize {
        return CGSize(width: underTitle.frame.width, height: 2)
    }
}
