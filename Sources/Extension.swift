//
//  Extension.swift
//  PageKit
//
//  Created by Jack on 4/6/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import Foundation

public extension Int {
    
    /// Begin Page
    public static let begin: Int = -1
    
    /// End Page
    public static let end: Int = -2
    
    /// Easy to convert Int to CGFloat
    public var cgfloat: CGFloat { return CGFloat(self) }
}

public extension Array {
    func enumIndex(_ block: (Index, Element) -> ()) {
        for (index, element) in self.enumerated() { block(index, element) }
    }
}
