//
//  AppDelegate.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 6/2/21.
//

import SwiftUI

final class AppDelegate: NSObject, UIApplicationDelegate {
    // Configure to use our SceneDelegate
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(name: "Default", sessionRole: connectingSceneSession.role)
        sceneConfiguration.delegateClass = SceneDelegate.self
        return sceneConfiguration
    }
}
