//
//  SKProduct+Extensions.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 5/11/21.
//

import StoreKit

extension SKProduct {
    // TODO: Aren't formatters expensive? Should this be a lazy or static?
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        // swiftlint:disable:next force_unwrapping
        return formatter.string(from: price)!
    }
}
