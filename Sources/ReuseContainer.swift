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
    
    //MARK: - Private property
    
    /// Aleardy registed pages
    private var registedPages: [String: Page.Type] = [:]
    /// Reusable pages
    private var reuseablePages: [String: Page] = [:]
    /// Visible pages
    private var visiblePages: [Page?] = []
    
    //MARK: - Open function
    
    /// Call this method to reload all the data that is used to construct the container.
    ///
    /// Same with using table view
    open override func reloadData() {
        super.reloadData()
        reuseablePages = [:]
        visiblePages.filter{ $0 != nil }.forEach{ removeSubPage($0!) }
        visiblePages = Array(repeating: nil, count: numberOfPages)
        visiblePages.reserveCapacity(numberOfPages)
        dynamicPage()
    }
    
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
        for (index, page) in visiblePages.enumerated() {
            
            if visibleIndexs.contains(index),
                page == nil {
                load((dataSource as! ReuseContainerDataSource).container(self, pageForIndexAt: index), withIndex: index)
            }
            
            if !visibleIndexs.contains(index),
                let inVisiblePage = page {
                remove(inVisiblePage, withIndex: index)
            }
        }
    }

    open override func load(_ newPage: Page, withIndex index: Int) {
        super.load(newPage, withIndex: index)
        visiblePages[index] = newPage
        reuseablePages[newPage.reuseIdentifier] = nil
    }
    
    /// Remove old page from container
    ///
    /// - Parameters:
    ///   - oldPage: Old page
    ///   - index: Index for old page
    open func remove(_ oldPage: Page, withIndex index: Int) {
        removeSubPage(oldPage)
        reuseablePages[oldPage.reuseIdentifier] = oldPage
        visiblePages[index] = nil
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
    
    //MARK: - UIScrollViewDelegate 
    
    open override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        dynamicPage()
    }
    
    //MARK: - Private functaion
}
