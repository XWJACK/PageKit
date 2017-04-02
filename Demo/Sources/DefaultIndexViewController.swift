//
//  DefaultIndexViewController.swift
//  PageView
//
//  Created by Jack on 1/12/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit

class DefaultIndexViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageView.defaultIndex = 1
        reloadPageView()
    }
}
