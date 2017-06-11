//
//  ReuseContainer.swift
//  PageKit
//
//  Created by Jack on 4/24/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit

/// Container with reuseable
open class ReuseContainer: Container {
    
    //MARK: - Private property
    
    /// Aleardy registed pages
    private var registedPages: [String: Page.Type] = [:]
    /// Reusable pages
    private var reuseablePages: [String: Page] = [:]
    /// Visible pages
    private var visiblePages: [Page?] = []
    
    //MARK: - Custom function
    
    /// Dynamic load or remove pages
    open func dynamicPage() {
        let visibleIndexs = visiblePagesIndexs()
        ///*********************************************************************
        ///                     (page is visible)
        ///             true                         false
        ///         (page == nil)                (page == nil)
        ///    true              false       true              false
        /// (new page)             (do nothing)            (remove old page)
        ///*********************************************************************
        for (index, oldPage) in visiblePages.enumerated() {
            
            if visibleIndexs.contains(index),
                oldPage == nil,
                let newPage = page(forIndexAt: index) {
                add(newPage: newPage, withIndex: index)
            }
            
            if !visibleIndexs.contains(index),
                let inVisiblePage = oldPage {
                remove(oldPage: inVisiblePage, withIndex: index)
            }
        }
    }
    
    //MARK: - Public final function
    
    /// Registers a class for use in creating new container page.
    ///
    /// Same with using table view, the only different is you can let identifier set with auto, not must.
    ///
    /// - Parameters:
    ///   - pageClass: The class of a page that you want to use in the container.
    ///   - identifier: The reuse identifier for the page. This parameter default is class name if not be set. This parameter can be set by youself, but it must not be an empty string.
    public final func register(_ pageClass: Page.Type, forPageReuseIdentifier identifier: String? = nil) {
        registedPages[identifier ?? pageClass.reuseIdentifier] = pageClass
    }
    
    /// Returns a reusable container page object for the specified reuse identifier and adds it to the container. 
    ///
    /// Same with using tableView.
    ///
    /// - Parameter identifier: Page.reuse
    /// - Returns: Page with identifier, nil if not register page
    public final func dequeueReusablePage(withIdentifier identifier: String) -> Page {
        return reuseablePages[identifier] ?? registedPages[identifier]!.init()
    }
    
    //MARK: - Override function
    
    /// Call this method to reload all the data that is used to construct the container.
    ///
    /// Same with using table view
    open override func reloadData() {
        super.reloadData()
        dynamicPage()
    }
    
    /// Reset container
    open override func resetContainer() {
        reuseablePages = [:]
        visiblePages.filter{ $0 != nil }.forEach{ removeSubPage($0!) }
        visiblePages = Array(repeating: nil, count: numberOfPages)
        visiblePages.reserveCapacity(numberOfPages)
    }
    
    /// Add new page to container
    ///
    /// - Parameters:
    ///   - page: New Page
    ///   - index: Index
    open override func add(newPage page: Page, withIndex index: Int) {
        super.add(newPage: page, withIndex: index)
        visiblePages[index] = page
        reuseablePages[page.reuseIdentifier] = nil
    }
    
    /// Remove old page from container
    ///
    /// - Parameters:
    ///   - page: Old page
    ///   - index: Index for old page
    open override func remove(oldPage page: Page, withIndex index: Int) {
        super.remove(oldPage: page, withIndex: index)
        reuseablePages[page.reuseIdentifier] = page
        visiblePages[index] = nil
    }
    
    //MARK: - UIScrollViewDelegate 
    
    open override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        dynamicPage()
    }
}
