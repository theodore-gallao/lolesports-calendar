//
//  LOLEsportsAPI.swift
//  lolesports-calendar
//
//  Created by Theodore Gallao on 3/24/19.
//  Copyright © 2019 Theodore Gallao. All rights reserved.
//

import Foundation
import FirebaseFunctions

class LolEsportsService {
    private let functions        : Functions
    private var matchCollection  : MatchCollection
    private var series           : [Int: Serie]
    
    private static let MAX_PAGES: Int = 10
    private var pastMatchesPage: Int = 1
    private var upcomingMatchesPage: Int = 1
    
    public init (functions       : Functions           = Functions.functions(),
                 matchCollection : MatchCollection     = MatchCollection(),
                 series          : [Int: Serie]        = [:],
                 tournaments     : [Int: [Tournament]] = [:])
    {
        self.functions       = functions
        self.matchCollection = matchCollection
        self.series          = series
    }
    
    /// Get matches in the given leagues, at the given date.
    public func getMatches(shouldReload: Bool, completion: @escaping (Result<MatchCollection, RequestError>) -> Void) {
        if shouldReload {
            self.matchCollection.clear()
        } else {
            completion(.success(self.matchCollection))
            return
        }
        
        self.pastMatchesPage = 1 // Reset
        self.upcomingMatchesPage = 1 // Reset
        
        let allLeagueIds = League.leagues.leagues.map { $0.id }
        
        let data: [String: Any] = [
            "league_ids": allLeagueIds
        ]
        
        self.functions.httpsCallable("getAllMatches").call(data) { (result, error) in
            if let error = error {
                completion(.failure(RequestError.invalidRequest(error.localizedDescription)))
                return
            }
            
            guard
                let resultData = result?.data,
                let data = try? JSONSerialization.data(withJSONObject: resultData, options: JSONSerialization.WritingOptions.prettyPrinted),
                let matches = try? JSONDecoder().decode([[Match]].self, from: data) else
            {
                
                completion(.failure(RequestError.noData("Unable to read matches from data.")))
                return
            }
            self.matchCollection.clear()
            self.matchCollection.append(contentsOf: matches.flatMap { $0 })
            completion(.success(self.matchCollection))
            return
        }
    }
    
    public func getMorePastMatches(completion: @escaping (Result<MatchCollection, RequestError>) -> Void) {
        if self.pastMatchesPage >= LolEsportsService.MAX_PAGES {
            completion(.failure(RequestError.pastMatchesPageLimitReached))
            return
        }
        
        self.pastMatchesPage = min(LolEsportsService.MAX_PAGES, (self.pastMatchesPage + 1)) // Increment
        
        let allLeagueIds = League.leagues.leagues.map { $0.id }
        
        let data: [String: Any] = [
            "league_ids": allLeagueIds,
            "page_number": self.pastMatchesPage
        ]
        
        
        self.functions.httpsCallable("getPastMatches").call(data) { (result, error) in
            if let error = error {
                completion(.failure(RequestError.invalidRequest(error.localizedDescription)))
                return
            }
            
            guard
                let resultData = result?.data,
                let data = try? JSONSerialization.data(withJSONObject: resultData, options: JSONSerialization.WritingOptions.prettyPrinted),
                let matches = try? JSONDecoder().decode([Match].self, from: data) else
            {
                completion(.failure(RequestError.noData("Unable to read matches from data.")))
                return
            }
            
            self.matchCollection.append(contentsOf: matches)
            completion(.success(self.matchCollection))
            
            return
        }
    }
    
    public func getMoreUpcomingMatches(completion: @escaping (Result<MatchCollection, RequestError>) -> Void) {
        if self.upcomingMatchesPage >= LolEsportsService.MAX_PAGES {
            completion(.failure(RequestError.upcomingMatchesPageLimitReached))
            return
        }
        
        self.upcomingMatchesPage = min(LolEsportsService.MAX_PAGES, (self.upcomingMatchesPage + 1)) // Increment
        
        let allLeagueIds = League.leagues.leagues.map { $0.id }
        
        let data: [String: Any] = [
            "league_ids": allLeagueIds,
            "page_number": self.upcomingMatchesPage
        ]
        
        self.functions.httpsCallable("getUpcomingMatches").call(data) { (result, error) in
            if let error = error {
                completion(.failure(RequestError.invalidRequest(error.localizedDescription)))
                return
            }
            
            guard
                let resultData = result?.data,
                let data = try? JSONSerialization.data(withJSONObject: resultData, options: JSONSerialization.WritingOptions.prettyPrinted),
                let matches = try? JSONDecoder().decode([Match].self, from: data) else
            {
                completion(.failure(RequestError.noData("Unable to read matches from data.")))
                return
            }
            
            // If empty, return empty and set page to 5, preventing future calls
            if matches.isEmpty {
                completion(.failure(RequestError.noUpcomingMatches))
                self.upcomingMatchesPage = 5
                return
            }
            
            self.matchCollection.append(contentsOf: matches)
            completion(.success(self.matchCollection))
            return
        }
    }
}
