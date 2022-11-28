//
//  AppDelegate.swift
//  kmmLibraryExampleApp
//
//  Created by Matthew Kruk on 01/26/22.
//

import aa_multiplatform_lib
import UIKit

@main
class AppDelegate:  UIResponder,
                    UIApplicationDelegate,
                    AddItContentListener,
                    EventBroadcastListener,
                    SessionBroadcastListener {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let aaSdk = IosAdAdapted.shared.withAppId(key: "7D58810X6333241C") // #YOUR API KEY GOES HERE#
            .inEnvironment(env: AdAdaptedEnv.dev)
            .enableKeywordIntercept(value: true)
            .setSdkSessionListener(listener: self)
            .setSdkEventListener(listener: self)
            .setSdkAddItContentListener(listener: self)
            .enableDebugLogging()
        do {
            try aaSdk.start()
        } catch {
            print("Error starting SDK: \(error)")
        }

        return true
    }
    
    func onHasAdsToServe(hasAds: Bool, availableZoneIds: [String]) {
        print("Has ads to serve: \(hasAds)")
        print("Has ads to serve: \(availableZoneIds)")
    }
                        
    // EventBroadcast listener
    func onAdEventTracked(zoneId: String, eventType: String) {
        print("Ad \(eventType) for Zone \(zoneId)")
    }

    // AddIt content listener
    func onContentAvailable(content: AddToListContent) {
        let payloadAddToListItems = content.getItems()

        for item in payloadAddToListItems {
            NotificationCenter.default.post(name: Notification.Name("addDetailedListItem"), object: nil, userInfo: ["detailedItem" : item.title])
            content.acknowledge()
        }
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}

