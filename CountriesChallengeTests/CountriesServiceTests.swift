//
//  CountriesServiceTests.swift
//  CountriesChallenge
//
//  Created by Rishitha Reddy on 4/24/25.
//

import XCTest
@testable import CountriesChallenge

final class CountriesServiceTests: XCTestCase {

    var service: CountriesService!

    override func setUp() {
        super.setUp()
        service = CountriesService()
    }

    override func tearDown() {
        service = nil
        super.tearDown()
    }

    /// This test uses a mock service to simulate an invalid URL error
    func testInvalidUrlThrowsError() async throws {
        class MockInvalidURLService: CountriesService {
            override func fetchCountries() async throws -> [Country] {
                throw CountriesServiceError.invalidUrl("invalid_url")
            }
        }

        let invalidService = MockInvalidURLService()

        do {
            _ = try await invalidService.fetchCountries()
            XCTFail("Expected failure due to invalid URL")
        } catch {
            XCTAssertTrue(error is CountriesServiceError)
        }
    }
}
