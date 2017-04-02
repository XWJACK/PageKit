//
//  LoadTimePager.swift
//  PageDemo
//
//  Created by Jack on 3/31/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit
import PageKit

class LoadTimePager: Pager {
    override func pageWillLoadNextController(with index: Int, completed percent: CGFloat) -> Bool {
        return percent > 0.5
    }
}
