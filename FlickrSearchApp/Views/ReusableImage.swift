//
//  ReusableImage.swift
//  FlickrSearchApp
//
//  Created by JL on 21/02/24.
//

import SwiftUI

struct ReusableImage {
    @ViewBuilder
    func retriveImage(for phase: AsyncImagePhase) -> some View {
        switch phase {
        case .empty:
            ProgressView()
        case .success(let image):
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150) // Adjust size as needed
                .cornerRadius(10)
        case .failure:
            Image(systemName: "photo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150) // Adjust size as needed
                .cornerRadius(10)
                .foregroundColor(.gray)
        @unknown default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    func asyncImageView(with url: URL?) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .cornerRadius(10)
            case .failure:
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .cornerRadius(10)
                    .foregroundColor(.gray)
            @unknown default:
                EmptyView()
            }
        }
    }
    
    @ViewBuilder
    func photoDetailView(for photo: Photo, selection: Binding<Photo?>) -> some View {
        if let selectedPhoto = selection.wrappedValue, selectedPhoto == photo {
            PhotoView(photo: photo)
                .onTapGesture {
                    selection.wrappedValue = nil
                }
                .fullScreenCover(item: selection) { selectedPhoto in
                    DetailView(photo: selectedPhoto)
                }
        } else {
            PhotoView(photo: photo)
                .onTapGesture {
                    selection.wrappedValue = photo
                }
        }
    }
}
