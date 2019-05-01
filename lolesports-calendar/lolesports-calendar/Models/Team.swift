//
//  Team.swift
//  lolesports-calendar
//
//  Created by Theodore Gallao on 3/26/19.
//  Copyright © 2019 Theodore Gallao. All rights reserved.
//

import Foundation

struct Team: Codable {
    var id:        Int
    var name:      String
    var acronym:   String
    var image_url: URL?
}
