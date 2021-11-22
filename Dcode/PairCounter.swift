//
//  PairCounter.swift
//  Dcode
//
//  Created by Philipp on 21.11.21.
//

import Foundation

struct PairCounter: Comparable {
    let letters: Substring
    let segments: ArraySlice<String>

    static func <(lhs: PairCounter, rhs: PairCounter) -> Bool {
        if lhs.segments.count == rhs.segments.count {
            return lhs.letters < rhs.letters
        } else {
            return lhs.segments.count > rhs.segments.count
        }
    }
}
