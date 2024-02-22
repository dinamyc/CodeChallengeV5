//
//  Photo.swift
//  FlickrSearchApp
//
//  Created by JL on 21/02/24.
//

import Foundation

struct Photo: Identifiable, Codable, Equatable {
    let id = UUID()
    let title: String
    let description: String
    let author: String
    let publishedDate: String
    let media: Media
    
    private enum CodingKeys: String, CodingKey {
        case title, description, author, publishedDate = "published", media
    }
}

struct Media: Codable, Equatable{
    let m: URL
}

struct FlickrResponse: Codable, Equatable {
    let items: [Photo]

    enum CodingKeys: String, CodingKey {
        case items
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(items, forKey: .items)
    }
}

extension Photo {
    func imageSizeFromDescription(_ item: [String: Any]) -> (width: String, height: String) {
        guard let description = item["description"] as? String else {
            return ("N/A", "N/A")
        }
        
        let components = description.components(separatedBy: " ")
        guard components.count >= 12 else {
            return ("N/A", "N/A")
        }
        
        let width = components[11]
        let height = components[13]
        return (width, height)
    }
}
