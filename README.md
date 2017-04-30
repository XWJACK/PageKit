# PageKit

## Installation

![Xcode 8.2+](https://img.shields.io/badge/Xcode-8.2%2B-blue.svg) ![iOS 8.0+](https://img.shields.io/badge/iOS-8.0%2B-blue.svg) ![Swift 3.0+](https://img.shields.io/badge/Swift-3.0%2B-orange.svg) [![Version](https://img.shields.io/cocoapods/v/PageKit.svg?style=flat)](https://cocoapods.org/pods/PageKit)

## Container:

😇关闭重用：每个页面都会加载一遍，已经加载的Page不会再次加载，也不会调用代理方法。

## ReuseContainer:

### 提供重用Page的功能。

😇开启重用：重用和`UITableView`使用相同：

- 注册需要加载的Page，会自动使用类名作为Identifier

```swift
container.register(UIView.self)
container.register(UIViewController.self)
```

- 在代理方法中： `dequeueReusablePage`，Identifier为`UIViewController.reuseIdentifier`

```swift
func container(_ container: Container, pageForIndexAt index: Int) -> Page {
    if let page = container.dequeueReusablePage(withIdentifier: UIView.reuseIdentifier) as? UIView {
        ...
        return page
    } else if let page = container.dequeueReusablePage(withIdentifier: UIViewController.reuseIdentifier) as? UIViewController {
        return page
    } else {
        let view = UIView()
        ...
        return view
    }
}
```

