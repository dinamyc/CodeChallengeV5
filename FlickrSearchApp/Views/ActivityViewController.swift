//
//  ActivityViewController.swift
//  FlickrSearchApp
//
//  Created by JL on 21/02/24.
//

import SwiftUI

struct ActivityViewController: UIViewControllerRepresentable {
    let items: [Any]
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { _, _, _, _ in
            isPresented = false // Dismiss the view controller when sharing is completed
        }
        return activityViewController
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Update the view controller if needed
    }
}
