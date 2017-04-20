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
    
    var container: Container!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let switchButton = UISwitch()
        switchButton.isOn = true
        switchButton.addTarget(self, action: #selector(switchReuse(sender:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: switchButton)
        view.backgroundColor = .white
        
        container = Container(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64))
        container.dataSource = self
        container.register(UIView.self)
        container.register(OriginalContainerOneViewController.self)
        
        view.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        container.reloadPage()
    }
    
    func numberOfPages() -> Int {
        return 10
    }
    
    func container(_ container: Container, pageForIndexAt index: Int) -> Page {
        if index % 2 == 0, let page = container.dequeueReusablePage(withIdentifier: UIView.reuseIdentifier) as? UIView {
            page.backgroundColor = .green
            return page
        } else if let page = container.dequeueReusablePage(withIdentifier: OriginalContainerOneViewController.reuseIdentifier) as? OriginalContainerOneViewController {
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
        imageView.image = #imageLiteral(resourceName: "origin_viewController_imageVIew")
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
