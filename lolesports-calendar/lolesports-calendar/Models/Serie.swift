//
//  Series.swift
//  lolesports-calendar
//
//  Created by Theodore Gallao on 4/2/19.
//  Copyright © 2019 Theodore Gallao. All rights reserved.
//

import Foundation

struct Serie: Codable {
    var id:          Int
    var league_id:   Int
    var description: String?
    var full_name:   String
    var season:      String?
    var begin_at:    String?
    var end_at:      String?
    
    var tournaments: [Tournament]?
}
