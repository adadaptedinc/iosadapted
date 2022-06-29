//
//  AppDelegate.swift
//  kmmLibraryExampleApp
//
//  Created by Matthew Kruk on 01/26/22.
//

import aa_multiplatform_lib
import UIKit

@main
class AppDelegate: UIResponder,
                   UIApplicationDelegate,
                // Add listeners
                   AddItContentListener,
                   EventBroadcastListener {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let aaSdk = IosAdAdapted.shared.withAppId(key: "NWY0NTM2YZDMMDQ0") // #YOUR API KEY GOES HERE#
            .inEnvironment(env: AdAdaptedEnv.dev)
            .enableKeywordIntercept(value: true)
            .onHasAdsToServe { bool in
                print("Has ads to serve: \(bool.boolValue)")
            }
            .setSdkEventListener(listener: self)
            .setSdkAddItContentListener(listener: self)
        do {
            try aaSdk.start()
        } catch {
            print("Error starting SDK: \(error)")
        }

        return true
    }

    // Ad tracking events
    func onAdEventTracked(zoneId: String, eventType: String) {
        print("Ad \(eventType) for Zone \(zoneId)")
    }

    // Handle content
    func onContentAvailable(content: AddToListContent) {
        print("AppDelegate.onContentAvailable: \(content)")
        let payloadAddToListItems = content.getItems()

        for item in payloadAddToListItems {
            print("Item is \(item.title)")
            NotificationCenter.default.post(name: Notification.Name("addDetailedListItem"), object: nil, userInfo: ["detailedItem" : item.title])
            content.itemAcknowledge(item: item)
            content.acknowledge()
        }
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}

