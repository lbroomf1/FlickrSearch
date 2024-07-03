//
//  FlickrSearchTests.swift
//  FlickrSearchTests
//
//  Created by LB on 7/3/24.
//

import XCTest
@testable import FlickrSearch

final class FlickrSearchTests: XCTestCase {

    var viewModel: FlickrViewModel!
        
        override func setUp() {
            super.setUp()
            viewModel = FlickrViewModel() // Initialize ViewModel before each test
        }
        
        override func tearDown() {
            viewModel = nil // Deinitialize ViewModel after each test
            super.tearDown()
        }
        
        func testFetchPhotos() {
            let expectation = self.expectation(description: "Fetch photos")
            
            viewModel.fetchPhotos(tags: "turtle")
            
            // Wait for the photos to be fetched
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                XCTAssertFalse(self.viewModel.photos.isEmpty, "Photos should not be empty") // Check that photos are fetched
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 6.0, handler: nil) // Wait for the expectation to be fulfilled
        }
}
