//
//  ReuseContainer.swift
//  PageKit
//
//  Created by Jack on 4/24/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import Foundation

/// Data source for container
public protocol ReuseContainerDataSource: ContainerDataSource {
    /// Asks for page by given index
    ///
    /// - Parameters:
    ///   - container: Container instanse
    ///   - index: Index
    /// - Returns: Page
    func container(_ container: ReuseContainer, pageForIndexAt index: Int) -> Page
}

/// Container with reuseable
open class ReuseContainer: Container {
    
    /// Aleardy registed pages
    private var registedPages: [String: Page.Type] = [:]
    /// Reusable pages
    private var reuseablePages: [String: Page] = [:]
    /// Visible pages
    private var visiblePages: [Page?] = []
    
    open override func reloadData() {
        super.reloadData()
        reuseablePages = [:]
        visiblePages = Array(repeating: nil, count: numberOfPages)
        visiblePages.reserveCapacity(numberOfPages)
        dynamicPage()
    }
    
    open func dynamicPage() {
        let visibleIndexs = visiblePagesIndexs()
        ///*********************************************************************
        ///                     (page is visible)
        ///             true                         false
        ///         (page == nil)                (page == nil)
        ///    true              false       true              false
        /// (new page)             (do nothing)            (remove old page)
        ///*********************************************************************
        for (index, page) in visiblePages.enumerated() {
            
            if visibleIndexs.contains(index),
                page == nil {
                load((dataSource as! ReuseContainerDataSource).container(self, pageForIndexAt: index), withIndex: index)
            }
            
            if !visibleIndexs.contains(index),
                let inVisiblePage = page {
                enterReuseQueue(inVisiblePage, withIndex: index)
            }
        }
    }

    open func load(_ newPage: Page, withIndex index: Int) {
        addSubPage(newPage)
        visiblePages[index] = newPage
        parse(newPage).frame = frame(forPageAtIndex: index)
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
    
    open override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        dynamicPage()
    }
    
    /// Enter page to `reuseablePages`
    ///
    /// - Parameter page: Page instance
    private func enterReuseQueue(_ oldPage: Page, withIndex index: Int) {
        removeSubPage(oldPage)
        reuseablePages[oldPage.reuseIdentifier] = oldPage
        visiblePages[index] = nil
    }
}
