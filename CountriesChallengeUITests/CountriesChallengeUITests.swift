//
//  CountriesChallengeUITests.swift
//  CountriesChallengeUITests
//

import XCTest

final class CountriesChallengeUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testCountriesListLoads() {
        let table = app.tables.element(boundBy: 0)
        let exists = NSPredicate(format: "exists == true")

        expectation(for: exists, evaluatedWith: table, handler: nil)
        waitForExpectations(timeout: 10)
        XCTAssertTrue(table.exists, "Countries list table should exist")
    }

    func testCountryDetailScreenOpens() {
        let firstCell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10), "First country cell should appear")

        firstCell.tap()

        let detailLabel = app.staticTexts.element(boundBy: 0)
        XCTAssertTrue(detailLabel.exists, "Detail screen should appear after tapping a country")
    }

    func testSearchFunctionality() {
        let searchField = app.searchFields.firstMatch

        XCTContext.runActivity(named: "Dump UI Hierarchy") { _ in
            print(app.debugDescription)
        }

        XCTAssertTrue(searchField.waitForExistence(timeout: 30), "Search field should exist")

        searchField.tap()
        searchField.typeText("Kabul")

        let filteredCell = app.tables.cells.staticTexts["Kabul"]
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: filteredCell, handler: nil)
        waitForExpectations(timeout: 10)
        XCTAssertTrue(filteredCell.exists, "Search should filter and show 'Kabul'")
    }

    func testPullToRefresh() {
        let table = app.tables.element(boundBy: 0)
        XCTAssertTrue(table.waitForExistence(timeout: 10), "Table should exist")

        let start = table.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0))
        let finish = table.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 6))
        start.press(forDuration: 0.1, thenDragTo: finish)

        XCTAssertTrue(table.exists, "Table should remain after pull to refresh")
    }

    func testSearchNoResults() {
        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.waitForExistence(timeout: 10), "Search field should exist")

        searchField.tap()
        searchField.typeText("Rishitha\n")

        let cellCount = app.tables.cells.count
        XCTAssertEqual(cellCount, 0, "Search should return 0 results for invalid input")
    }

    func testCancelSearchRestoresList() {
        let table = app.tables.element(boundBy: 0)
        let originalCount = table.cells.count

        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.waitForExistence(timeout: 10))

        searchField.tap()
        searchField.typeText("Canada")

        if app.buttons["Cancel"].exists {
            app.buttons["Cancel"].tap()
        }

        let newCount = table.cells.count
        XCTAssertEqual(originalCount, newCount, "Canceling search should restore full list")
    }
}
