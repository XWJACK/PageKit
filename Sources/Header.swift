//
//  Header.swift
//  PageKit
//
//  Created by Jack on 4/2/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit

/// HeaderDataSources
@objc public protocol HeaderDataSources {
    
    /// Asks for title
    ///
    /// - Parameters:
    ///   - header: Header
    ///   - index: Index
    /// - Returns: UIControl like UIButton
    func header(_ header: Header, titleForIndexAt index: Int) -> UIControl
    
    /// Asks for title size, it will invocate sizeToFit for each title if not implement this.
    ///
    /// - Parameters:
    ///   - header: Header
    ///   - title: UIControl
    ///   - index: Index
    /// - Returns: Size for title
    @objc optional func header(_ header: Header, with title: UIControl, sizeForIndexAt index: Int) -> CGSize
    
    /// Asks for indicator size
    ///
    /// - Parameters:
    ///   - header: Header
    ///   - indicator: Indicator instanse
    /// - Returns: Size for indicator
    @objc optional func header(_ header: Header, sizeForIndicator indicator: UIView, underTitle: UIControl, with index: Int) -> CGSize
    
    /// Tells the data source to return the number of pages and titles
    ///
    /// - returns: The number of pages and titles
    func numberOfPageViews() -> Int
}

/// Delegate to Header, know whitch index has been selected
protocol HeaderDelegate: class {
    /// New index has been selected
    ///
    /// - parameter index: New Index
    func select(at index: Int)
}

/// Normal PageView Header
open class Header: UIScrollView, UIScrollViewDelegate, PagerDelegate {
    
    //MARK: - open property
    
    final public override var delegate: UIScrollViewDelegate? {
        get { return self }
        set { if newValue === self { super.delegate = newValue }}
    }
    
    /// header data source, you should not assignment this value directly. Instead assignment in `PageView` dataSources
    open internal(set) weak var dataSources: HeaderDataSources?
    
    /// You should not assignment this value directly. Instead assignment in `PageView` defaultIndex
    /// to keep synchronize with `Header` defaultIndex.
    open internal(set) var defaultIndex: Int = 0
    
    /// You should not assignment this value directly. Instead assignment in `PageView` currentIndex
    /// to keep synchronize with `Header` currentIndex.
    open internal(set) var currentIndex: Int = 0
    
    /// Indicator View
    open var indicator = UIView()
    
    /// Default Tag, reset when its conflict, set before `addSubview`, or it will never effective
    ///
    /// Range from `defaultTag` to `defaultTag + dataSource.numberOfPageViews()`
    ///
    /// Default is 111
    open var defaultTag: Int = 111
    
    //MARK: - internal property
    
    /// header delegate
    weak var headerDelegate: HeaderDelegate?
    
    //MARK: - private property
    
    /// All titles
    private var titles: [UIControl] = []
    
    //MARK: - public function
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        alwaysBounceVertical = false
        alwaysBounceHorizontal = true
        
        indicator.backgroundColor = .white
        addSubview(indicator)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// is Valid index for title
    ///
    /// - Parameter index: Index
    /// - Returns: Bool
    final public func isValid(index: Int) -> Bool {
        return titles.count > index && index >= 0
    }
    
    final public func offSet(by index: Int) -> CGFloat {
        return isValid(index: index) ? titles.filter{ $0.tag < defaultTag + index }.reduce(CGFloat(0), {total, title in total + title.frame.width }) :
            index == titles.count ? titles.reduce(CGFloat(0), {total, title in total + title.frame.width }) : 0
    }
    
    //MARK: - internal function
    
    /// reload titles
    final func reloadTitles() {
        currentIndex = 0
        initTitles()
        contentSize.width = 0
        
        guard let dataSources = dataSources else { return }
        let number = dataSources.numberOfPageViews()
        guard number > 0 else { return }
        var totalWidth: CGFloat = 0
        for index in 0..<number {
            
            let title = dataSources.header(self, titleForIndexAt: index)
            addSubview(title)
            
            title.tag = defaultTag + index
            title.addTarget(self, action: #selector(select(sender:)), for: .touchUpInside)
            
            let titleSize = dataSources.header?(self, with: title, sizeForIndexAt: index) ?? { title.sizeToFit(); return title.frame.size }()
            title.frame = CGRect(origin: CGPoint(x: titles.reduce(0, { total, title in total + title.frame.width }),
                                                 y: 0),
                                 size: titleSize)
            titles.append(title)
            totalWidth += titleSize.width
        }
        contentSize.width = totalWidth
        headerDelegate?.select(at: defaultIndex)
        pageWillSwitch(from: currentIndex, to: defaultIndex, completed: 1)
        pageDidEndSwitch(from: currentIndex, to: defaultIndex)
    }
    
    /// reload title by index
    ///
    /// - Parameter index: Index
    final func reloadTitle(by index: Int) {
        guard isValid(index: index) else { assertionFailure("Invalid Index"); return }
        guard let title = dataSources?.header(self, titleForIndexAt: index) else { return }
        titles[index].removeFromSuperview()
        titles[index] = title
    }
    
    //MARK: - private function
    
    /// Init titles
    private func initTitles() {
        titles.forEach{ $0.removeFromSuperview() }
        titles = []
    }
    
    /// Action for UIControl
    ///
    /// - Parameter sender: UIControl
    @objc private func select(sender: UIControl) {
        headerDelegate?.select(at: sender.tag - defaultTag)
    }
    
    //MARK: - internal PagerDelegate
    
    final func pageWillSwitch(from fromIndex: Int, to nextIndex: Int, completed percent: CGFloat) {
        guard isValid(index: fromIndex) else { return }
        pageWillSwitch(from: titles[fromIndex], fromIndex: fromIndex,
                       to: isValid(index: nextIndex) ? titles[nextIndex] : nil, nextIndex: nextIndex,
                       completed: percent)
    }
    
    final func page(to index: Int) {
        currentIndex = index
    }
    
    final func pageDidEndSwitch(from fromIndex: Int, to nextIndex: Int) {
        guard isValid(index: fromIndex) && isValid(index: nextIndex) else { return }
        pageDidEndSwitch(from: titles[fromIndex], fromIndex: fromIndex,
                         to: titles[nextIndex], nextIndex: nextIndex)
    }
    
    //MARK: - Custom Override
    
    /// Page did end switch from index to next index, default is only modify title's isSelected, override to custom.
    ///
    /// - Parameters:
    ///   - fromTitle: current title
    ///   - fromIndex: current index
    ///   - nextTitle: next title, nil if not
    ///   - nextIndex: next index
    open func pageDidEndSwitch(from fromTitle: UIControl, fromIndex: Int,
                               to nextTitle: UIControl, nextIndex: Int) {
        fromTitle.isSelected = false
        nextTitle.isSelected = true
    }
    
    /// Page will switch from index to next index with percent, Default do nothing
    ///
    /// - Parameters:
    ///   - fromTitle: current title
    ///   - fromIndex: current index
    ///   - nextTitle: next title, nil if not
    ///   - nextIndex: next index
    ///   - percent: completed percent, The value of this property is a floating-point number in the range 0.0 to 1.0
    open func pageWillSwitch(from fromTitle: UIControl, fromIndex: Int,
                             to nextTitle: UIControl?, nextIndex: Int,
                             completed percent: CGFloat) {
        
    }
}

