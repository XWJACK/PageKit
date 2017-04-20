//
//  BaseOriginContainerViewController.swift
//  PageKitDemo
//
//  Created by Jack on 4/20/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit
import PageKit

class BaseOriginalContainerViewController: UIViewController, ContainerDataSource {
    
    var container: Container!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    func configContainer() {
        container = Container(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64))
        container.dataSource = self
        
        view.addSubview(container)
        
        container.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func numberOfPages() -> Int {
        return 10
    }
    
    func container(_ container: Container, pageForIndexAt index: Int) -> Page {
        return UIView()
    }
}
