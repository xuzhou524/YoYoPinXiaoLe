//
//  XZNavigationController.swift
//  YoYoPinXiaoLe
//
//  Created by xuzhou on 2021/4/25.
//

import UIKit

class XZNavigationController: UINavigationController {
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.navigationBar.setBackgroundImage(UIColor(named: "color_theme")?.image, for: .default)
        self.navigationBar.shadowImage = UIImage()
        
        self.navigationBar.titleTextAttributes = [
            .font: weightFontWithSize(18, weight: .medium),
            .foregroundColor: UIColor(named: "color_title_black")!]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let bar = UINavigationBar.appearance(whenContainedInInstancesOf: [XZNavigationController.self])
        bar.backIndicatorImage = UIImage(named: "ic_back")
        bar.backIndicatorTransitionMaskImage = UIImage(named: "ic_back")
        bar.tintColor = UIColor(named: "color_title_black")
        let barButton = UIBarButtonItem.appearance(whenContainedInInstancesOf: [XZNavigationController.self])
        barButton.setTitleTextAttributes([NSAttributedString.Key.font: fontWithSize(0)], for: .normal)
        barButton.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: 0), for: .default)
 
    }
    
    override var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }

    override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: true)
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        if viewControllers.count > 1 {
            let vc = viewControllers.last
            vc?.hidesBottomBarWhenPushed = true
        }
        super.setViewControllers(viewControllers, animated: animated)
    }
}
