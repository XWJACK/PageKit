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
    
    /// Is user interaction to scroll
    public private(set) var isUserInteraction: Bool = false
    /// Is set content offset to adjust
    public private(set) var isSetContentOffset: Bool = false
    /// Default index for reloadPage
    open var defaultIndex: Int = 0
    /// Current index
    open var currentIndex: Int = .begin
    
    /// Page will switch to next index
    private var nextIndex: Int = .begin
    private var stepIndex: Int = 0
    
    /// All pages
    private var pages: [Page?] = []
    internal var totalPages: Int = 0
    //MARK: - public function
    
    public override init(frame: CGRect) {
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
    
    /// override this to clear page information if need
    open func clearPage() {
        pages = Array(repeating: nil, count: dataSource?.numberOfPages() ?? 0)
    }
    
    /// Override this to reload page by index
    ///
    /// - Parameter index: Index
    open func reloadPage(byIndex index: Int) {
        guard dataSource != nil, isValid(index: index) else { return }
        if pages[index] == nil { pages[index] = dynamicPage(byIndex: index) }
    }
    
    /// Override this function to custom contentSize if need
    ///
    /// - Returns: Size for content
    open func resetContentSize() -> CGSize {
        let number = dataSource?.numberOfPages() ?? 0
        return CGSize(width: frame.width * number.cgfloat,
                      height: frame.height)
    }
    
    /// Override this function to custom index position
    ///
    /// - Returns: Current index for Container
    open func getCurrentIndex(by contentOffsetX: CGFloat? = nil) -> Int {
        return Int((contentOffsetX ?? contentOffset.x) / frame.width)
    }
    
    /// Override this function to return page origin
    ///
    /// - Parameter index: Page index
    /// - Returns: Page origin
    open func getCurrentPageOrigin(by index: Int) -> CGPoint {
        return CGPoint(x: index.cgfloat * frame.width, y: 0)
    }
    
    //MARK: - open function
    
    /// Switch to index with animate
    ///
    /// - Parameters:
    ///   - index: Next index
    ///   - animated: Animate
    open func switching(toIndex index: Int, animated: Bool = true) {
        nextIndex = index
        setContentOffset(getCurrentPageOrigin(by: index), animated: animated)
    }
    
    /// Subclasses can override this method as needed to perform more precise layout of their pages
    ///
    /// - Parameters:
    ///   - page: Page
    ///   - index: Index
    open func layoutPages(_ page: Page, withIndex index: Int) {
        parse(page: page).frame = CGRect(origin: getCurrentPageOrigin(by: index), size: frame.size)
    }

    // MARK: - UIScrollViewDelegate
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetIndex = getCurrentIndex()

        stepIndex = getCurrentIndex()
        if isUserInteraction {
            if offSetIndex == currentIndex {//手势左滑
                containerWillSwitching(fromIndex: currentIndex, to: offSetIndex + 1, completed: 0)
            } else {//手势右滑
                containerWillSwitching(fromIndex: currentIndex, to: offSetIndex, completed: 0)
            }
        }
        
        if isSetContentOffset {//✅直接改变contentOffset
            containerWillSwitching(fromIndex: currentIndex, to: nextIndex, completed: 0)
        }
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
    
    //MARK: - open custom override
    
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
    
    //MARK: - internal function
    
    /// Dynamic Create Page
    ///
    /// - parameter index: An index has been selected
    internal func dynamicPage(byIndex index: Int) -> Page {
        let page = dataSource!.container(self, pageForIndexAt: index)
        add(page: page)
        layoutPages(page, withIndex: index)
        return page
    }
    
    /// Is valid index for pages
    ///
    /// - Parameter index: Index
    /// - Returns: index is valid
    internal final func isValid(index: Int) -> Bool {
        return index >= 0 && index < totalPages
    }
    
    //MARK: - public final function
    
    /// Reload all pages
    /// Reset currentIndex
    /// Reset nextIndex
    /// Reset contentSize
    /// Clear page
    public final func reloadPage() {
        totalPages = dataSource?.numberOfPages() ?? 0
        currentIndex = defaultIndex
        nextIndex = defaultIndex
        contentSize = resetContentSize()
        clearPage()
        reloadPage(byIndex: nextIndex)
        switching(toIndex: nextIndex, animated: false)
    }
    
    /// Suggest: using switching(toIndex: animated:) to replaced
    ///
    /// - Parameters:
    ///   - contentOffset: A point (expressed in points) that is offset from the content view’s origin.
    ///   - animated: true to animate the transition at a constant velocity to the new offset, false to make the transition immediate.
    public final override func setContentOffset(_ contentOffset: CGPoint, animated: Bool) {
        isSetContentOffset = true
        super.setContentOffset(contentOffset, animated: animated)
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
    
    //MARK: - function private
    
    /// Add page to Container
    ///
    /// - Parameter page: Page
    public final func add(page: Page) {
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
    public final func remove(page: Page) {
        switch page.pageType {
        case .view(let view):
            view.removeFromSuperview()
        case .viewController(let controller):
            addSubview(controller.view)
            controller.view.removeFromSuperview()
            controller.removeFromParentViewController()
        }
    }
    
    //MARK: - private function
    
    /// Scroll did end scroll
    private func endScroll() {
        let oldCurrentIndex = currentIndex
        let newCurrentIndex = getCurrentIndex()
        containerDidEndSwitching(from: oldCurrentIndex, to: newCurrentIndex)
    }
}


