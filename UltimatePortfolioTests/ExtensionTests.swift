//
//  ExtensionTests.swift
//  UltimatePortfolioTests
//
//  Created by Marc Respass on 2/3/21.
//

import XCTest
import SwiftUI
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

    func testBundleDecodingAwards() {
        let awards: [Award] = Bundle.main.decode(from: "Awards.json")
        XCTAssertFalse(awards.isEmpty, "Awards.json should deocde a non-empty array.")
    }

    func testDecodingString() {
        let bundle = Bundle(for: ExtensionTests.self)
        let string: String = bundle.decode(from: "DecodableString.json")
        XCTAssertEqual(string, "The rain in Spain falls mainly on the Spaniards", "should match")
    }

    func testDecodingDictionary() {
        let bundle = Bundle(for: ExtensionTests.self)
        let dict: [String: Int] = bundle.decode(from: "DecodableDictionary.json")
        XCTAssertEqual(dict["one"], 1)
        XCTAssertEqual(dict.count, 3)
    }

    func testBindingOnChange() {
        var onChangeFunctionRun = false

        func exampleFunctionToCall() {
            onChangeFunctionRun = true
        }

        var storedValue = ""

        let binding = Binding(
            get: { storedValue },
            set: { storedValue = $0 }
        )

        let changedBinding = binding.onChange(exampleFunctionToCall)
        changedBinding.wrappedValue = "Test"

        XCTAssertTrue(onChangeFunctionRun, "onChange() must be run when binding changed")
    }
}
