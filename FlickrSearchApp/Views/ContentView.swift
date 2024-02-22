//
//  ContentView.swift
//  FlickrSearchApp
//
//  Created by JL on 21/02/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: SearchViewModel
    @State private var selection: Photo?
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
                    ForEach(viewModel.photos, id: \.id) { photo in
                        ReusableImage().photoDetailView(for: photo, selection: $selection)
                    }
                }
                .padding()
            }
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
            .refreshable {
                viewModel.searchPhotos(with: viewModel.searchText)
            }
            .overlay(
                ProgressView()
                    .opacity(viewModel.isLoading ? 1 : 0)
            )
            .navigationTitle(Constants.TitlesViews.titlePhoto)
        }
        .onAppear {
            viewModel.searchPhotos(with: viewModel.searchText)
        }
        .environment(\.sizeCategory, .accessibilityMedium)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SearchViewModel()
        return ContentView(viewModel: viewModel)
    }
}
