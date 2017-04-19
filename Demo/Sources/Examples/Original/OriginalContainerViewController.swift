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
        guard let page = container.dequeueReusablePage(withIdentifier: UIView.reuseIdentifier) as? UIView else { return UIView() }
        page.backgroundColor = index % 2 == 0 ? .red : .black
        return page
    }
    
    func switchReuse(sender: UISwitch) {
        container.isReuseEnable = sender.isOn
    }
}
