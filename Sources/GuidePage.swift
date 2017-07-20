//
//  GuidePage.swift
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

public protocol GuidePageDatasource: class {
    func numberOfPages() -> Int
    func guidePage(_ guidePage: GuidePage, pageForIndexAt index: Int) -> Page
}

/// Guide page with system page control.
open class GuidePage: ReuseContainer {
    
    open weak var dataSource: GuidePageDatasource? = nil
    
    open let pageControl = UIPageControl()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(pageControl)
    }
    
    open override func reloadNumberOfPages() -> Int {
        let number = dataSource?.numberOfPages() ?? 0
        pageControl.numberOfPages = number
        return number
    }
    
    open override func page(forIndexAt index: Int) -> Page? {
        return dataSource?.guidePage(self, pageForIndexAt: index)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        pageControl.sizeToFit()
        pageControl.frame.origin = CGPoint(x: (frame.size.width - pageControl.frame.size.width) / 2,
                                           y: frame.size.height - pageControl.frame.size.height)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = index(withOffset: scrollView.contentOffset.x)
    }
}
