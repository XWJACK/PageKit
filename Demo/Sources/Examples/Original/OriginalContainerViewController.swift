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

class OriginalContainerViewController: BaseOriginalContainerViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "reuseEnable->"
        let switchButton = UISwitch()
        switchButton.isOn = true
        switchButton.addTarget(self, action: #selector(switchReuse(sender:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: switchButton)
        
        configContainer()
    }
    
    override func configContainer() {
        super.configContainer()
        
        container.register(UIView.self)
        container.register(OriginalContainerOneViewController.self)
        
        container.reloadPage()
    }
    
    override func numberOfPages() -> Int {
        return 10
    }
    
    override func container(_ container: Container, pageForIndexAt index: Int) -> Page {
        if index % 2 == 0, let page = container.dequeueReusablePage(withIdentifier: UIView.reuseIdentifier) as? UIView {
            page.backgroundColor = .green
            return page
        } else if let page = container.dequeueReusablePage(withIdentifier: OriginalContainerOneViewController.reuseIdentifier) as? OriginalContainerOneViewController {
            page.imageView.image = #imageLiteral(resourceName: "origin_viewController_imageVIew")
            return page
        } else {
            let view = UIView()
            view.backgroundColor = .red
            return view
        }
    }
    
    func switchReuse(sender: UISwitch) {
        container.isReuseEnable = sender.isOn
    }
}

class OriginalContainerOneViewController: UIViewController {
    
    let imageView =  UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
