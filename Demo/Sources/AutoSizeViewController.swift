//
//  AutoSizeViewController.swift
//  PageView
//
//  Created by Jack on 1/12/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit
import PageKit

class AutoSizeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        pageView.pager.autoresizePage = false
        reloadPageView()
    }
    
    override func page(_ page: Pager, sizeForIndexAt index: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.height - 98 - 50)
    }
}
