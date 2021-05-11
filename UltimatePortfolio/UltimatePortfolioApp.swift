//
//  UltimatePortfolioApp.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 10/26/20.
//

import SwiftUI

/*
 “Code coverage” is the term we use to determine how much of your main app code
 was run during your tests. It’s usually expressed as a percentage, so 100%
 coverage would mean that literally every line of your code got hit during your tests.
 You might think that 100% coverage is exactly what we should all strive for,
 but actually it’s a bit more complicated than that for two reasons.

 code coverage measures which parts of our app code were RUN during the tests NOT TESTED
 */

// which-swiftui-property-wrapper
// https://www.hackingwithswift.com/articles/227/which-swiftui-property-wrapper
@main
struct UltimatePortfolioApp: App {
    @StateObject var dataController: DataController
    @StateObject var unlockManager: UnlockManager

    init() {
        let dataController = DataController()
        let unlockManager = UnlockManager(dataController: dataController)

        _dataController = StateObject(wrappedValue: dataController)
        _unlockManager = StateObject(wrappedValue: unlockManager)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, self.dataController.container.viewContext)
                .environmentObject(self.dataController)
                .environmentObject(self.unlockManager)

                // Automatically save when we detect that we are
                // no longer the foreground app. Use this rather than
                // scene phase so we can port to macOS, where scene
                // phase won't detect our app losing focus.
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification),
                           perform: self.save(_:))
        }
    }

    func save(_ note: Notification) {
        self.dataController.save()
    }
}
