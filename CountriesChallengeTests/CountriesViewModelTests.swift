//
//  CountriesViewModelTests.swift
//  CountriesChallenge
//
//  Created by Rishitha Reddy on 4/24/25.
//

import XCTest
@testable import CountriesChallenge
import Combine

class MockCountriesService: CountriesService {
    var shouldFail = false
    override func fetchCountries() async throws -> [Country] {
        if shouldFail {
            throw NSError(domain: "TestError", code: 1, userInfo: nil)
        } else {
            let mockCurrency = Currency(code: "USD", name: "Dollar", symbol: "$")
            let mockLanguage = Language(code: "E", name: "English")

            return [Country(
                capital: "Test City",
                code: "TL",
                currency: mockCurrency,
                flag: "",
                language: mockLanguage,
                name: "TestLand",
                region: "Test Region"
            )]
        }
    }
}

final class CountriesViewModelTests: XCTestCase {

    var viewModel: CountriesViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        viewModel = CountriesViewModel()
        viewModel.service = MockCountriesService()
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }

    func testSuccessfulFetch() async {
        (viewModel.service as! MockCountriesService).shouldFail = false

        let expectation = XCTestExpectation(description: "Countries fetched")
        viewModel.countriesSubject
            .dropFirst()
            .sink { countries in
                XCTAssertEqual(countries.first?.name, "TestLand")
                expectation.fulfill()
            }.store(in: &cancellables)

        await viewModel.refreshCountries()
        wait(for: [expectation], timeout: 2.0)
    }

    func testFailedFetch() async {
        (viewModel.service as! MockCountriesService).shouldFail = true

        let expectation = XCTestExpectation(description: "Error captured")
        viewModel.errorSubject
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                expectation.fulfill()
            }.store(in: &cancellables)

        await viewModel.refreshCountries()
        wait(for: [expectation], timeout: 2.0)
    }
}

