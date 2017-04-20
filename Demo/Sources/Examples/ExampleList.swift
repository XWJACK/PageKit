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
        examples.append(("Original", [("Normal", OriginalContainerViewController.self),
                                      ("Parallax", OriginalParallaxContainerViewController.self)]))
    }
}

//struct ExampleList {
//    var examples: [String: [(String, UIViewController.Type)]] = [:]
//    init() {
//        examples["Original"] = [("Original-ReuseEnable", OriginalContainerViewController.self)]
//    }
//}
