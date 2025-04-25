//
//  CountriesParserTests.swift
//  CountriesChallenge
//
//  Created by Rishitha Reddy on 4/24/25.
//

import XCTest
@testable import CountriesChallenge

final class CountriesParserTests: XCTestCase {

    var parser: CountriesParser!

    override func setUp() {
        super.setUp()
        parser = CountriesParser()
    }

    override func tearDown() {
        parser = nil
        super.tearDown()
    }

    func testSuccessfulParse() {
        let json = """
        [
          {
            "name": "TestLand",
            "code": "TL",
            "capital": "Test City",
            "region": "Test Region",
            "currency": { "code": "USD", "name": "Dollar", "symbol": "$" },
            "language": { "code": "E", "name": "English" },
            "flag": ""
          }
        ]
        """.data(using: .utf8)

        let result = parser.parser(json)

        switch result {
        case .success(let countries):
            XCTAssertEqual(countries?.first?.name, "TestLand")
        case .failure:
            XCTFail("Expected successful parsing")
        }
    }

    func testNilDataReturnsSuccessWithNil() {
        let result = parser.parser(nil)

        switch result {
        case .success(let countries):
            XCTAssertNil(countries)
        case .failure:
            XCTFail("Expected success with nil countries")
        }
    }

    func testInvalidJSONReturnsFailure() {
        let invalidJson = "not valid".data(using: .utf8)
        let result = parser.parser(invalidJson)

        switch result {
        case .success:
            XCTFail("Expected failure for invalid JSON")
        case .failure(let error):
            XCTAssertTrue(error is CountriesParserError)
        }
    }
}
