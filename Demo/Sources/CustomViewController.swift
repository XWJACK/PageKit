//
//  CustomViewController.swift
//  PageDemo
//
//  Created by Jack on 3/30/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit
import PageKit
import SnapKit

class CustomViewController<HeaderType: Header, PagerType: Pager>: UIViewController, PageViewDataSources, PageViewDelegate {

    var pageView: PageView<HeaderType, PagerType>!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        pageView = PageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 64))
        view.addSubview(pageView)
        pageView.delegate = self
        pageView.dataSources = self
        pageView.header.indicator.backgroundColor = .black
        pageView.reloadPageView()
    }

    func reloadPageView() {
        pageView.reloadPageView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func header(_ header: Header, titleForIndexAt index: Int) -> UIControl {
        let button = UIButton(type: .custom)
        button.setTitle(index.description + "ABC", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.backgroundColor = index % 2 == 0 ? .orange : .purple
        return button
    }
    
    func header(_ header: Header, with title: UIControl, sizeForIndexAt index: Int) -> CGSize {
        return CGSize(width: 47, height: 34)
    }
    
    func page(_ page: Pager, sizeForIndexAt index: Int) -> CGSize {
        return .zero
    }
    
    func PageView(frameForHeader header: Header) -> CGRect {
        return CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35)
    }
    
    func numberOfPageViews() -> Int {
        return 10
    }
    
    func page(_ page: Pager, pageForIndexAt index: Int) -> UIViewController {
        let controller = UIViewController()
        let label = UILabel()
        label.text = index.description
        label.textColor = index % 2 == 0 ? .green : .red
        label.font = UIFont.systemFont(ofSize: 90)
        controller.view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        controller.view.backgroundColor = index % 2 == 0 ? .red : .green
        return controller
    }
}
