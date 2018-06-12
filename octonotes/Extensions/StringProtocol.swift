//
//  StringProtocol.swift
//  octonotes
//
//  Created by AJ Kueterman on 6/7/18.
//  Copyright © 2018 Base11 Studios. All rights reserved.
//

import Foundation

extension StringProtocol where Index == String.Index {
    func nsRange(from range: Range<Index>) -> NSRange {
        return NSRange(range, in: self)
    }
}
