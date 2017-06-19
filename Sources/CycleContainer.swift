//
//  CycleContainer.swift
//  PageKit
//
//  Created by Jack on 6/8/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit

open class CycleContainer: ReuseContainer {
    
    open override var contentSize: CGSize { return CGSize(width: scrollView.frame.width * numberOfPages.cgfloat * 2,
                                                          height: scrollView.frame.height) }
    private var realIndex: Int = 0
    
    open override func reloadData() {
        super.reloadData()
    }
    
    open override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
//        scrollView.setContentOffset(<#T##contentOffset: CGPoint##CGPoint#>, animated: false)
        switching(toIndex: 1, animated: false)
    }
//    open override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let index = super.index(withOffset: scrollView.contentOffset.x)
//        if index == 0 {
//            if realIndex == 0 { realIndex = numberOfPages - 1 }
//            else { realIndex -= 1 }
//        } else if index == 2 { realIndex = (realIndex + 1) % numberOfPages }
//        switching(toIndex: 1, animated: false)
//    }
}
