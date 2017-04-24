//
//  Container.swift
//  PageKit
//
//  Created by Jack on 4/2/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit

/// Define page
public typealias Page = PageRepresentable

/// Data source for container
public protocol ContainerDataSource: class {
    
    /// Asks for page by given index
    ///
    /// - Parameters:
    ///   - container: Container instanse
    ///   - index: Index
    /// - Returns: Page
    func container(_ container: Container, pageForIndexAt index: Int) -> Page
    
    /// Asks for number of page
    ///
    /// - Returns: Number of page
    func numberOfPages() -> Int
}

/// Base Container
open class Container: UIScrollView, UIScrollViewDelegate {
    
    //MARK: - open property
    
    /// Data source for container
    open weak var dataSource: ContainerDataSource?
    
    /// Parent view controller
    open weak var parentViewController: UIViewController?
    
    /// Limit delegate is only by self
    open override weak var delegate: UIScrollViewDelegate? {
        get { return self }
        set { if newValue != nil && newValue!.isKind(of: Container.self) { super.delegate = newValue } }
    }
    
    open override var frame: CGRect {
        didSet {
            visiblePages.filter{ $0 != nil }.enumIndex{ index, page in layoutPages(page!, withIndex: index) }
        }
    }
    
    open var syncScrollBlock: ((Double, Double) -> ())?
    
    /// Default index for first load or reload page
    open var defaultIndex: Int = 0
    
    /// Current index
    /// 什么时候改变这个值有待考虑
    open internal(set) var currentIndex: Int = .begin
    
    /// Is user interaction to scroll
    open internal(set) var isUserInteraction: Bool = false
    
    /// Is set content offset to adjust
    open internal(set) var isSetContentOffset: Bool = false
    
    /// Page will switch to next index
    private var nextIndex: Int = .begin
    private var stepIndex: Int = 0
    
    /// Current visible pages, if `isReuseEnable` is true, this porperty means all pages is vaiible.
    internal var visiblePages: [Page?] = []
    
    /// Total pages number
    internal var numberOfPages: Int = 0
    
    
    //MARK: - public function
    
