//
//  Gist.swift
//  HistsApp
//
//  Created by Arkadiy Grigoryanc on 31.07.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import Foundation

typealias Gists = [Gist]

//enum GistType: CaseIterable {
//    case `private`
//    case `public`
//}

enum GistType {
    case `public`
    case `private`
    case all
}

class Gist: Decodable {
    private let createdDate: String
    let countOfComments: Int
    let information: String?
    let files: [String: GistFile]
    var owner: Owner
    let isPublic: Bool
    
    enum CodingKeys: String, CodingKey {
        case createdDate = "created_at"
        case countOfComments = "comments"
        case information = "description"
        case owner
        case files
        case isPublic = "public"
    }
}

extension Gist {
    var date: Date {
        var stringDate = createdDate
        let index = stringDate.firstIndex(of: "T")
        stringDate.replaceSubrange(index!...index!, with: " ")
        stringDate.removeLast()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD HH:mm:ss"
        return dateFormatter.date(from: stringDate)!
    }
    
    var shrotDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: date)
    }
    
}

extension Gist: CustomStringConvertible {
    var description: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let date = dateFormatter.string(from: self.date)
        return "date: \(date), owner: \(owner.login), count of comments: \(countOfComments), description: \(information ?? "nil")"
    }
}

extension Gist: Comparable {
    static func < (lhs: Gist, rhs: Gist) -> Bool {
        lhs.date.timeIntervalSince1970 < rhs.date.timeIntervalSince1970
    }
    
    static func == (lhs: Gist, rhs: Gist) -> Bool {
        lhs.date.timeIntervalSince1970 == rhs.date.timeIntervalSince1970
    }
}
