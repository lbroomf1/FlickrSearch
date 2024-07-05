//
//  MockFlickrSearchService.swift
//  FlickrSearch
//
//  Created by LB on 7/5/24.
//

import Foundation
import Combine

class MockFlickrService: FlickrServiceProtocol {
    func fetchPhotos(tags: String) -> AnyPublisher<FlickrResponse, Error> {
        let mockJSON = """
        {
            "items": [
                {
                    "title": "Porcupine Image",
                    "media": { "m": "https://example.com/porcupine.jpg" },
                    "description": "A photo of a porcupine",
                    "author_id": "author1",
                    "published": "2023-01-01T00:00:00Z"
                }
            ]
        }
        """.data(using: .utf8)!
        
        let mockResponse = try! JSONDecoder().decode(FlickrResponse.self, from: mockJSON)
        return Just(mockResponse)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
