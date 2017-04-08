//
//  NormalIndicatorHeader.swift
//  PageKit
//
//  Created by Jack on 3/30/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit

open class NormalIndicatorHeader: TitleContainer {
    override open func pageWillSwitch(from fromTitle: UIControl, fromIndex: Int,
                                 to nextTitle: UIControl?, nextIndex: Int,
                                 completed percent: CGFloat) {
        
        var fromSize: CGSize = .zero
        var nextSize: CGSize = .zero
        if let size = dataSources?.header?(self, sizeForIndicator: indicator, underTitle: fromTitle, with: fromIndex) {
            fromSize = size
        }
        if let title = nextTitle, let size = dataSources?.header?(self, sizeForIndicator: indicator, underTitle: title, with: nextIndex) {
            nextSize = size
        }
        indicator.frame = CGRect(x: offSet(by: fromIndex) + (offSet(by: nextIndex) - offSet(by: fromIndex)) * percent,
                                 y: frame.height - (nextSize.height == 0 ? fromSize.height : nextSize.height),
                                 width: fromSize.width + (nextSize.width - fromSize.width) * percent,
                                 height: nextSize.height == 0 ? fromSize.height : nextSize.height)
    }
}
