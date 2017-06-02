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

/// Base Container DataSource
public protocol ContainerDataSource: class {
    
    /// Asks for number of page
    ///
    /// - Returns: Number of page
    func numberOfPages() -> Int
}

/// Base Container
open class Container: UIView, UIScrollViewDelegate {
    
    //MARK: - open property

    /// Data source for container
    open weak var dataSource: ContainerDataSource?
    
    /// Parent view controller
    open weak var parentViewController: UIViewController?
    
    /// ContentInset for container
    open var contentInset: UIEdgeInsets = .zero
    
    /// ContentSize for container
    open var contentSize: CGSize { return CGSize(width: scrollView.frame.width * numberOfPages.cgfloat,
                                                 height: scrollView.frame.height) }
    
    /// ScrollView
    public let scrollView: UIScrollView
    
    /// Default index for first load or reload page
//    open var defaultIndex: Int = 0
    
    /// Current index
//    open internal(set) var currentIndex: Int = .begin
    
    /// Page will switch to next index
//    private var nextIndex: Int = .begin
//    private var stepIndex: Int = 0
    
    /// Total pages number
    open private(set) var numberOfPages: Int = 0
    
    //MARK: - public function
    
    public override init(frame: CGRect) {
        scrollView = UIScrollView(frame: frame)
        super.init(frame: frame)
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        addSubview(scrollView)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        scrollView.frame = frame.resetBy(contentInset)
        super.layoutSubviews()
        reloadData()
    }
    
    /// Call this method to reload all the data that is used to construct the container.
    ///
    /// Same with using table view
    open func reloadData() {
        numberOfPages = dataSource?.numberOfPages() ?? 0
        scrollView.contentSize = contentSize
        //        nextIndex = defaultIndex
        //        switching(toIndex: nextIndex, animated: false)
    }
    
    //MARK: - open function
    
    /// Switch to index with animate
    ///
    /// - Parameters:
    ///   - index: Next index
    ///   - animated: Animate
//    open func switching(toIndex index: Int, animated: Bool = true) {
//        nextIndex = index
//        setContentOffset(pageFrame(byIndex: index).origin, animated: animated)
//        currentIndex = index
//    }
    
    
    // MARK: - UIScrollViewDelegate
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        outPut("scrollViewDidScroll")
//        dynamicPage()
//        syncScrollBlock?(contentOffset.x.double, contentSize.width.double)
        
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
        
//        let offSetIndex = getCurrentIndex(by: contentOffset.x)

//        /// stepNextIndex is only use for user interaction
//        var stepNextIndex = 0
//        
//        if currentIndex > offSet {
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
//        outPut("scrollViewWillBeginDragging")
//        currentIndex = getCurrentIndex(by: contentOffset.x)
    }
    
    open func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                                withVelocity velocity: CGPoint,
                                                targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        outPut("scrollViewWillEndDragging")
//        nextIndex = getCurrentIndex(by: targetContentOffset.pointee.x)
    }
    
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        outPut("scrollViewDidEndDragging")
    }
    
    open func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
//        outPut("scrollViewWillBeginDecelerating")
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        outPut("scrollViewDidEndDecelerating")
        
//        endScroll()
    }
    
    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        outPut("scrollViewDidEndScrollingAnimation")
//        isSetContentOffset = false
//        endScroll()
    }
//    func outPut(_ functionName: String) {
//        print(functionName + " isTracking: " + isTracking.description + " isDragging: " + isDragging.description + " isDecelerating: " + isDecelerating.description)
//    }
    //MARK: - open function
    
    /// Page will scroll from index to next index, Default do nothing.
    ///
    /// - Parameters:
    ///   - fromIndex: current Index
    ///   - toIndex: next index
    ///   - percent: completed percent, The value of this property is a floating-point number in the range 0.0 to 1.0
//    open func containerWillSwitching(fromIndex: Int,
//                                     to nextIndex: Int,
//                                     completed percent: Double) {
//        print("\(fromIndex) -> \(nextIndex)")
//    }
    
    /// Page did end scroll from index to next index, Default do nothing.
    ///
    /// ⚠️May be execused twice at some time.
    ///
    /// - Parameters:
    ///   - fromIndex: current index
    ///   - toIndex: next index
