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
    
    func container(_ container: TitleContainer, sizeForTitleAt index: Int) -> CGSize
    
    /// Asks for indicator size
    ///
    /// - Parameters:
    ///   - header: Header
    ///   - indicator: Indicator instanse
    /// - Returns: Size for indicator
    func container(_ container: TitleContainer,
                   widthForIndicator indicator: UIView,
                   underTitle title: Page,
                   withIndex index: Int) -> CGFloat
}

public extension TitleContainerDataSources {
    func title(_ titleContainer: TitleContainer,
               widthForIndicator indicator: UIView,
               underTitle title: Page,
               withIndex index: Int) -> CGFloat {
        switch title.pageType {
        case .view(let view): return view.frame.size.width
        case .viewController(let controller): return controller.view.frame.size.width
        }
    }
}

open class TitleContainer: Container {
    
    open var spacing: CGFloat = 0
    
    /// Indicator View
    open var indicator = UIView()
    
    private var pagesFrame: [CGRect] = []
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        isPagingEnabled = false
        isReuseEnable = false
        
        indicator.backgroundColor = .white
        addSubview(indicator)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func reloadPage() {
        super.reloadPage()
        
        pagesFrame = Array(repeating: .zero, count: numberOfPages)
        
        guard let dataSource = dataSource as? TitleContainerDataSources else { return }
        for index in 0..<numberOfPages {
            let titleSize = dataSource.container(self, sizeForTitleAt: index)
            pagesFrame[index] = CGRect(origin: CGPoint(x: titleSize.width * index.cgfloat + spacing * (index + 1).cgfloat,
                                                       y: 0),
                                       size: titleSize)
        }
    }
    open override func resetContentSize() -> CGSize {
        return CGSize(width: frame.width * numberOfPages.cgfloat + spacing * (numberOfPages + 1).cgfloat,
                      height: frame.height)
    }
    
    open override func layoutPages(_ page: Page, withIndex index: Int) {
        parse(page: page).frame = CGRect(x: (frame.width + spacing) * index.cgfloat,
                                         y: 0,
                                         width: frame.width,
                                         height: frame.height)
    }
    
    open override func pageFrame(byIndex index: Int) -> CGRect {
        return CGRect(x: frame.width * index.cgfloat,
                      y: 0,
                      width: frame.width,
                      height: frame.height)
    }
    
    public final func offSet(by index: Int) -> CGFloat {
        return isValid(index: index) ? titles.filter{ $0.tag < defaultTag + index }.reduce(CGFloat(0), {total, title in total + title.frame.width }) :
            index == titles.count ? titles.reduce(CGFloat(0), {total, title in total + title.frame.width }) : 0
    }
    
    open override func containerDidEndSwitching(from fromIndex: Int, to nextIndex: Int) {
        /// 默认滚动到中间
        let offset = offSet(by: nextIndex) + nextTitle.frame.width / 2 - frame.width / 2
        guard offset > 0 && offset < contentSize.width - frame.width else { return }
        setContentOffset(CGPoint(x: offset, y: 0), animated: true)
    }
}
*/
