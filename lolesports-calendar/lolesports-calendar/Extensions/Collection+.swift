//
//  Collection+.swift
//  Foodbase
//
//  Created by Theodore Gallao on 3/3/19.
//  Copyright © 2019 Theodore Gallao. All rights reserved.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (optional index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