//    open func containerDidEndSwitching(from fromIndex: Int,
//                                       to nextIndex: Int) {
//        
//    }
    
    /// Page Will load next ViewController with index, override this function to control when to load viewController.
    ///
    /// - Parameter index: next index
    /// - Returns: load ViewController if true or not load.
//    open func containerWillLoadNextPage(with index: Int, completed percent: CGFloat) -> Bool {
//        return true
//    }
    
    
    //MARK: - public final function
    
    /// Is valid index for pages
    ///
    /// - Parameter index: Index
    /// - Returns: index is valid
//    public final func isValid(index: Int) -> Bool {
//        return index >= 0 && index < numberOfPages
//    }
    
    
    
    
    
    
    
    /// Override this function to custom index by offSet
    ///
    /// - Parameter offSet: Content offset x
    /// - Returns: Index
    open func index(withOffset offset: CGFloat) -> Int {
        return Int(offset / scrollView.frame.width)
    }
    
    /// Calculate how manay pages are visible
    ///
    /// - Returns: Visible index collection
    open func visiblePagesIndexs() -> [Int] {
        var indexs: [Int] = []
        var beginIndex: Int = index(withOffset: scrollView.contentOffset.x)
        while isVisible(forPageAtIndex: beginIndex) {
            indexs.append(beginIndex)
            beginIndex += 1
        }
        return indexs
    }
    
    /// Override this function to custom page frame if need
    ///
    /// - Parameter forPageAtIndex: Index
    /// - Returns: Frame for page
    open func frame(forPageAtIndex index: Int) -> CGRect {
        return CGRect(x: scrollView.frame.width * index.cgfloat,
                      y: 0,
                      width: scrollView.frame.width,
                      height: scrollView.frame.height)
    }
    
    /// Check page is visible by index
    ///
    /// - Parameter index: Index
    /// - Returns: Is index page is visible
    public final func isVisible(forPageAtIndex index: Int) -> Bool {
        return CGRect(x: scrollView.contentOffset.x,
                      y: scrollView.contentOffset.y,
                      width: scrollView.frame.width,
                      height: scrollView.frame.height).intersects(frame(forPageAtIndex: index))
    }
    
    /// Parse page to UIView
    ///
    /// - Parameter page: Page
    /// - Returns: UIView
    public final func parse(_ page: Page) -> UIView {
        switch page.pageType {
        case .view(let view): return view
        case .viewController(let controller): return controller.view
        }
    }
    
    /// Add page to Container
    ///
    /// - Parameter page: Page
    public final func addSubPage(_ page: Page) {
        switch page.pageType {
        case .view(let view):
            scrollView.addSubview(view)
        case .viewController(let controller):
            scrollView.addSubview(controller.view)
            parentViewController?.addChildViewController(controller)
        }
    }
    
    /// Remove page from Container
    ///
    /// - Parameter page: Page
    public final func removeSubPage(_ page: Page) {
        switch page.pageType {
        case .view(let view):
            view.removeFromSuperview()
        case .viewController(let controller):
            controller.view.removeFromSuperview()
            controller.removeFromParentViewController()
        }
    }
    
    
    
    
    
    
    
    
    
    
    
//    public final func pageForIndex(at index: Int) -> Page? {
//        guard isValid(index: index) else { return nil }
//        return visiblePages[index]
//    }
    
    //MARK: - internal function
    
    /// Subclasses can override this method as needed to perform more precise layout of their pages
    ///
    /// - Parameters:
    ///   - page: Page
    ///   - index: Index
//    open func layoutPage(_ page: Page, withIndex index: Int) {
//        parse(page).frame = frame(forPageAtIndex: index)
//    }

    /// Add new page to container
    ///
    /// - Parameters:
    ///   - newPage: New Page
    ///   - index: Index
//    open func load(_ newPage: Page, withIndex index: Int)  {
//        addSubPage(newPage)
//        layoutPage(newPage, withIndex: index)
//    }
    
    //MARK: - private function
    
    /// Scroll did end scroll
//    private func endScroll() {
//        let oldCurrentIndex = currentIndex
//        let newCurrentIndex = getCurrentIndex()
//        containerDidEndSwitching(from: oldCurrentIndex, to: newCurrentIndex)
//    }
}
