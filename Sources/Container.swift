//
//  Container.swift
//  PageKit
//
//  Created by Jack on 4/2/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit

public typealias Page = PageRepresentable

/// Data Sources for PageContainer
public protocol ContainerDataSource: class {
    
    /// Asks for page size, only effective when `isAutoresizeEnable` is false
    ///
    /// - Parameters:
    ///   - container: PageContainer
    ///   - index: Index
    /// - Returns: Size for Page
//    func container(_ container: Container, sizeForIndexAt index: Int) -> CGSize

    /// Asks for PageRepresentation, you should not retain PageRepresentation.
    ///
    /// - Parameters:
    ///   - container: PageContainer
    ///   - index: Index
    /// - Returns: PageRepresentation
//    func container(_ container: Container, pageForIndexAt index: Int) -> Page
    
    /// Asks for number of page
    ///
    /// - Returns: Number of page
    func numberOfPages() -> Int
}

//extension ContainerDataSource {
//    func container(_ container: Container, sizeForIndexAt index: Int) -> CGSize {
//        return container.frame.size
//    }
//}

// MARK: - blow to Modify

//public protocol PageContainerDelegate: class {
//    
//    /// page to next index, always right index
//    ///
//    /// - Parameter index: next index
//    func paging(to index: Int)
//    
//    /// Page will scroll from index to next index, with completed percent
//    ///
//    /// - Parameters:
//    ///   - fromIndex: current index
//    ///   - toIndex: next idnex, ⚠️: may be will pass invalid index
//    ///   - percent: completed percent
//    func pageWillSwitch(from fromIndex: Int, to nextIndex: Int, completed percent: CGFloat)
//    
//    /// Page did end scroll from index to next index, always right index.
//    ///
//    /// - Parameters:
//    ///   - fromIndex: current index
//    ///   - toIndex: next index
//    func pageDidEndSwitch(from fromIndex: Int, to nextIndex: Int)
//}
//
//public extension PageContainer {
//    func page(to index: Int) {}
//    func pageWillSwitch(from fromIndex: Int, to nextIndex: Int, completed percent: CGFloat){}
//    func pageDidEndSwitch(from fromIndex: Int, to nextIndex: Int){}
//}


open class Container: UIScrollView, UIScrollViewDelegate {
    
    //MARK: - open property
    
//    open let contentView: UIView = UIView()
    
    open weak var dataSource: ContainerDataSource?
    
    /// Limit delegate is only by self
    open override weak var delegate: UIScrollViewDelegate? {
        get { return self }
        set { if newValue != nil && newValue!.isKind(of: Container.self) { super.delegate = newValue } }
    }
    
    open var defaultIndex: Int = 0
    open var currentIndex: Int = .begin
    
    /// Is auto set page size same as PageContainer
    ///
    /// Always Effective for UIViewController that did't loaded
//    open var isAutoresizeEnable: Bool = true
    
//    open weak var parentController: UIViewController?
    
//    open override var contentSize: CGSize {
//        didSet {
//            contentView.frame = CGRect(origin: .zero, size: contentSize)
//        }
//    }
    
    //MARK: - internal property
    
    /// Page will switch to next index
    private var nextIndex: Int = .begin
    
    /// Is user interaction to scroll
//    private var isuserInteraction: Bool = false
    
    //MARK: - public function
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        delegate = self
        
        alwaysBounceHorizontal = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - function public final
    
    /// Is valid index for page
    ///
    /// - Parameter index: Index
    /// - Returns: Index is valid
//    public final func isValid(index: Int) -> Bool {
//        return pages.count > index && index >= 0
//    }
    
    /// Reload all pages
    open func reloadPage() {
        currentIndex = .begin
        nextIndex = defaultIndex
        contentSize = getContentSize()
    }
    
    /// Set contentSize
    ///
    /// - Returns: Size for content
    open func getContentSize() -> CGSize {
        let number = dataSource?.numberOfPages() ?? 0
        return CGSize(width: frame.width * number.cgfloat, height: frame.height)
    }
    
    /// Override this function to custom index position
    ///
    /// - Returns: Current index for Container
    open func getCurrentIndex() -> Int {
        return Int(contentOffset.x / frame.width)
    }
    
    open func getCurrentPageOrigin(by index: Int) -> CGPoint {
        return CGPoint(x: index.cgfloat * frame.width, y: 0)
    }
    /// Reload page by index
    ///
    /// - Parameter index: Index
//    open func reloadPage(byIndex index: Int) {
//        guard dataSource != nil, isValid(index: index) else { return }
//        dynamicPage(byIndex: index)
//        switching(toIndex: index, animated: false)
//    }
    
