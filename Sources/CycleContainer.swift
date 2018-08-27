//
//  CycleContainer.swift
//
//  Copyright (c) 2017 Jack
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

open class CycleContainer: ReuseContainer {
    
    open override var contentSize: CGSize { return CGSize(width: scrollView.frame.width * CGFloat(numberOfPages) * 2,
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
