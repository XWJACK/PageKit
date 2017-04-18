//
//  OriginalContainer.swift
//  PageKitDemo
//
//  Created by Jack on 4/14/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import Foundation
import PageKit
import SnapKit

class OriginalContainerViewController: UIViewController, ContainerDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let container = Container(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64))
        container.dataSource = self
        
        view.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        container.reloadPage()
    }
    
    func numberOfPages() -> Int {
        return 10
    }
}
