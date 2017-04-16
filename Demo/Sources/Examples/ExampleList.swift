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
        examples.append(("Original", [("OriginalContainer", OriginalContainerViewController.self)]))
    }
}
