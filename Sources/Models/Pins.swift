//
//  Pins.swift
//
//
//  Created by Michael Karagiorgos on 4/8/24.
//

import Foundation

struct Pins: Codable {
    let pins: [Pin]
}

extension Pins {
    struct Pin: Codable {
        let identity: String?
    }
}
