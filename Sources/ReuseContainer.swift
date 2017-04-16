//
//  ReuseContainer.swift
//  PageKit
//
//  Created by Jack on 4/8/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import Foundation

/// Represent container can reusable
open class ReuseContainer: Container {
    
    open var isReuseEnable: Bool = true
    
    internal var registedPages: [String: Page.Type] = [:]
    internal var reuseablePages: [String: Page] = [:]
    internal var visiblePages: [String: Page] = [:]
    
    /// Register page
    ///
    /// - Parameter pageClass: Page Type
    public final func register(_ pageClass: Page.Type) {
        registedPages[pageClass.reuseIdentifier] = pageClass
    }
    
    /// Enqueue page to reuseablePages
    ///
    /// - Parameter page: Page instance
    private func enqueue(_ page: Page) {
        reuseablePages[page.reuseIdentifier] = page
    }
    
    /// Dequeue page with identifier
    ///
    /// - Parameter identifier: Page.reuse
    /// - Returns: Page with identifier, nil if not register page
    public final func dequeueReusablePage(withIdentifier identifier: String) -> Page? {
        return reuseablePages[identifier] ?? registedPages[identifier]?.init()
    }
}
