//
//  ViewPager.swift
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

import Foundation

public protocol ViewPagerDataSource: class {
    func numberOfPages() -> Int
}

public protocol ViewPagerDelegate: class {
    
    /// set frame for header
    ///
    /// - Parameter header: Header
    /// - Returns: frame for header
    func viewPager(_ viewPager: ViewPager, frameForHeadContainer container: Container) -> CGRect
    
    /// set frame for separator
    ///
    /// - Parameter separator: Separator
    /// - Returns: frame for separator
    func viewPager(_ viewPager: ViewPager, frameForSeparator separator: UIView) -> CGRect
    
    /// set frame for pager
    ///
    /// - Parameter pager: Pager
    /// - Returns: frame for pager
    func viewPager(_ viewPager: ViewPager, frameForPageContainer container: Container) -> CGRect
}

public extension ViewPagerDelegate {
    func viewPager(_ viewPager: ViewPager, frameForHeadContainer container: Container) -> CGRect { return .zero }
    func viewPager(_ viewPager: ViewPager, frameForSeparator separator: UIView) -> CGRect { return .zero }
    func viewPager(_ viewPager: ViewPager, frameForPageContainer container: Container) -> CGRect { return viewPager.frame }
}

/// Generatic PageView
open class ViewPager: UIView {
    
    /// header
    open var headContainer: Container = Container()
    
    /// PageContainer
    open var pageContainer: Container = Container()
    
    /// delegate for PageView, set style for PageView
    open weak var delegate: ViewPagerDelegate?
    
    /// dataSources for PageView
    open weak var dataSource: ViewPagerDataSource?
    
    /// Separator view between Header and Pager
    open let separatorView: UIView = UIView(frame: .zero)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(separatorView)
        addSubview(headContainer)
        addSubview(pageContainer)
    }
    
    open func reloaData() {
        headContainer.reloadData()
        pageContainer.reloadData()
    }
    
    open override func layoutSubviews() {
        
        if let frame = delegate?.viewPager(self, frameForHeadContainer: headContainer) { headContainer.frame = frame }
        if let frame = delegate?.viewPager(self, frameForSeparator: separatorView) { separatorView.frame = frame }
        if let frame = delegate?.viewPager(self, frameForPageContainer: pageContainer) { pageContainer.frame = frame }
        else { pageContainer.frame = CGRect(x: 0,
                                            y: headContainer.frame.height + separatorView.frame.height,
                                            width: frame.width,
                                            height: frame.height - headContainer.frame.height - separatorView.frame.height) }
        
        super.layoutSubviews()
        reloaData()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
