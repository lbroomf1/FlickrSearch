//
//  FlickrViewModel.swift
//  FlickrSearch
//
//  Created by LB on 7/3/24.
//

import Foundation
import Combine

class FlickrViewModel: ObservableObject {
    @Published var photos: [FlickrPhoto] = []
    @Published var isLoading = false
    private var cancellable: AnyCancellable?
    
    func fetchPhotos(tags: String) {
        guard !tags.isEmpty else {
            photos = []
            return
        }
        
        let urlString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(tags)"
        guard let url = URL(string: urlString) else { return }
        
        isLoading = true
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: FlickrResponse.self, decoder: JSONDecoder())
            .replaceError(with: FlickrResponse(items: []))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.photos = $0.items
                self?.isLoading = false
            }
    }
}
