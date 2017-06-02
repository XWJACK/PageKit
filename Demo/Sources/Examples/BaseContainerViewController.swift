//
//  BaseContainerViewController.swift
//  PageKitDemo
//
//  Created by Jack on 4/24/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit
import PageKit
import SnapKit

class BaseContainerViewController<ContainerType: Container>: UIViewController {
    
    var container: ContainerType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configContainer()
    }
    
    func configContainer() {
        container = ContainerType()
        
        view.addSubview(container)
        
        container.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
