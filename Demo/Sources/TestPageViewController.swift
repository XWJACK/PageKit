//
//  TestPageViewController.swift
//  PageKitDemo
//
//  Created by Jack on 20/07/2017.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit

class TestPageViewController: UIViewController {

    let button = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        button.setImage(#imageLiteral(resourceName: "origin_background1"), for: .normal)
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
