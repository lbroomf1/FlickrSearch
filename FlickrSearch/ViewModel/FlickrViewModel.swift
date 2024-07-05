//
//  FlickrViewModel.swift
//  FlickrSearch
//
//  Created by LB on 7/3/24.
//

import Foundation
import Combine

import Foundation
import Combine

class FlickrViewModel: ObservableObject {
    @Published var photos: [FlickrPhoto] = []
    @Published var isLoading = false
    private var cancellable: AnyCancellable?
    private let flickrService: FlickrServiceProtocol
    
    init(flickrService: FlickrServiceProtocol = FlickrService()) {
        self.flickrService = flickrService
    }
    
   
    func fetchPhotos(tags: String) {
        isLoading = true 
        
        cancellable = flickrService.fetchPhotos(tags: tags)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    print("Error fetching photos: \(error.localizedDescription)")
                }
                self?.isLoading = false
            }, receiveValue: { [weak self] response in
                self?.photos = response.items
            })
    }
}
