//
//  FlickrSearchAppUITests.swift
//  FlickrSearchAppUITests
//
//  Created by JL on 21/02/24.
//

import XCTest

final class FlickrSearchAppUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
        try super.tearDownWithError()
    }
    
    func testContentView_DisplayPhotoDetails() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.navigationBars["Flickr Photos"].exists)
        
        let firstCell = app.staticTexts.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10), "No cell found in the list")
        firstCell.tap()
        
        XCTAssertTrue(app.images.firstMatch.exists)
    }
}
