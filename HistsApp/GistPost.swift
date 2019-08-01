//
//  GistPost.swift
//  HistsApp
//
//  Created by Arkadiy Grigoryanc on 31.07.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import Foundation

class GistPost: Encodable {
    private(set) var information: String?
    private(set) var files: [String: [String: String]]
    private(set) var isPublic: Bool
    
    init(information: String?, files: [String: String], isPublic: Bool) {
        self.information = information
        self.files = files.reduce(into: [String: [String: String]]()) {
            $0[$1.key] = ["content": $1.value]
        }
        self.isPublic = isPublic
    }
    
    enum CodingKeys: String, CodingKey {
        case information = "description"
        case files
        case isPublic = "public"
    }
}
