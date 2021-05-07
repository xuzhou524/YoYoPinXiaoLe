//
//  SceneDelegate.swift
//  YoYoPinXiaoLe
//
//  Created by gozap on 2021/4/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(windowScene: windowScene)
        self.window?.backgroundColor = UIColor.white
        self.window?.rootViewController = XZNavigationController.init(rootViewController: HomeViewController())
        self.window?.makeKeyAndVisible()
    }

}

