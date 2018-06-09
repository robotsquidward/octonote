//
//  GistPost.swift
//  octonotes
//
//  Created by AJ Kueterman on 6/8/18.
//  Copyright © 2018 Base11 Studios. All rights reserved.
//

import Foundation

struct GistPost: Encodable {
    
    let description: String
    let isPublic: Bool
    let gist: Gist
    
    init(description: String, isPublic: Bool, fileName: String, contents: String) {
        self.description = description
        self.isPublic = isPublic
        self.gist = Gist(fileName: fileName, contents: contents)
    }
    
    private enum CodingKeys: String, CodingKey {
        case description = "description"
        case isPublic = "public"
        case gist = "files"
    }
    
}
