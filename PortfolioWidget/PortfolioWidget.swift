//
//  PortfolioWidget.swift
//  PortfolioWidget
//
//  Created by Marc Respass on 6/2/21.
//

import WidgetKit
import SwiftUI

@main
struct PortfolioWidgets: WidgetBundle {
    var body: some Widget {
        SimplePortfolioWidget()
        ComplexPortfolioWidget()
    }
}
