//
//  ExampleList.swift
//  PageKitDemo
//
//  Created by Jack on 4/14/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit
import PageKit

struct ExampleList {
    var examples: [(title: String, row: [(title: String, controllerType: UIViewController.Type)])] = []
    init() {
        examples.append(("Original", [("GuidePage", GuidePageViewController.self)/*("Container", ContainerViewController.self),
                                      ("ReuseContainer", ReuseContainerViewController.self)*/]))
    }
}

//struct ExampleList {
//    var examples: [String: [(String, UIViewController.Type)]] = [:]
//    init() {
//        examples["Original"] = [("Original-ReuseEnable", OriginalContainerViewController.self)]
//    }
//}
