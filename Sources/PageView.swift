//
//  PageView.swift
//  PageKit
//
//  Created by Jack on 4/2/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit

/// PageViewDataSources
@objc public protocol PageViewDataSources: HeaderDataSources, PagerDataSources {}

/// PageViewDelegate
@objc public protocol PageViewDelegate: class {
    
    /// set frame for header
    ///
    /// - Parameter header: Header
    /// - Returns: frame for header
    func PageView(frameForHeader header: Header) -> CGRect
    
    /// set frame for separator
    ///
    /// - Parameter separator: Separator
    /// - Returns: frame for separator
    @objc optional func PageView(frameForSeparator separator: UIView) -> CGRect
    
    /// set frame for pager
    ///
    /// - Parameter pager: Pager
    /// - Returns: frame for pager
    @objc optional func PageView(frameForPager pager: Pager) -> CGRect
}

/// Generatic PageView
open class PageView<HeaderType: Header, PagerType: Pager>: UIView {
    
    /// header
    open let header: HeaderType = HeaderType()
    
    /// pager
    open let pager: PagerType = PagerType()
    
    /// delegate for PageView, set style for PageView
    open weak var delegate: PageViewDelegate?
    
    /// dataSources for PageView
    open weak var dataSources: PageViewDataSources? {
        didSet {
            header.dataSources = dataSources
            pager.dataSources = dataSources
        }
    }
    
    open var defaultIndex: Int = 0 {
        didSet {
            header.defaultIndex = defaultIndex
            pager.defaultIndex = defaultIndex
        }
    }
    
    /// Separator view between Header and Pager
    open let separatorView: UIView = UIView(frame: .zero)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        header.headerDelegate = pager
        pager.pagerDelegate = header
        
        addSubview(header)
        addSubview(pager)
        addSubview(separatorView)
    }
    
    open func reloadPageView() {
        layoutIfNeeded()
        pager.reloadPages()
        header.reloadTitles()
    }
    
    /// Reload PageView by index
    ///
    /// - Parameter index: index
    open func reloadPageView(by index: Int) {
        layoutIfNeeded()
        pager.reloadPage(by: index)
        header.reloadTitle(by: index)
    }
    
    open override func layoutSubviews() {
        
        if let frame = delegate?.PageView(frameForHeader: header) { header.frame = frame }
        if let frame = delegate?.PageView?(frameForSeparator: separatorView) { separatorView.frame = frame }
        if let frame = delegate?.PageView?(frameForPager: pager) { pager.frame = frame }
        else { pager.frame = CGRect(x: 0,
                                    y: header.frame.height + separatorView.frame.height,
                                    width: frame.width,
                                    height: frame.height - header.frame.height - separatorView.frame.height) }
        
        super.layoutSubviews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
