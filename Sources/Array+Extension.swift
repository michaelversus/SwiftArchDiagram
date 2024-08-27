//
//  Array+Extension.swift
//  
//
//  Created by Michael Karagiorgos on 4/8/24.
//

import Foundation

extension Array {
    func removeDuplicates() -> Self {
        let orderedSet = NSOrderedSet(array: self)
        return orderedSet.compactMap { $0 as? Element }
    }
}
