//
//  ReuseContainer.swift
//  PageKit
//
//  Created by Jack on 4/24/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import Foundation

/// Data source for container
public protocol ReuseContainerDataSource: BaseContainerDataSource {
    /// Asks for page by given index
    ///
    /// - Parameters:
    ///   - container: Container instanse
    ///   - index: Index
    /// - Returns: Page
    func container(_ container: ReuseContainer, pageForIndexAt index: Int) -> Page
}

open class ReuseContainer: Container {
    
    /// Aleardy registed pages
    internal var registedPages: [String: Page.Type] = [:]
    
    /// Reusable pages
    internal var reuseablePages: [String: Page] = [:]
    
    open override func clearPage() {
        super.clearPage()
        reuseablePages = [:]
    }
    
    open override func dynamicPage() {
        let visibleIndexCollection = visiblePagesIndexCollection()
        ///*********************************************************************
        ///                     (page is visible)
        ///             true                         false
        ///         (page == nil)                (page == nil)
        ///    true              false       true              false
        /// (new page)             (do nothing)            (remove old page)
        ///*********************************************************************
        for (index, page) in visiblePages.enumerated() {
            
            if visibleIndexCollection.contains(index),
                page == nil {
                if let newPage = (dataSource as? ReuseContainerDataSource)?.container(self, pageForIndexAt: index) {
                    load(newPage, withIndex: index)
                } else {
                    assertionFailure("Using ReuseContainerDataSource to slove this error")
                }
            }
            
            if !visibleIndexCollection.contains(index), let inVisiblePage = page {
                enterReuseQueue(inVisiblePage, withIndex: index)
            }
        }
    }
    
    internal override func load(_ newPage: Page, withIndex index: Int) {
        super.load(newPage, withIndex: index)
        reuseablePages[newPage.reuseIdentifier] = nil
    }
    
    /// Register page
    ///
    /// - Parameter pageClass: Page Type
    public final func register(_ pageClass: Page.Type) {
        registedPages[pageClass.reuseIdentifier] = pageClass
    }
    
    /// Dequeue page with identifier.
    ///
    /// - Parameter identifier: Page.reuse
    /// - Returns: Page with identifier, nil if not register page
    public final func dequeueReusablePage(withIdentifier identifier: String) -> Page? {
        return reuseablePages[identifier] ?? registedPages[identifier]?.init()
    }
    
    /// Enter page to `reuseablePages`
    ///
    /// - Parameter page: Page instance
    private func enterReuseQueue(_ oldPage: Page, withIndex index: Int) {
        removeSubPage(page: oldPage)
        reuseablePages[oldPage.reuseIdentifier] = oldPage
        visiblePages[index] = nil
    }
}
