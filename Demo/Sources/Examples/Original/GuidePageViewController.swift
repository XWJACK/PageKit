//
//  GuidePageViewController.swift
//  PageKitDemo
//
//  Created by Jack on 20/07/2017.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit
import PageKit

class GuidePageViewController: UIViewController, GuidePageDatasource {

    let guidePage = GuidePage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guidePage.dataSource = self
        guidePage.register(TestPageImageView.self)
        guidePage.register(TestPageViewController.self)
        
        view.addSubview(guidePage)
        guidePage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    func numberOfPages() -> Int {
        return 5
    }
    
    func guidePage(_ guidePage: GuidePage, pageForIndexAt index: Int) -> Page {
        if index % 2 == 0, let page = guidePage.dequeueReusablePage(withIdentifier: TestPageImageView.reuseIdentifier) as? UIImageView {
            page.image = #imageLiteral(resourceName: "origin_background0")
            return page
        } else if let page = guidePage.dequeueReusablePage(withIdentifier: TestPageViewController.reuseIdentifier) as? TestPageViewController {
            return page
        } else {
            let view = UIImageView()
            view.backgroundColor = .red
            return view
        }
    }
}
