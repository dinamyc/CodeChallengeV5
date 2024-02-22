//
//  FlickrSearchAppApp.swift
//  FlickrSearchApp
//
//  Created by JL on 21/02/24.
//

import SwiftUI

@main
struct FlickrSearchAppApp: App {
    @StateObject var viewModel = SearchViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
