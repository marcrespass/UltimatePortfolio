//
//  SFSymbol.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 2/15/21.
//

import SwiftUI

enum SFSymbol: String, View {
    case house = "house"
    case listBullet = "list.bullet"
    case checkmark = "checkmark"
    case checkmarkCircle = "checkmark.circle"
    case rosette = "rosette"
    case awardImage = "award.image"
    case exclamationmarkTriangle = "exclamationmark.triangle"
    case squareAndPencil = "square.and.pencil"

    var body: Image {
        Image(systemName: self.rawValue)
    }
}

extension Image {
    init(symbol: SFSymbol) {
        self.init(symbol.rawValue)
    }
}
