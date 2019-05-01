//
//  Tournament.swift
//  lolesports-calendar
//
//  Created by Theodore Gallao on 3/26/19.
//  Copyright © 2019 Theodore Gallao. All rights reserved.
//

import Foundation

struct Tournament: Codable {
    var id:        Int
    var serie_id:  Int
    var league_id: Int
    var name:      String
}

