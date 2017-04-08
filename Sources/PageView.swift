//
//  PageView.swift
//  PageKit
//
//  Created by Jack on 4/2/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit

/// PageViewDataSources
public protocol PageViewDataSources: TitleContainerDataSources, PagerDataSources {}

/// PageViewDelegate
@objc public protocol PageViewDelegate: class {
    
    /// set frame for header
    ///
    /// - Parameter header: Header
    /// - Returns: frame for header
    func pageView(frameForHeader header: TitleContainer) -> CGRect
    
    /// set frame for separator
    ///
    /// - Parameter separator: Separator
    /// - Returns: frame for separator
    @objc optional func pageView(frameForSeparator separator: UIView) -> CGRect
    
    /// set frame for pager
    ///
    /// - Parameter pager: Pager
    /// - Returns: frame for pager
    @objc optional func pageView(frameForPageContainer pager: PageContainer) -> CGRect
}

/// Generatic PageView
open class PageView<TitleContainerType: TitleContainer, PageContainerType: PageContainer>: UIView {
    
    /// header
    open let header: TitleContainerType = TitleContainerType()
    
    /// PageContainer
    open let pageContainer: PageContainerType = PageContainerType()
    
    /// delegate for PageView, set style for PageView
    open weak var delegate: PageViewDelegate?
    
    /// dataSources for PageView
    open weak var dataSources: PageViewDataSources? {
        didSet {
            header.dataSources = dataSources
            pageContainer.dataSources = dataSources
        }
    }
    
    open var defaultIndex: Int = 0 {
        didSet {
            header.defaultIndex = defaultIndex
            pageContainer.defaultIndex = defaultIndex
        }
    }
    
    /// Separator view between Header and Pager
    open let separatorView: UIView = UIView(frame: .zero)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        header.headerDelegate = pageContainer
        pageContainer.pageContainerDelegate = header
        
        addSubview(header)
        addSubview(pageContainer)
        addSubview(separatorView)
    }
    
    open func reloadPageView() {
        layoutIfNeeded()
        pageContainer.reloadPages()
        header.reloadTitles()
    }
    
    /// Reload PageView by index
    ///
    /// - Parameter index: index
    open func reloadPageView(by index: Int) {
        layoutIfNeeded()
        pageContainer.reloadPage(by: index)
        header.reloadTitle(by: index)
    }
    
    open override func layoutSubviews() {
        
        if let frame = delegate?.pageView(frameForHeader: header) { header.frame = frame }
        if let frame = delegate?.pageView?(frameForSeparator: separatorView) { separatorView.frame = frame }
        if let frame = delegate?.pageView?(frameForPageContainer: pageContainer) { pageContainer.frame = frame }
        else { pageContainer.frame = CGRect(x: 0,
                                            y: header.frame.height + separatorView.frame.height,
                                            width: frame.width,
                                            height: frame.height - header.frame.height - separatorView.frame.height) }
        
        super.layoutSubviews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
