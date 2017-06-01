//
//  Extension.swift
//  PageKit
//
//  Created by Jack on 4/6/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit

public extension Int {
    
    /// Begin Page
    public static let begin: Int = -1
    
    /// End Page
    public static let end: Int = -2
    
    /// Easy to convert Int to CGFloat
    public var cgfloat: CGFloat { return CGFloat(self) }
}

public extension CGFloat {
    public var double: Double { return Double(self) }
}

public extension Array {
    func enumIndex(_ block: (Index, Element) -> ()) {
        for (index, element) in self.enumerated() { block(index, element) }
    }
}

public extension CGRect {
    func resetBy(_ inset: UIEdgeInsets) -> CGRect {
        return CGRect(x: origin.x - inset.left,
                      y: origin.y - inset.top,
                      width: size.width - inset.left - inset.right,
                      height: size.height - inset.top - inset.bottom)
    }
}
