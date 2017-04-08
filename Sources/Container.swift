//
//  Container.swift
//  PageKit
//
//  Created by Jack on 4/2/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit

public typealias Page = LiveViewRepresentable

/// Data Sources for PageContainer
public protocol ContainerDataSource: PageKitDataSource {
    
    /// Asks for page size, only effective when `isAutoresizeEnable` is false
    ///
    /// - Parameters:
    ///   - container: PageContainer
    ///   - index: Index
    /// - Returns: Size for Page
    func container(_ container: Container, edgeInsetForIndexAt index: Int) -> UIEdgeInsets
    
    /// Asks for PageRepresentation, you should not retain PageRepresentation.
    ///
    /// - Parameters:
    ///   - container: PageContainer
    ///   - index: Index
    /// - Returns: PageRepresentation
    func container(_ container: Container, pageForIndexAt index: Int) -> Page
}

extension ContainerDataSource {
    func container(_ container: Container, sizeForIndexAt index: Int) -> CGSize { return container.frame.size }
}

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
    
    open let contentView: UIView = UIView()
    
    open weak var dataSource: ContainerDataSource?
    
    /// Limit delegate is only by self
    open override weak var delegate: UIScrollViewDelegate? {
        get { return self }
        set { if newValue != nil && newValue!.isKind(of: Container.self) { super.delegate = newValue } }
    }
    
    /// You should not assignment this value directly. Instead assignment in `PageView` defaultIndex
    /// to keep synchronize with `Header` defaultIndex.
    open var defaultIndex: Int = 0
    
    /// You should not assignment this value directly. Instead assignment in `PageView` currentIndex
    /// to keep synchronize with `Header` currentIndex.
    open var currentIndex: Int = .begin
    
    /// Is auto set page size same as PageContainer
    ///
    /// Always Effective for UIViewController that did't loaded
    open var isAutoresizeEnable: Bool = true
    
    open weak var parentController: UIViewController?
    
    open override var contentSize: CGSize {
        didSet {
            contentView.frame = CGRect(origin: .zero, size: contentSize)
        }
    }
    
//    open override var frame: CGRect {
//        didSet {
//            setContentOffset(by: currentIndex, animated: false)
//            
//            for (index, controller) in pages.enumerated() where controller != nil { updatePage(controller!.view, at: index) }
//        }
//    }
    
    //MARK: - internal property
    
    /// pager delegate
//    open weak var pageContainerDelegate: PageContainerDelegate?
    public var spacing: CGFloat = 0
    //MARK: - private property
    
    /// All SubPages
    internal var pages: [Page?] = []
//    internal var registedPages: [String: Page.Type] = [:]
//    internal var reuseablePages: [String: Page] = [:]
//    internal var visiblePages: [String: Page] = [:]
    
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
    
    /// Is valid index for page
    ///
    /// - Parameter index: Index
    /// - Returns: Index is valid
    public final func isValid(index: Int) -> Bool {
        return pages.count > index && index >= 0
    }
    
    /// Reload all pages
    public final func reloadPages() {
        currentIndex = .begin
        nextIndex = defaultIndex
        pages.filter{ $0 != nil }.forEach{ removePage($0!) }
        reloadPage(byIndex: nextIndex)
    }
    
    /// Reload page by index
    ///
    /// - Parameter index: Index
    public final func reloadPage(byIndex index: Int) {
        guard let dataSource = dataSource, isValid(index: index) else { return }
        
        let page = dataSource.container(self, pageForIndexAt: index)
        if let oldPage = pages[index] { removePage(oldPage) }
        addPage(page)
        pages[index] = page
        setContentOffset(byIndex: index, animated: false)
    }
    
    /// Add page to Container
    ///
    /// - Parameter page: Page
    private func addPage(_ page: Page) {
        switch page.liveViewType {
        case .view(let view):
            contentView.addSubview(view)
        case .viewController(let controller):
            contentView.addSubview(controller.view)
            parentController?.addChildViewController(controller)
        }
    }
    
    /// Remove page from Container
    ///
    /// - Parameter page: Page
    private func removePage(_ page: Page) {
        switch page.liveViewType {
        case .view(let view):
            view.removeFromSuperview()
        case .viewController(let controller):
            contentView.addSubview(controller.view)
            controller.view.removeFromSuperview()
            controller.removeFromParentViewController()
        }
    }
    
    
    
    
    
    
    public final func scroll(toIndex index: Int, animated: Bool) {
        setContentOffset(byIndex: index, animated: animated)
    }
    
