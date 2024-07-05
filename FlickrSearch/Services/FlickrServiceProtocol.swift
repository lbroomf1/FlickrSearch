//
//  FlickrService.swift
//  FlickrSearch
//
//  Created by LB on 7/5/24.
//

import Foundation
import Combine

protocol FlickrServiceProtocol {
    func fetchPhotos(tags: String) -> AnyPublisher<FlickrResponse, Error>
}

class FlickrService: FlickrServiceProtocol {
    func fetchPhotos(tags: String) -> AnyPublisher<FlickrResponse, Error> {
        guard !tags.isEmpty else {
            return Just(FlickrResponse(items: []))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        let urlString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(tags)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: FlickrResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
