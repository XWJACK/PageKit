//
//  PageKit.swift
//
//  Copyright (c) 2017 Jack
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

/// Page type
///
/// - view: UIView
/// - viewController: UIViewController
public enum PageType {
    case view(UIView)
    case viewController(UIViewController)
}

// MARK: - PageReusable

/// Represent a identifier for page
public protocol PageReusable {
    
    /// Identifier for reusing page
    var reuseIdentifier: String { get }
    
    /// Identifier for reusing page
    static var reuseIdentifier: String { get }
}

// MARK: - PageRepresentable

/// Represent a Page
public protocol PageRepresentable: PageReusable, NSObjectProtocol {
    
    /// Define page type
    var pageType: PageType { get }
    
    /// Can be init
    init()
}

// MARK: - Extension UIView with PageRepresentable
extension UIView: PageRepresentable {
    
    public var pageType: PageType { return .view(self) }
    
    public var reuseIdentifier: String { return String(describing: type(of: self)) }
    
    public static var reuseIdentifier: String { return String(describing: self) }
}

// MARK: - Extension UIViewController with PageRepresentable
extension UIViewController: PageRepresentable {
    
    public var pageType: PageType { return .viewController(self) }
    
    public var reuseIdentifier: String { return String(describing: type(of: self)) }
    
    public static var reuseIdentifier: String { return String(describing: self) }
}
