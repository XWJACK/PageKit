//
//  Pager.swift
//  PageKit
//
//  Created by Jack on 4/2/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit

/// PagerDataSources
@objc public protocol PagerDataSources {
    
    /// Asks for page size, only effective when `autoresizePage` is false
    ///
    /// - Parameters:
    ///   - page: Pager
    ///   - index: Index
    /// - Returns: Size for Page
    @objc optional func page(_ page: Pager, sizeForIndexAt index: Int) -> CGSize
    
    /// Asks for ViewController, only been invocated once, for each ViewController
    ///
    /// - Parameters:
    ///   - page: Pager
    ///   - index: Index
    /// - Returns: UIViewController
    func page(_ page: Pager, pageForIndexAt index: Int) -> UIViewController
    
    /// Tells the data source to return the number of pages and titles
    ///
    /// - returns: The number of pages and titles
    func numberOfPageViews() -> Int
}

/// Delegate to Pager, know scroll event
protocol PagerDelegate: class {
    
    /// page to next index, always right index
    ///
    /// - Parameter index: next index
    func page(to index: Int)
    
    /// Page will scroll from index to next index, with completed percent
    ///
    /// - Parameters:
    ///   - fromIndex: current index
    ///   - toIndex: next idnex, ⚠️: may be will pass invalid index
    ///   - percent: completed percent
    func pageWillSwitch(from fromIndex: Int, to nextIndex: Int, completed percent: CGFloat)
    
    /// Page did end scroll from index to next index, always right index.
    ///
    /// - Parameters:
    ///   - fromIndex: current index
    ///   - toIndex: next index
    func pageDidEndSwitch(from fromIndex: Int, to nextIndex: Int)
}

/// Normal PageView Pager
open class Pager: UIScrollView, UIScrollViewDelegate, HeaderDelegate {
    
    //MARK: - open property
    
    /// pager data source, you should not assignment this value directly. Instead assignment in `PageView` dataSources
    open internal(set) weak var dataSources: PagerDataSources?
    
    /// You should not assignment this value directly. Instead assignment in `PageView` defaultIndex
    /// to keep synchronize with `Header` defaultIndex.
    open internal(set) var defaultIndex: Int = 0
    
    /// You should not assignment this value directly. Instead assignment in `PageView` currentIndex
    /// to keep synchronize with `Header` currentIndex.
    open internal(set) var currentIndex: Int = 0
    
    /// Is auto set page size same as Pager
    ///
    /// Always Effective for UIViewController that did't loaded
    open var autoresizePage: Bool = true
    
    open override var frame: CGRect {
        didSet {
            setContentOffset(by: currentIndex, animated: false)
            
            for (index, controller) in pages.enumerated() where controller != nil { updatePage(controller!.view, at: index) }
        }
    }
    
    //MARK: - internal property
    
    /// pager delegate
    weak var pagerDelegate: PagerDelegate?
    
    //MARK: - private property
    
    /// All SubPages
    private var pages: [UIViewController?] = []
    
    /// Page will switch to next index
    private var nextIndex: Int = 0
    
    /// Is user interaction to scroll
    private var isuserInteraction: Bool = false
    
