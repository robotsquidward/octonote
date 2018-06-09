//
//  GistKey.swift
//  octonotes
//
//  Created by AJ Kueterman on 6/8/18.
//  Copyright © 2018 Base11 Studios. All rights reserved.
//

import Foundation

struct GistKey: CodingKey {
    var stringValue: String
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    var intValue: Int? { return nil }
    init?(intValue: Int) { return nil }
    
    static let contents = GistKey(stringValue: "contents")
}
