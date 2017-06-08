//
//  Extension.swift
//  PageKit
//
//  Created by Jack on 4/6/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit

public extension Int {
    
    /// Easy to convert Int to CGFloat
    public var cgfloat: CGFloat { return CGFloat(self) }
}

public extension CGRect {
    func resetBy(_ inset: UIEdgeInsets) -> CGRect {
        return CGRect(x: origin.x - inset.left,
                      y: origin.y - inset.top,
                      width: size.width - inset.left - inset.right,
                      height: size.height - inset.top - inset.bottom)
    }
}
