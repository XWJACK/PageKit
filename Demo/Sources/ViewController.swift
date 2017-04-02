//
//  ViewController.swift
//  Demo
//
//  Created by Jack on 12/13/16.
//  Copyright © 2016 Jack. All rights reserved.
//

import UIKit
import PageKit

class ViewController: UIViewController {
    var tableView: UITableView!
    var sectionTitle = ["😇基本使用", "😇切换时添加动画", "😇重写事件"]
    var titles = [["默认不带指示条", "显示默认指示条", "默认第一次位置", "自定义page大小"], ["切换调节Aha", "切换调节Size"], ["控制下一个Page的加载时机"]]
    
    
    override func loadView() {
        super.loadView()
        self.title = "PageView"
        
        navigationController?.navigationBar.isTranslucent = false
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier:"Cell")
        
        cell.textLabel?.text = titles[indexPath.section][indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        var controller: UIViewController!
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0): controller = NormalViewController()
        case (0, 1): controller = NormalIndicatorViewController()
        case (0, 2): controller = DefaultIndexViewController()
        case (0, 3): controller = AutoSizeViewController()
            
        case (1, 0): controller = CustomViewController<Header, AhaPager>()
        case (1, 1): controller = CustomViewController<Header, SizePager>()
            
        case (2, 0): controller = CustomViewController<Header, LoadTimePager>()
        default: break
        }
        controller.title = titles[indexPath.section][indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}
