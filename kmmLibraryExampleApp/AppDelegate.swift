//
//  AppDelegate.swift
//  kmmLibraryExampleApp
//
//  Created by Matthew Kruk on 01/26/22.
//

import aa_multiplatform_lib
import UIKit

var _addToListItemCache: AddToListItemCache?

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let aaSdk = IosAdAdapted.shared.withAppId(key: "NWY0NTM2YZDMMDQ0") // #YOUR API KEY GOES HERE# ios-NWY0NTZIODZHNWY0 android-NWY0NTM2YZDMMDQ0
            .inEnvironment(env: AdAdaptedEnv.dev)
            .enableKeywordIntercept(value: true)
            .onHasAdsToServe { bool in
                print("Has ads to serve: \(bool.description)")
            }
            .setSdkAddItContentListener(listener: { content in
                let listItems: [AddToListItem] = content.getItems()
                content.itemAcknowledge(item: listItems.first!)
                content.acknowledge()

                DispatchQueue.main.async {
                    _addToListItemCache?.items?.value = listItems
                    print("Cached list items: \(listItems)")
                }
            })
        do {
            try aaSdk.start()
        } catch {
            print("Error starting SDK: \(error)")
        }

        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