    /// Parse page to UIView
    ///
    /// - Parameter page: Page
    /// - Returns: UIView
//    public final func parse(page: Page) -> UIView {
//        switch page.liveViewType {
//        case .view(let view): return view
//        case .viewController(let controller): return controller.view
//        }
//    }
    
    //MARK: - function private
    
    /// Add page to Container
    ///
    /// - Parameter page: Page
//    private func add(page: Page) {
//        switch page.liveViewType {
//        case .view(let view):
//            contentView.addSubview(view)
//        case .viewController(let controller):
//            contentView.addSubview(controller.view)
//            parentController?.addChildViewController(controller)
//        }
//    }
    
    /// Remove page from Container
    ///
    /// - Parameter page: Page
//    private func remove(page: Page) {
//        switch page.liveViewType {
//        case .view(let view):
//            view.removeFromSuperview()
//        case .viewController(let controller):
//            contentView.addSubview(controller.view)
//            controller.view.removeFromSuperview()
//            controller.removeFromParentViewController()
//        }
//    }
    
    //MARK: - function open
    
    /// Switch to index with animate
    ///
    /// - Parameters:
    ///   - index: Next index
    ///   - animated: Animate
    open func switching(toIndex index: Int, animated: Bool) {
        setContentOffset(getCurrentPageOrigin(by: index), animated: animated)
    }
    
    /// Subclasses can override this method as needed to perform more precise layout of their pages
    ///
    /// - Parameters:
    ///   - page: Page
    ///   - index: Index
//    open func layoutPages(_ page: Page, withIndex index: Int) {
//        let pageSize = dataSource?.container(self, sizeForIndexAt: index) ?? .zero
//        let originX = CGFloat(index) * (isAutoresizeEnable ? frame.size.width : pageSize.width) + CGFloat(index + 1) * spacing
//        parse(page: page).frame = CGRect(origin: CGPoint(x: originX, y: 0),
//                                         size: pageSize)
//    }
    
    /// Dynamic Create Page
    ///
    /// - parameter index: An index has been selected
//    private func dynamicPage(byIndex index: Int) {
//        guard pages[index] == nil else { return }
//        
//        let page = dataSource!.container(self, pageForIndexAt: index)
//        add(page: page)
//        pages[index] = page
//        layoutPages(page, withIndex: index)
//    }
    
    /// Scroll did end scroll
    /// now, currentIndex is nextIndex
    private func endScroll() {
        let oldCurrentIndex = currentIndex
        let newCurrentIndex = getCurrentIndex()
        containerDidEndSwitching(from: oldCurrentIndex, to: newCurrentIndex)
    }

    // MARK: - public final UIScrollViewDelegate
    
    final public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
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
    
    //MARK: - User Dragging
    
//    open func scrollNextIndex() -> Int {
//        let index = Int(contentOffset.x / frame.width)
//        return index < 0 ? .begin : index >= (dataSource?.numberOfPages() ?? 0) - 1 ?
//    }
    
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    }
    
    open func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                                withVelocity velocity: CGPoint,
                                                targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        guard !isPagingEnabled else { return }
//        var offSet: CGFloat = 0
//        for index in 0...index(by: targetContentOffset.pointee.x) {
//            offSet = dataSources?.page(self, sizeForIndexAt: index)
//        }
    }
    
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    }
    
    
    
    
    
    final public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
    }
    
    /// only useful for user scroll by finger: Scroll page
    public final func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        endScroll()
    }
    
    /// only useful for `setContentOffset` or `scrollRectToVisible` with animations are requested.
    public final func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        endScroll()
    }
    
    //MARK: - open custom override
    
    /// Page will scroll from index to next index, Default do nothing.
    ///
    /// - Parameters:
    ///   - fromIndex: current Index
    ///   - toIndex: next index
    ///   - percent: completed percent, The value of this property is a floating-point number in the range 0.0 to 1.0
    open func containerDidSwitching(fromIndex: Int,
                                    to nextIndex: Int,
                                    completed percent: Double) {
        
    }
    
    /// Page did end scroll from index to next index, Default do nothing.
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
    open func containerWillLoadNextPage(with index: Int, completed percent: CGFloat) -> Bool {
        return true
    }
}


