//
//  CountryCellTests.swift
//  CountriesChallenge
//
//  Created by Rishitha Reddy on 4/24/25.
//
import XCTest
@testable import CountriesChallenge

final class CountryCellTests: XCTestCase {

    func testConfigureWithCountry() {
        let cell = CountryCell(style: .default, reuseIdentifier: CountryCell.identifier)

        let mockCurrency = Currency(code: "USD", name: "Dollar", symbol: "$")
        let mockLanguage = Language(code: "EN", name: "English")

        let country = Country(
            capital: "Test City",
            code: "TL",
            currency: mockCurrency,
            flag: "",
            language: mockLanguage,
            name: "TestLand",
            region: "Test Region"
        )


        cell.configure(country: country)
        XCTAssertTrue(cell.contentView.subviews.count > 0, "Subviews should be loaded")
    }
}