    public required override init(frame: CGRect) {
        super.init(frame: frame)
        
        delegate = self
        
        isPagingEnabled = true
        alwaysBounceHorizontal = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    open func reloadPage(byIndex index: Int) {
//        if isReuseEnable {
//            let page = dynamicPage(byIndex: index)
//            visiblePages[index] = page
//        }
//    }
    
    //MARK: - open function
    
    /// Override this function to custom clear if need
    open func clearPage() {
        visiblePages.filter{ $0 != nil }.forEach{ removeSubPage(page: $0!) }
        visiblePages = Array(repeating: nil, count: numberOfPages)
    }
    
    /// Override this function to custom contentSize if need
    ///
    /// - Returns: Size for content
    open func resetContentSize() -> CGSize {
        return CGSize(width: frame.width * numberOfPages.cgfloat, height: frame.height)
    }
    
    /// Override this function to custom page frame if need
    ///
    /// - Parameter index: Index
    /// - Returns: Frame for page
    open func pageFrame(byIndex index: Int) -> CGRect {
        return CGRect(x: frame.width * index.cgfloat,
                      y: 0,
                      width: frame.width,
                      height: frame.height)
    }
    
    /// Override this function to custom index position
    ///
    /// - Returns: Current index for Container
    open func getCurrentIndex(by contentOffsetX: CGFloat? = nil) -> Int {
        return Int((contentOffsetX ?? contentOffset.x) / frame.width)
    }
    
    /// Switch to index with animate
    ///
    /// - Parameters:
    ///   - index: Next index
    ///   - animated: Animate
    open func switching(toIndex index: Int, animated: Bool = true) {
        nextIndex = index
        setContentOffset(pageFrame(byIndex: index).origin, animated: animated)
        currentIndex = index
    }
    
    /// Subclasses can override this method as needed to perform more precise layout of their pages
    ///
    /// - Parameters:
    ///   - page: Page
    ///   - index: Index
    open func layoutPages(_ page: Page, withIndex index: Int) {
        parse(page: page).frame = CGRect(x: frame.width * index.cgfloat,
                                         y: 0,
                                         width: frame.width,
                                         height: frame.height)
    }

    // MARK: - UIScrollViewDelegate
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        dynamicPage()
        syncScrollBlock?(contentOffset.x.double, contentSize.width.double)
//        let offSetIndex = getCurrentIndex()
//
//        stepIndex = getCurrentIndex()
//        if isUserInteraction {
//            if offSetIndex == currentIndex {//手势左滑
//                containerWillSwitching(fromIndex: currentIndex, to: offSetIndex + 1, completed: 0)
//            } else {//手势右滑
//                containerWillSwitching(fromIndex: currentIndex, to: offSetIndex, completed: 0)
//            }
//        }
//        
//        if isSetContentOffset {//✅直接改变contentOffset
//            containerWillSwitching(fromIndex: currentIndex, to: nextIndex, completed: 0)
//        }
        
        
//        let offSet = contentOffset.x / frame.width
//        /// stepNextIndex is only use for user interaction
//        var stepNextIndex = 0
//        
//        if CGFloat(currentIndex) > offSet {
//            stepNextIndex = currentIndex - 1
//        } else if CGFloat(currentIndex) < offSet {
//            stepNextIndex = currentIndex + 1
//        } else {
//            stepNextIndex = currentIndex
//        }
//        
//        nextIndex = isuserInteraction ? stepNextIndex : nextIndex
//        guard nextIndex != currentIndex else { return }
//        
//        let percent = (contentOffset.x - (CGFloat(currentIndex) * frame.width)) / (CGFloat(nextIndex - currentIndex) * frame.width)
//        //print("currentIndex: \(currentIndex) nextIndex: \(nextIndex) percent: \(percent)")
//        /// load controller
//        if containerWillLoadNextPage(with: nextIndex, completed: percent) { dynamicPages(nextIndex) }
//        guard isValid(index: currentIndex) else { return }
//        containerWillSwitch(from: pages[currentIndex], fromIndex: currentIndex,
//                       to: isValid(index: nextIndex) ? pages[nextIndex] : nil, nextIndex: nextIndex,
//                       completed: percent > 0 ? percent : -percent)
//        pageContainerDelegate?.pageWillSwitch(from: currentIndex, to: nextIndex, completed: percent > 0 ? percent : -percent)
    }
    
//    open func scrollNextIndex() -> Int {
//        let index = Int(contentOffset.x / frame.width)
//        return index < 0 ? .begin : index >= (dataSource?.numberOfPages() ?? 0) - 1 ?
//    }
    
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isUserInteraction = true
        currentIndex = getCurrentIndex()
    }
    
    open func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                                withVelocity velocity: CGPoint,
                                                targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        isUserInteraction = false
        nextIndex = getCurrentIndex(by: targetContentOffset.pointee.x)
    }
    
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        isUserInteraction = false
    }
    
    open func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        endScroll()
    }
    
    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isSetContentOffset = false
        endScroll()
    }
    
    //MARK: - open function
    
    /// Page will scroll from index to next index, Default do nothing.
    ///
    /// - Parameters:
    ///   - fromIndex: current Index
    ///   - toIndex: next index
    ///   - percent: completed percent, The value of this property is a floating-point number in the range 0.0 to 1.0
    open func containerWillSwitching(fromIndex: Int,
                                     to nextIndex: Int,
                                     completed percent: Double) {
        print("\(fromIndex) -> \(nextIndex)")
    }
    
    /// Page did end scroll from index to next index, Default do nothing.
    ///
    /// ⚠️May be execused twice at some time.
    ///
    /// - Parameters:
    ///   - fromIndex: current index
    ///   - toIndex: next index
    open func containerDidEndSwitching(from fromIndex: Int,
                                       to nextIndex: Int) {
        
    }
    
    /// Page Will load next ViewController with index, override this function to control when to load viewController.
    ///
    /// - Parameter index: next index
    /// - Returns: load ViewController if true or not load.
