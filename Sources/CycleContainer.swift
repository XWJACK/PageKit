//
//  CycleContainer.swift
//  PageKit
//
//  Created by Jack on 6/8/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit

open class CycleContainer: Container {
    
    private var pages: [Page?] = []
    private var realIndex: Int = 0
    
    open override func reloadData() {
        super.reloadData()
        
        pages.filter{ $0 != nil }.forEach{ removeSubPage($0!) }
        pages = Array(repeating: nil, count: numberOfPages)
        pages.reserveCapacity(numberOfPages)
        for index in [numberOfPages - 1, 0, 1] {
            pages[index] = page(forIndexAt: index)
        }
        
        switching(toIndex: 1, animated: false)
    }
    
    open override func reloadNumberOfPages() -> Int {
        return 3
    }
    
    open override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = super.index(withOffset: scrollView.contentOffset.x)
        if index == 0 {
            if realIndex == 0 { realIndex = numberOfPages - 1 }
            else { realIndex -= 1 }
        } else if index == 2 { realIndex = (realIndex + 1) % numberOfPages }
        switching(toIndex: 1, animated: false)
    }
}
