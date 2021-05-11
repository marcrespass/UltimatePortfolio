//
//  UnlockManager.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 5/11/21.
//

/*
 https://www.hackingwithswift.com/plus/ultimate-portfolio-app/offering-in-app-purchases-part-1

 For real, shipping apps this process is done through a site called App Store Connect, which is the CMS app created for us to create and configure live apps on the store. There you would select your app, then add individual in-app purchases there along with prices for each of them. As far as I know you can add as many IAPs as you want for a given app – certainly I’ve never hit a limit. These all then get reviewed by Apple individually, and once approved can be used by your app.

 However, this app is not on the App Store, so we don’t want to use App Store Connect. Instead, we’re going to create a StoreKit configuration file that mimics App Store Connect – we can create and price in-app purchases, then use them in testing our app, without having to get attach them to real apps or getting them approved by Apple.
 */

import Combine
import StoreKit

class UnlockManager: NSObject, ObservableObject {
    enum RequestState {
        case loading
        case loaded
        case failed
        case purchased
        case deferred
    }

    private let dataController: DataController
    private let request: SKProductsRequest
    private var loadedProducts = [SKProduct]()

    @Published var requestState = RequestState.loading

    // THIS IS EXTREMELY IMPORTANT
    // IMMEDIATELY start monitoring the transaction queue,
    // so that any external purchases, restores, and more get tracked.
    init(dataController: DataController) {
        // Store the data controller we were sent.
        self.dataController = dataController

        // Prepare to look for our unlock product.
        let productIDs = Set(["com.iliosinc.UltimatePortfolio.unlock"])
        self.request = SKProductsRequest(productIdentifiers: productIDs)

        // This is required because we inherit from NSObject.
        super.init()

        // Start watching the payment queue.
        SKPaymentQueue.default().add(self)
        // Set ourselves up to be notified when the product request completes.
        self.request.delegate = self
        // Start the request
        self.request.start()
    }

    deinit {
        SKPaymentQueue.default().remove(self)
    }
}

// MARK: - SKPaymentTransactionObserver (watch for purchases happening)
extension UnlockManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {

    }
}

// MARK: - SKProductsRequestDelegate (request products from Apple)
extension UnlockManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {

    }
}
