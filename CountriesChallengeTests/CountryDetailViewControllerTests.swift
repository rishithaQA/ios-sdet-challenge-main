//
//  CountryDetailViewControllerTests.swift
//  CountriesChallenge
//
//  Created by Rishitha Reddy on 4/24/25.
//

import XCTest
@testable import CountriesChallenge

final class CountryDetailViewControllerTests: XCTestCase {

    var detailVC: CountryDetailViewController!

    override func setUp() {
        super.setUp()
        let mockCountry = Country(
            capital: "Test City",
            code: "TL",
            currency: Currency(code: "USD", name: "Dollar", symbol: "$"),
            flag: " ",
            language: Language(code: "E", name: "English"),
            name: "TestLand",
            region: "Test Region"
        )
        detailVC = CountryDetailViewController(country: mockCountry)
        detailVC.loadViewIfNeeded()
    }

    override func tearDown() {
        detailVC = nil
        super.tearDown()
    }

    private func findLabel(withText text: String, in view: UIView) -> UILabel? {
            for subview in view.subviews {
                if let label = subview as? UILabel, label.text?.contains(text) == true {
                    return label
                } else if let found = findLabel(withText: text, in: subview) {
                    return found
                }
            }
            return nil
    }
    
    func testViewLoadsSuccessfully() {
        XCTAssertNotNil(detailVC.view, "Detail view should load")
    }

    func testCountryNameIsDisplayed() {
            let label = findLabel(withText: "TestLand", in: detailVC.view)
            XCTAssertNotNil(label, "Country name 'TestLand' should appear in detail view")
        }

        func testFlagIsDisplayed() {
            let label = findLabel(withText: " ", in: detailVC.view)
            XCTAssertNotNil(label, "Flag emoji should appear in detail view")
        }

        func testCapitalIsDisplayed() {
            let label = findLabel(withText: "Test City", in: detailVC.view)
            XCTAssertNotNil(label, "Capital 'Test City' should appear in detail view")
        }
}
