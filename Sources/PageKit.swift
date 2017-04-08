//
//  PageKit.swift
//  PageKit
//
//  Created by Jack on 4/7/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit

/// Live view type
///
/// - view: UIView
/// - viewController: UIViewController
public enum LiveViewType {
    case view(UIView)
    case viewController(UIViewController)
}

/// Represent a live view
public protocol LiveViewRepresentable: NSObjectProtocol {
    var liveViewType: LiveViewType { get }
    init()
}

// MARK: - Extension UIView LiveViewRepresentable
extension UIView: LiveViewRepresentable {
    public var liveViewType: LiveViewType { return .view(self) }
}

// MARK: - Extension UIViewController LiveViewRepresentable
extension UIViewController: LiveViewRepresentable {
    public var liveViewType: LiveViewType { return .viewController(self) }
}

public protocol PageKitDataSource: class {
    /// Asks for number of page
    ///
    /// - Returns: Number of page
    func numberOfPages() -> Int
}
