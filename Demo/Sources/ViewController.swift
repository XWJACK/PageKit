//
//  ViewController.swift
//  PageKitDemo
//
//  Created by Jack on 12/13/16.
//  Copyright © 2016 Jack. All rights reserved.
//

import UIKit
import PageKit

class ViewController: UIViewController {
    var tableView: UITableView!
    var dataSources = ExampleList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "PageKit"
        
        navigationController?.navigationBar.isTranslucent = false
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSources.examples.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources.examples[section].row.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
        
        cell.textLabel?.text = dataSources.examples[indexPath.section].row[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSources.examples[section].title
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        let controller = dataSources.examples[indexPath.section].row[indexPath.row].controllerType.init()
        controller.title = dataSources.examples[indexPath.section].row[indexPath.row].title
        navigationController?.pushViewController(controller, animated: true)
    }
}
