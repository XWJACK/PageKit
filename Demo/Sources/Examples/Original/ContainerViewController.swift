//
//  ContainerViewController.swift
//  PageKitDemo
//
//  Created by Jack on 4/20/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit
import PageKit

class ContainerViewController: BaseContainerViewController<Container>, ContainerDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func configContainer() {
        super.configContainer()
        
        container.dataSource = self
        container.reloadPage()
    }
    func numberOfPages() -> Int {
        return 10
    }
    func container(_ container: Container, pageForIndexAt index: Int) -> Page {
        
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "origin_background0")
        return imageView
    }
}
