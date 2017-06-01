//
//  PageKit.swift
//  PageKit
//
//  Created by Jack on 4/7/17.
//  Copyright © 2017 Jack. All rights reserved.
//

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
