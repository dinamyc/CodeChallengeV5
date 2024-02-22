//
//  DetailView.swift
//  FlickrSearchApp
//
//  Created by JL on 21/02/24.
//

import SwiftUI

struct DetailView: View {
    
    private var imageSize: (width: String, height: String) {
        let photoInfo = ["description": photo.description]
        return photo.imageSizeFromDescription(photoInfo)
    }
    
    @Environment(\.presentationMode) var presentationMode
    @State private var isPresentingActivityViewController = false
    let photo: Photo
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                            .font(.title)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                Text(Constants.TitlesViews.titleDetail)
                    .font(.title)
                    .fontWeight(.bold)
                    .accessibility(hidden: true)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 5) {
                    
                    ReusableImage().asyncImageView(with: URL(string: photo.media.m.absoluteString))
                        .frame(maxWidth: .infinity, maxHeight: 300)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .accessibility(label: Text("Photo"))
                    
                    Text(photo.title)
                        .font(.title2)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                        .accessibility(label: Text("\(Constants.DetailViewTitles.titleDetail) \(photo.title)"))
                    
                    Text(photo.author)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                        .accessibility(label: Text("\(Constants.DetailViewTitles.authorDetail) \(photo.author)"))
                    
                    Text(photo.publishedDate.formattedDate() ?? "")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                        .accessibility(label: Text("\(Constants.DetailViewTitles.publishedDateDetail) \(photo.publishedDate.formattedDate() ?? "")"))
                    
                    Text(photo.description.stringByRemovingHTMLTags())
                        .font(.body)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                        .accessibility(label: Text("\(Constants.DetailViewTitles.descriptionDetail) \(photo.description.stringByRemovingHTMLTags())"))
                    HStack {
                        Text("\(Constants.DetailViewTitles.imageDetailWidht)")
                        Text(imageSize.width)
                    }
                    HStack {
                        Text("\(Constants.DetailViewTitles.imageDetailHeight)")
                        Text(imageSize.height)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 2)
                .padding()
                
                VStack(alignment: .center) {
                    Button(action: {
                        isPresentingActivityViewController.toggle()
                    }) {
                        Text(Constants.DetailViewTitles.shareTitleButton)
                            .font(.headline)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .accessibility(label: Text("Share this photo"))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .sheet(isPresented: $isPresentingActivityViewController, content: {
                // Present the share sheet when the button is tapped
                ActivityViewController(items: [UIImage(named: "your_image") as Any, "Title: \(photo.title)\nAuthor: \(photo.author)\nDate: \(photo.publishedDate)\nDescription: \(photo.description)"], isPresented: $isPresentingActivityViewController)
            })
            .accessibility(label: Text("Share this photo"))
        }
    }
}
