//
//  SceneDelegate.swift
//  kmmLibraryExampleApp
//
//  Created by Matthew Kruk on 2/3/22.
//

import aa_multiplatform_lib
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let winScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: winScene)
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
    }

    // Collect deeplink from userActivity
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        do {
            try DeeplinkContentParser().handleDeeplink(userActivity: userActivity)
        } catch {
            print("Error handling deeplink: \(error)")
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
