//
//  PlatformAdjustments.swift
//  UltimatePortfolioMac
//
//  Created by Marc Respass on 2/25/22.
//

// **** PlatformAdjustments MAC **** //
import SwiftUI

typealias InsetGroupedListStyle = SidebarListStyle
typealias ImageButtonStyle = BorderlessButtonStyle

extension Notification.Name {
    static let willResignActiveNotification = NSApplication.willResignActiveNotification
}

struct StackNavigationView<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(spacing: 0, content: content)
    }
}
