//
//  RequestError.swift
//  lolesports-calendar
//
//  Created by Theodore Gallao on 3/26/19.
//  Copyright © 2019 Theodore Gallao. All rights reserved.
//

import Foundation

public enum RequestError: Error {
    case invalidRequest(String)
    case invalidURL(URL)
    case noData(String)
    
    case pastMatchesPageLimitReached
    case runningMatchesPageLimitReached
    case upcomingMatchesPageLimitReached
    
    case noUpcomingMatches
}
