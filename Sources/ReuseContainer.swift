//
//  ReuseContainer.swift
//  PageKit
//
//  Created by Jack on 4/8/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import Foundation

class ReuseContainer: Container {
    internal var registedPages: [String: Page.Type] = [:]
    internal var reuseablePages: [String: Page] = [:]
    internal var visiblePages: [String: Page] = [:]
    
    public final func register(_ pageClass: Page.Type, forPageReuseIndentifier identifier: String) {
        registedPages[identifier] = pageClass
    }
    
    private func enqueue(withIdentifier indentifier: String, page: Page) {
        reuseablePages[indentifier] = page
    }
    
    public final func dequeueReusablePage(withIdentifier identifier: String) -> Page? {
        return reuseablePages[identifier] ?? registedPages[identifier]?.init()
    }
}
