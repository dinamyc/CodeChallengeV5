//
//  PhotoView.swift
//  FlickrSearchApp
//
//  Created by JL on 21/02/24.
//

import SwiftUI

struct PhotoView: View {
    let photo: Photo
    
    var body: some View {
        VStack(alignment: .leading) {
            
            AsyncImage(url: URL(string: photo.media.m.absoluteString)) { phase in
                ReusableImage().retriveImage(for: phase)
            }
            .accessibility(label: Text("Photo"))
        }
    }
}
