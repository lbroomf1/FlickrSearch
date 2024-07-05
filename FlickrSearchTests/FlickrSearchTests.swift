//
//  FlickrSearchTests.swift
//  FlickrSearchTests
//
//  Created by LB on 7/3/24.
//

import XCTest
import Combine
@testable import FlickrSearch

final class FlickrSearchTests: XCTestCase {

    var viewModel: FlickrViewModel!
       var cancellable: AnyCancellable?
       
       override func setUp() {
           super.setUp()
           viewModel = FlickrViewModel(flickrService: MockFlickrService())
       }
       
       override func tearDown() {
           viewModel = nil 
           super.tearDown()
       }
       
       func testFetchPhotosWithMockData() {
           let expectation = self.expectation(description: "Fetch photos")
           
           viewModel.fetchPhotos(tags: "porcupine")
           
           DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
               XCTAssertEqual(self.viewModel.photos.count, 1, "There should be one photo")
               XCTAssertEqual(self.viewModel.photos.first?.title, "Porcupine Image", "The photo title should be 'Porcupine Image'")
               expectation.fulfill()
           }
           
           waitForExpectations(timeout: 2.0, handler: nil)
       }
   }
