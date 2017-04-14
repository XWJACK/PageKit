//
//  TitleContainer.swift
//  PageKit
//
//  Created by Jack on 4/2/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit
/*
/// HeaderDataSources
public protocol TitleContainerDataSources: ContainerDataSource {
    
    /// Asks for indicator size
    ///
    /// - Parameters:
    ///   - header: Header
    ///   - indicator: Indicator instanse
    /// - Returns: Size for indicator
    func title(_ titleContainer: TitleContainer,
               sizeForIndicator indicator: UIView,
               underTitle title: Page,
               withIndex index: Int) -> CGSize
}

extension TitleContainerDataSources {
    func title(_ titleContainer: TitleContainer,
               sizeForIndicator indicator: UIView,
               underTitle title: Page,
               withIndex index: Int) -> CGSize {
        switch title.liveViewType {
        case .view(let view): return view.frame.size
        case .viewController(let controller): return controller.view.frame.size
        }
    }
}
/// Delegate to Header, know whitch index has been selected
protocol TitleContainerDelegate: class {
    /// New index has been selected
    ///
    /// - parameter index: New Index
    func scroll(to index: Int, animated: Bool)
}

open class TitleContainer: Container {
    
    //MARK: - open property
    
    /// header data source, you should not assignment this value directly. Instead assignment in `PageView` dataSources
    open internal(set) weak var dataSources: TitleContainerDataSources?
    
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
    weak var headerDelegate: TitleContainerDelegate?
    
    //MARK: - private property
    
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
    
    public final func offSet(by index: Int) -> CGFloat {
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
        let number = dataSources.numberOfPages()
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
        headerDelegate?.scroll(to: defaultIndex, animated: true)
        pageWillSwitch(from: currentIndex, to: defaultIndex, completed: 1)
        pageDidEndSwitch(from: currentIndex, to: defaultIndex)
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
        headerDelegate?.scroll(to: sender.tag - defaultTag, animated: true)
    }
    
    //MARK: - internal PagerDelegate
    
    final public func pageWillSwitch(from fromIndex: Int, to nextIndex: Int, completed percent: CGFloat) {
        guard isValid(index: fromIndex) else { return }
        pageWillSwitch(from: titles[fromIndex], fromIndex: fromIndex,
                       to: isValid(index: nextIndex) ? titles[nextIndex] : nil, nextIndex: nextIndex,
                       completed: percent)
    }
    
    final public func page(to index: Int) {
        currentIndex = index
    }
    
    final public func pageDidEndSwitch(from fromIndex: Int, to nextIndex: Int) {
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
        
        /// 默认滚动到中间
        let offset = offSet(by: nextIndex) + nextTitle.frame.width / 2 - frame.width / 2
        guard offset > 0 && offset < contentSize.width - frame.width else { return }
        setContentOffset(CGPoint(x: offset, y: 0), animated: true)
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

*/
