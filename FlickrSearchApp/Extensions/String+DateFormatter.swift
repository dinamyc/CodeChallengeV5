//
//  String+DateFormatter.swift
//  FlickrSearchApp
//
//  Created by JL on 21/02/24.
//

import Foundation

extension String {
    func formattedDate() -> String? {
        let dateFormatter = ISO8601DateFormatter()
        guard let date = dateFormatter.date(from: self) else {
            return nil
        }
        
        let calendar = Calendar(identifier: .gregorian)
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        let monthSymbols = DateFormatter().monthSymbols
        let monthString = monthSymbols![month - 1]
        
        return "\(day) de \(monthString) \(year)"
    }
    
    func stringByRemovingHTMLTags() -> String {
        let regex = try! NSRegularExpression(pattern: "<[^>]+>")
        let range = NSRange(self.startIndex..<self.endIndex, in: self)
        return regex.stringByReplacingMatches(in: self, range: range, withTemplate: "")
    }
}
