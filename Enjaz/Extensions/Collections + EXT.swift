//
//  Collections + EXT.swift
//  Enjaz
//
//  Created by mohammed balegh on 31/01/2022.
//

import Foundation

extension RangeReplaceableCollection where Indices: Equatable {
    mutating func rearrange(from: Index, to: Index) {
        precondition(from != to && indices.contains(from) && indices.contains(to), "invalid indices")
        insert(remove(at: from), at: to)
    }
}