//    open func containerWillLoadNextPage(with index: Int, completed percent: CGFloat) -> Bool {
//        return true
//    }
    
    /// Dynamic decide how to deal with pages
    ///
    /// - parameter index: An index has been selected
    open func dynamicPage() {
        let visibleIndexCollection = visiblePagesIndexCollection()
        
        for index in visibleIndexCollection where visiblePages[index] == nil && dataSource != nil {
            let newPage = dataSource!.container(self, pageForIndexAt: index)
            load(newPage, withIndex: index)
        }
    }
    
    /// Reload all pages
    /// Reset nextIndex
    /// Reset contentSize
    /// Clear page
    open func reloadPage() {
        numberOfPages = dataSource?.numberOfPages() ?? 0
        nextIndex = defaultIndex
        contentSize = resetContentSize()
        clearPage()
        dynamicPage()
        switching(toIndex: nextIndex, animated: false)
    }
    
    //MARK: - public final function
    
    /// Suggest: using switching(toIndex: animated:) to replaced
    ///
    /// - Parameters:
    ///   - contentOffset: A point (expressed in points) that is offset from the content view’s origin.
    ///   - animated: true to animate the transition at a constant velocity to the new offset, false to make the transition immediate.
    public final override func setContentOffset(_ contentOffset: CGPoint, animated: Bool) {
        isSetContentOffset = true
        super.setContentOffset(contentOffset, animated: animated)
    }
    
    /// Is valid index for pages
    ///
    /// - Parameter index: Index
    /// - Returns: index is valid
    public final func isValid(index: Int) -> Bool {
        return index >= 0 && index < numberOfPages
    }
    
    /// Calculate how manay pages are visible
    ///
    /// - Returns: Visible index collection
    public final func visiblePagesIndexCollection() -> [Int] {
        var indexCollection: [Int] = []
        for index in 0..<numberOfPages where checkPageVisible(byIndex: index) {
            indexCollection.append(index)
        }
        return indexCollection
    }
    
    /// Check page is visible by index
    ///
    /// - Parameter index: Index
    /// - Returns: Is index page is visible
    public final func checkPageVisible(byIndex index: Int) -> Bool {
        return CGRect(x: contentOffset.x,
                      y: contentOffset.y,
                      width: frame.width,
                      height: frame.height).intersects(pageFrame(byIndex: index))
    }
    
    /// Parse page to UIView
    ///
    /// - Parameter page: Page
    /// - Returns: UIView
    public final func parse(page: Page) -> UIView {
        switch page.pageType {
        case .view(let view): return view
        case .viewController(let controller): return controller.view
        }
    }
    
    /// Add page to Container
    ///
    /// - Parameter page: Page
    public final func addSubPage(page: Page) {
        switch page.pageType {
        case .view(let view):
            addSubview(view)
        case .viewController(let controller):
            addSubview(controller.view)
            parentViewController?.addChildViewController(controller)
        }
    }
    
    /// Remove page from Container
    ///
    /// - Parameter page: Page
    public final func removeSubPage(page: Page) {
        switch page.pageType {
        case .view(let view):
            view.removeFromSuperview()
        case .viewController(let controller):
            controller.view.removeFromSuperview()
            controller.removeFromParentViewController()
        }
    }
    
    public final func pageForIndex(at index: Int) -> Page? {
        guard isValid(index: index) else { return nil }
        return visiblePages[index]
    }
    
    //MARK: - internal function
    
    /// Add new page to container
    ///
    /// - Parameters:
    ///   - newPage: New Page
    ///   - index: Index
    internal func load(_ newPage: Page, withIndex index: Int)  {
        addSubPage(page: newPage)
        visiblePages[index] = newPage
        layoutPages(newPage, withIndex: index)
    }
    
    //MARK: - private function
    
    /// Scroll did end scroll
    private func endScroll() {
//        let oldCurrentIndex = currentIndex
//        let newCurrentIndex = getCurrentIndex()
//        containerDidEndSwitching(from: oldCurrentIndex, to: newCurrentIndex)
    }
}
