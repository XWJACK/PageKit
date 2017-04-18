//
//  ReuseContainer.swift
//  PageKit
//
//  Created by Jack on 4/8/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit

/// Represent container can reusable
open class ReuseContainer: Container {
    
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
    
//    open override func switching(toIndex index: Int, animated: Bool) {
//        dynamicPage(byIndex: index)
//        super.switching(toIndex: index, animated: animated)
//    }
    
//    private func dynamicPage(byIndex index: Int) {
//        let pagesToLoad = [index, index - 1, index + 1]
//        for radyIndex in pagesToLoad where radyIndex >= 0 && radyIndex < (dataSource?.numberOfPages() ?? 0) {
//            if let page = (dataSource as? ReuseContainerDataSource)?.container(self, pageForIndexAt: radyIndex) {
//                add(page: page)
//            }
//        }
//    }
    
    /// Dequeue page with identifier
    ///
    /// - Parameter identifier: Page.reuse
    /// - Returns: Page with identifier, nil if not register page
    public final func dequeueReusablePage(withIdentifier identifier: String) -> Page? {
        return reuseablePages[identifier] ?? registedPages[identifier]?.init()
    }
    
    open override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
    }
}
