//
//  Gist.swift
//  octonotes
//
//  Created by AJ Kueterman on 6/8/18.
//  Copyright © 2018 Base11 Studios. All rights reserved.
//

import Foundation

struct Gist: Encodable {
    
    let fileName: String
    let content: String
    
    init(fileName: String, content: String) {
        self.fileName = fileName
        self.content = content
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: GistKey.self)
        
        // Any product's `name` can be used as a key name.
        let nameKey = GistKey(stringValue: self.fileName)!
        var gistContainer = container.nestedContainer(keyedBy: GistKey.self, forKey: nameKey)
        
        // The rest of the keys use static names defined in `ProductKey`.
        try gistContainer.encode(self.content, forKey: GistKey.content!)
    }
}
