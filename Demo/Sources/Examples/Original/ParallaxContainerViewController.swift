//
//  ParallaxContainerViewController.swift
//  PageKitDemo
//
//  Created by Jack on 4/20/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit
import PageKit
import SnapKit

class ParallaxContainerViewController: BaseContainerViewController<Container> {
    
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        
        backgroundImageView.image = #imageLiteral(resourceName: "origin_sync_viewController_backgroundImageView")
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.height.equalToSuperview()
            make.width.equalTo(10 * view.frame.width)
        }
        
        super.viewDidLoad()
    }
    
    override func configContainer() {
        super.configContainer()
        container.isPagingEnabled = false
        container.syncScrollBlock = syncScroll
        container.reloadPage()
    }
    
    func syncScroll(current: Double, total: Double) {
        guard current >= 0, current / total <= 1 else { return }
        let originX = -9 * view.frame.width * CGFloat(current / total)
        backgroundImageView.frame.origin.x = originX
    }
}
