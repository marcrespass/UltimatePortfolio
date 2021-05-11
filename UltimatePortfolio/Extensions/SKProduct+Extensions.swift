//
//  SKProduct+Extensions.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 5/11/21.
//

import StoreKit

extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
