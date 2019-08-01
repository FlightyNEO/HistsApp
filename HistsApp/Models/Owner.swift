//
//  Owner.swift
//  HistsApp
//
//  Created by Arkadiy Grigoryanc on 31.07.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import Foundation

struct Owner: Decodable {
    let login: String
    let avatarStringUrl: String
    
    var dataImage: Data?
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarStringUrl = "avatar_url"
    }
}

