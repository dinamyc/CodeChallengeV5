//
//  SearchViewModel.swift
//  FlickrSearchApp
//
//  Created by JL on 21/02/24.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var photos: [Photo] = []
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    private let apiService = APIService()
    
    init() {
        $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                self?.searchPhotos(with: text)
            }
            .store(in: &cancellables)
    }
    
    func searchPhotos(with query: String) {
        isLoading = true
        let url = buildURL(with: query)

        APIService.request(url: url) { [weak self] (result: Result<FlickrResponse, APIError>) in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let flickrResponse):
                    self?.photos = flickrResponse.items
                case .failure(let error):
                    print("Error searching photos: \(error)")
                }
            }
        }
    }
    
    public func buildURL(with query: String) -> URL {
        let urlString = "\(Constants.API.flickrBaseURL)?format=json&nojsoncallback=1&tags=\(query)"
        return URL(string: urlString)!
    }
}
