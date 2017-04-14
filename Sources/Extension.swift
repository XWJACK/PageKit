//
//  Extension.swift
//  PageKit
//
//  Created by Jack on 4/6/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import Foundation

public extension Int {
    public static let begin: Int = -1
    public static let end: Int = -2
    
    public var cgfloat: CGFloat { return CGFloat(self) }
    
//    public func reduces<Result>(_ initialResult: Result, nextPartialResult: (Int) -> Result) -> Result {
//        var result = initialResult
//        for index in 0..<self {
//            result += nextPartialResult(index)
//        }
//        return result
//    }
}

extension Array {
    func enumIndex(_ block: (Index, Element) -> ()) {
        for (index, element) in self.enumerated() { block(index, element) }
    }
}
