//
//  CountriesViewControllerTests.swift
//  CountriesChallenge
//
//  Created by Rishitha Reddy on 4/24/25.
//

import XCTest
@testable import CountriesChallenge

final class MockViewModel: CountriesViewModel {
    var mockCountries: [Country] = []

    init(mockCountries: [Country] = []) {
        super.init()
        self.mockCountries = mockCountries
        countriesSubject.send(mockCountries)
    }

    func refreshCountries() async {
    
    }
}

final class CountriesViewControllerTests: XCTestCase {

    var viewController: CountriesViewController!
    var mockViewModel: MockViewModel!

    override func setUp() {
        super.setUp()

        mockViewModel = MockViewModel(mockCountries: [
            Country(
                capital: "Test City",
                code: "TL",
                currency: Currency(code: "USD", name: "Dollar", symbol: "$"),
                flag: "",
                language: Language(code: "E", name: "English"),
                name: "TestLand",
                region: "Test Region"
            )
        ])

        viewController = CountriesViewController(viewModel: mockViewModel)
        viewController.loadViewIfNeeded()
    }

    override func tearDown() {
        viewController = nil
        mockViewModel = nil
        super.tearDown()
    }

    func testTableViewNumberOfRowsMatchesCountries() {
        let tableView = viewController.view.subviews.compactMap { $0 as? UITableView }.first
        XCTAssertEqual(tableView?.numberOfRows(inSection: 0), 1, "TableView should have 1 row")
    }

    func testSearchFiltersResultsCorrectly() {
        let searchController = viewController.navigationItem.searchController!
        searchController.searchBar.text = "TestLand"
        viewController.updateSearchResults(for: searchController)

        let tableView = viewController.view.subviews.compactMap { $0 as? UITableView }.first
        let filteredRowCount = tableView?.numberOfRows(inSection: 0)

        XCTAssertEqual(filteredRowCount, 1, "Search should return 1 matching country")
    }


}
