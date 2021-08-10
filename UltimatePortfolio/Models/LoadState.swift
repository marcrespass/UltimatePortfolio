//
//  LoadState.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 8/9/21.
//

import Foundation

/// State of loading data from iCloud
///
/// UI might be in one of four states
///
/// 1. No data request has been made yet
/// 2. A data request is currently in flight
/// 3. Some successful data has been received
/// 4. The request finished without any results
enum LoadState {
    case inactive
    case loading
    case success
    case noResults
}