    //MARK: - public function
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        alwaysBounceHorizontal = true
        isPagingEnabled = true
        delegate = self
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        contentSize = CGSize(width: CGFloat(pages.count) * frame.width, height: frame.height)
        super.layoutSubviews()
    }
    
    /// is Valid index for page
    ///
    /// - Parameter index: Index
    /// - Returns: Bool
    final public func isValid(index: Int) -> Bool {
        return pages.count > index && index >= 0
    }
    
    //MARK: - internal function
    
    /// reload page
    final func reloadPages() {
        currentIndex = 0
        nextIndex = defaultIndex
        initPages(by: dataSources?.numberOfPageViews() ?? 0)
    }
    
    /// reload page by index
    ///
    /// - Parameter index: Index
    final func reloadPage(by index: Int) {
        guard isValid(index: index) else { assertionFailure("Invalid Index"); return }
        pages[index]?.view.removeFromSuperview()
        pages[index] = dataSources?.page(self, pageForIndexAt: index)
    }
    
    //MARK: - internal HeaderDelegate
    
    final func select(at index: Int) {
        nextIndex = index
        dynamicPages(nextIndex)
        setContentOffset(by: nextIndex, animated: true)
    }
    
    //MARK: - private function
    
    /// Init page by number
    ///
    /// - Parameter number: total of pages
    private func initPages(by number: Int) {
        pages.forEach{ $0?.view.removeFromSuperview() }
        pages = Array(repeating: nil, count: number)
    }
    
    /// Dynamic Create Page
    ///
    /// - parameter index: An index has been selected
    private func dynamicPages(_ index: Int) {
        guard isValid(index: index) &&
            pages[index] == nil else { return }
        
        guard let controller = dataSources?.page(self, pageForIndexAt: index) else { return }
        addSubview(controller.view)
        pages[index] = controller
        updatePage(controller.view, at: index)
    }
    
    /// Set SubView Size and origin
    ///
    /// - parameter view:  whitch view will been setted
    /// - parameter index: Index
    private func updatePage(_ view: UIView, at index: Int) {
        let dataSourcesSize = dataSources?.page?(self, sizeForIndexAt: index)
        let size: CGSize = autoresizePage ? frame.size : dataSourcesSize ?? .zero
        let origin: CGPoint = autoresizePage ?
            CGPoint(x: CGFloat(index) * frame.size.width, y: 0) :
            {
                guard let size = dataSourcesSize else { return .zero }
                return CGPoint(x: (frame.size.width - size.width) / 2 + CGFloat(index) * frame.size.width,
                               y: (frame.size.height - size.height) / 2)
            }()
        view.frame = CGRect(origin: origin, size: size)
    }
    
    /// Set Pager's ContentOffset
    ///
    /// - parameter index:    whitch index has been selected
    /// - parameter animated: Is animation for this select
    private func setContentOffset(by index: Int, animated: Bool) {
        var newFrame = frame
        newFrame.origin.x = frame.width * CGFloat(index)
        newFrame.origin.y = 0
        setContentOffset(newFrame.origin, animated: animated)
    }
    
    /// Scroll did end scroll
    /// now, currentIndex is nextIndex
    private func endScroll() {
        let oldCurrentIndex = currentIndex
        nextIndex = Int(contentOffset.x / frame.width)
        currentIndex = nextIndex
        
        guard isValid(index: oldCurrentIndex) else { return }
        pageDidEndSwitch(from: pages[oldCurrentIndex], fromIndex: oldCurrentIndex,
                         to: isValid(index: nextIndex) ? pages[nextIndex] : nil, nextIndex: nextIndex)
        pagerDelegate?.pageDidEndSwitch(from: oldCurrentIndex, to: nextIndex)
        
    }
    
    // MARK: - public final UIScrollViewDelegate
    
    final public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offSet = contentOffset.x / frame.width
        /// stepNextIndex is only use for user interaction
        var stepNextIndex = 0
        
        if CGFloat(currentIndex) > offSet {
            stepNextIndex = currentIndex - 1
        } else if CGFloat(currentIndex) < offSet {
            stepNextIndex = currentIndex + 1
        } else {
            stepNextIndex = currentIndex
        }
        
        nextIndex = isuserInteraction ? stepNextIndex : nextIndex
        guard nextIndex != currentIndex else { return }
        
        let percent = (contentOffset.x - (CGFloat(currentIndex) * frame.width)) / (CGFloat(nextIndex - currentIndex) * frame.width)
        //print("currentIndex: \(currentIndex) nextIndex: \(nextIndex) percent: \(percent)")
        /// load controller
        if pageWillLoadNextController(with: nextIndex, completed: percent) { dynamicPages(nextIndex) }
        guard isValid(index: currentIndex) else { return }
        pageWillSwitch(from: pages[currentIndex], fromIndex: currentIndex,
                       to: isValid(index: nextIndex) ? pages[nextIndex] : nil, nextIndex: nextIndex,
                       completed: percent > 0 ? percent : -percent)
        pagerDelegate?.pageWillSwitch(from: currentIndex, to: nextIndex, completed: percent > 0 ? percent : -percent)
    }
    
    /// only useful for user scroll by finger with start up: Begin scroll page
    final public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isuserInteraction = true
    }
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    final public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
    }
    /// only useful for user scroll by finger: Scroll page
    final public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isuserInteraction = false
        endScroll()
    }
    
    /// only useful for setContentOffset with animated is true: select title
    final public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        endScroll()
    }
    
    //MARK: - open custom override
    
    /// Page will scroll from index to next index, Default do nothing.
    ///
    /// - Parameters:
    ///   - fromController: current ViewController
    ///   - fromIndex: current Index
    ///   - toController: next ViewController
    ///   - toIndex: next index
    ///   - percent: completed percent, The value of this property is a floating-point number in the range 0.0 to 1.0
    open func pageWillSwitch(from fromController: UIViewController?, fromIndex: Int,
                             to nextController: UIViewController?, nextIndex: Int,
                             completed percent: CGFloat) {
        
    }
    
    /// Page did end scroll from index to next index, Default do nothing.
    ///
    /// - Parameters:
    ///   - fromController: current ViewController
    ///   - fromIndex: current index
    ///   - toController: next ViewController
    ///   - toIndex: next index
    open func pageDidEndSwitch(from fromController: UIViewController?, fromIndex: Int,
                               to nextController: UIViewController?, nextIndex: Int) {
        
    }
    
    /// Page Will load next ViewController with index, override this function to control when to load viewController.
    ///
    /// - Parameter index: next index
    /// - Returns: load ViewController if true or not load.
    open func pageWillLoadNextController(with index: Int, completed percent: CGFloat) -> Bool {
        return true
    }
}


