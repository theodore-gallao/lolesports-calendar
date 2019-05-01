//
//  MatchCollection.swift
//  lolesports-calendar
//
//  Created by Theodore Gallao on 4/11/19.
//  Copyright © 2019 Theodore Gallao. All rights reserved.
//

import Foundation

class MatchCollection {
    private(set) var dateModels    = [DateModel?]()
    private(set) var matchesByDate = [DateModel?: [Match]]()
    private(set) var matches       = [Match]()
    
    func append(_ match: Match) {
        let matchesByDate = Dictionary(grouping: [match]) { (current) -> DateModel? in
            if
                let beginAtStr = current.begin_at,
                let beginAt    = Date.from(formattedDate: beginAtStr, timezone: TimeZone.current)
            {
                let startOfDay = Calendar.current.startOfDay(for: beginAt)
                return DateModel(startOfDay)
            } else {
                return nil
            }
        }
        
        // Add to matchesByDate
        self.matchesByDate = self.matchesByDate.merging(matchesByDate, uniquingKeysWith: { (lhs, rhs) -> [Match] in
            return (lhs + rhs).sorted()
        })
        
        // Add to matches
        self.matches.append(match)
        self.matches.sort()
        
        // Add date to dateModels
        self.dateModels = self.matchesByDate.keys.sorted(by: { (lhs, rhs) -> Bool in
            if let left = lhs, let right = rhs {
                return left < right
            } else {
                return false
            }
        })
    }
    
    func append(contentsOf newMatches: [Match]) {
        let sortedMatches = newMatches.sorted()
        
        let matchesByDate = Dictionary(grouping: sortedMatches) { (current) -> DateModel? in
            if
                let beginAtStr = current.begin_at,
                let beginAt    = Date.from(formattedDate: beginAtStr, timezone: TimeZone.current)
            {
                let startOfDay = Calendar.current.startOfDay(for: beginAt)
                return DateModel(startOfDay)
            } else {
                return nil
            }
        }
        
        // Add to matchesByDate
        self.matchesByDate = self.matchesByDate.merging(matchesByDate, uniquingKeysWith: { (lhs, rhs) -> [Match] in
            return (lhs + rhs).sorted()
        })
        
        // Add to matches
        self.matches.append(contentsOf: newMatches)
        self.matches.sort()
        
        // Add date to dateModels
        self.dateModels = self.matchesByDate.keys.sorted(by: { (lhs, rhs) -> Bool in
            if let left = lhs, let right = rhs {
                return left < right
            } else {
                return false
            }
        })
    }
    
    func remove(match: Match) {
        // Remove from matches
        if let index = self.matches.firstIndex(of: match) {
            self.matches.remove(at: index)
        }
        
        // Remove from matches by date, date, and dates if necessary
        if
            let beginAtStr = match.begin_at,
            let beginAt    = Date.from(formattedDate: beginAtStr, timezone: TimeZone.current)
        {
            let startOfDay = Calendar.current.startOfDay(for: beginAt)
            let dateModel  = DateModel(startOfDay)
            
            // Remove from matchesByDate
            if
                var matches = self.matchesByDate[dateModel],
                let index   = matches.firstIndex(of: match)
            {
                matches.remove(at: index)
                
                self.matchesByDate[dateModel] = matches
                
                // If matches becomes empty, remove date as well
                if matches.isEmpty {
                    self.matchesByDate.removeValue(forKey: dateModel)
                    
                    if let dateIndex = self.dateModels.firstIndex(of: dateModel) {
                        self.dateModels.remove(at: dateIndex)
                    }
                }
            }
        }
    }
    
    func makeMatchCollection(leagueIds: [Int]) -> MatchCollection {
        let matches = self.matches.filter { (match) -> Bool in
            return leagueIds.contains(match.league_id)
        }
        
        let matchCollection = MatchCollection()
        matchCollection.append(contentsOf: matches)
        
        return matchCollection
    }
    
    func makeMatchCollection(matchIds: [Int]) -> MatchCollection {
        let matches = self.matches.filter { (match) -> Bool in
            return matchIds.contains(match.id)
        }
        
        let matchCollection = MatchCollection()
        matchCollection.append(contentsOf: matches)
        
        return matchCollection
    }
    
    func clear() {
        self.matchesByDate.removeAll()
        self.matches.removeAll()
        self.dateModels.removeAll()
    }
}
