//
//  ExtensionTests.swift
//  UltimatePortfolioTests
//
//  Created by Marc Respass on 2/3/21.
//

import XCTest
@testable import UltimatePortfolio

class ExtensionTests: XCTestCase {
    func testSequenceKeyPathSortingSelf() {
        let items = [1, 4, 3, 2, 5]
        let sortedItems = items.sorted(by: \.self)

        XCTAssertEqual(sortedItems, [1, 2, 3, 4, 5], "sorted numbers must be ascending")
    }

    func testSequenceKeyPathSortingCustom() {
        struct Example: Equatable {
            let value: String
        }

        let ex1 = Example(value: "A")
        let ex2 = Example(value: "B")
        let ex3 = Example(value: "C")

        let items = [ex1, ex2, ex3]
        let sortedItems = items.sorted(by: \.value) {
            $0 > $1
        }

        XCTAssertEqual(sortedItems, [ex3, ex2, ex1], "reverse sorting should be C, B, A")
    }
}
