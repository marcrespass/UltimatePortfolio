//
//  PlatformAdjustments.swift
//  UltimatePortfolioMac
//
//  Created by Marc Respass on 2/25/22.
//

// **** PlatformAdjustments iOS **** //
import SwiftUI

typealias ImageButtonStyle = BorderlessButtonStyle
typealias MacOnlySpacer = EmptyView

extension Notification.Name {
    static let willResignActiveNotification = UIApplication.willResignActiveNotification
}

struct StackNavigationView<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        NavigationView(content: content)
            .navigationViewStyle(.stack)
    }
}

extension Section where Parent: View, Content: View, Footer: View {
    func disableCollapsing() -> some View {
        self
    }
}

extension View {
    public func onDeleteCommand(perform action: (() -> Void)?) -> some View {
        self
    }

    func macOnlyPadding() -> some View {
        self
    }
}
