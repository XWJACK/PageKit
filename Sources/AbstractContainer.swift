//
//  AbstractContainer.swift
//  PageKit
//
//  Created by Jack on 4/24/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit

open class AbstractContainer: NSObject, UIScrollViewDelegate {
    
    open private(set) var currentIndex: Int = .begin
    
    internal var nextIndex: Int = .begin
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        containerDidStop()
    }
    
    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        containerDidStop()
    }
    
    open func containerDidStop() {
        let oldCurrentIndex = currentIndex
        currentIndex = nextIndex
        containerDidEndSwitching(fromIndex: oldCurrentIndex, to: nextIndex)
    }
    
    open func containerWillSwitching(fromIndex: Int,
                                     to nextIndex: Int,
                                     completed percent: Double) {
    }
    
    open func containerDidEndSwitching(fromIndex: Int,
                                       to nextIndex: Int) {
        
    }
}