//    public final func register(_ pageClass: Page.Type, forPageReuseIndentifier identifier: String) {
//        registedPages[identifier] = pageClass
//    }
//    
//    private func enqueue(withIdentifier indentifier: String, page: Page) {
//        reuseablePages[indentifier] = page
//    }
//    
//    public final func dequeueReusablePage(withIdentifier identifier: String) -> Page? {
//        return reuseablePages[identifier] ?? registedPages[identifier]?.init()
//    }
    
    //MARK: - private function
    
    /// Init page by number
    ///
    /// - Parameter number: total of pages
    private func initPages(by number: Int) {
//        pages.filter{ $0 != nil }.forEach{ parsePage(by: $0!.pageType).removeFromSuperview() }
//        pages = Array(repeating: nil, count: number)
    }
    
//    private func resizePages() {
//        guard let dataSource = dataSource else { return }
//        let number = dataSource.numberOfPages()
//        
//        if isPagingEnabled {
//            contentSize = CGSize(width: frame.width * number.cgfloat,
//                                 height: frame.height)
//        } else {
//            var width: CGFloat = 0
//            for index in 0..<number {
//                width += dataSource.container(self, sizeForIndexAt: index).width
//            }
//            contentSize = CGSize(width: width + (number + 1).cgfloat * spacing,
//                                 height: frame.height)
//        }
//    }
    
    /// Dynamic Create Page
    ///
    /// - parameter index: An index has been selected
    private func dynamicPage(byIndex index: Int) {
//        guard isValid(index: index) else { return }
        
//        guard isValid(index: index) &&
//            pages[index] == nil else { return }
//        
//        guard let controller = dataSources?.page(self, pageForIndexAt: index) else { return }
//        addSubview(parsePage(by: controller.pageType))
//        pages[index] = controller
//        updatePage(parsePage(by: controller.pageType), at: index)
    }
    
    /// Set SubView Size and origin
    ///
    /// - parameter view:  whitch view will been setted
    /// - parameter index: Index
    private func updatePage(_ view: UIView, at index: Int) {
//        let dataSourcesSize = dataSources?.page(self, sizeForIndexAt: index)
//        let size: CGSize = autoresize ? frame.size : dataSourcesSize ?? .zero
//        let origin: CGPoint = autoresize ?
//            CGPoint(x: CGFloat(index) * frame.size.width, y: 0) :
//            {
//                guard let size = dataSourcesSize else { return .zero }
//                return CGPoint(x: (frame.size.width - size.width) / 2 + CGFloat(index) * frame.size.width,
//                               y: (frame.size.height - size.height) / 2)
//            }()
//        view.frame = CGRect(origin: origin, size: size)
    }
    
    /// Set Pager's ContentOffset
    ///
    /// - parameter index:    whitch index has been selected
    /// - parameter animated: Is animation for this select
    private func setContentOffset(byIndex index: Int, animated: Bool) {
//        var newFrame = pages[index]?.view.frame ?? .zero
//        newFrame.origin.x = frame.width * CGFloat(index)
//        newFrame.origin.y = 0
//        setContentOffset(newFrame.origin, animated: animated)
    }
    
    /// Scroll did end scroll
    /// now, currentIndex is nextIndex
    private func endScroll() {
//        let oldCurrentIndex = currentIndex
//        nextIndex = Int(contentOffset.x / frame.width)
//        currentIndex = nextIndex
//        
//        guard isValid(index: oldCurrentIndex) else { return }
//        containerDidEndSwitch(from: pages[oldCurrentIndex], fromIndex: oldCurrentIndex,
//                         to: isValid(index: nextIndex) ? pages[nextIndex] : nil, nextIndex: nextIndex)
//        pageContainerDelegate?.pageDidEndSwitch(from: oldCurrentIndex, to: nextIndex)
        
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
    final public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
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
    open func pageContainerWillSwitch(from fromPage: Page?, fromIndex: Int,
                                      to nextPage: Page?, nextIndex: Int,
                                      completed percent: Double) {
        
    }
    
    /// Page did end scroll from index to next index, Default do nothing.
    ///
    /// - Parameters:
    ///   - fromController: current ViewController
    ///   - fromIndex: current index
    ///   - toController: next ViewController
    ///   - toIndex: next index
    open func pageContainerDidEndSwitch(from fromPage: Page?, fromIndex: Int,
                                        to nextPage: Page?, nextIndex: Int) {
        
    }
    
    /// Page Will load next ViewController with index, override this function to control when to load viewController.
    ///
    /// - Parameter index: next index
    /// - Returns: load ViewController if true or not load.
    open func pageContainerWillLoadNextPage(with index: Int, completed percent: CGFloat) -> Bool {
        return true
    }
}


