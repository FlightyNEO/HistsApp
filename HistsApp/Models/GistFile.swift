//
//  GistFile.swift
//  HistsApp
//
//  Created by Arkadiy Grigoryanc on 31.07.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import Foundation

struct GistFile: Decodable {
    let fileName: String
    let type: String
    let language: String?
    let size: Int
        
    enum CodingKeys: String, CodingKey {
        case fileName = "filename"
        case type
        case language
        case size
    }
}
