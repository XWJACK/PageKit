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
        container = ContainerType(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64))
        
        view.addSubview(container)
        
        container.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
