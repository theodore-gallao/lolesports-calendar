//
//  Match.swift
//  lolesports-calendar
//
//  Created by Theodore Gallao on 3/26/19.
//  Copyright © 2019 Theodore Gallao. All rights reserved.
//

import Foundation
import UIKit

struct Match: Codable {
    private enum CodingKeys: CodingKey {
        case id
        case begin_at
        case status
        case number_of_games
        case match_type
        case winner_id
        case results
        case opponents
        case league_id
        case serie_id
        case serie
        case tournament_id
        case tournament
    }
    
    // Codable members
    let id:              Int
    let begin_at:        String?
    let status:          Status
    let number_of_games: Int?
    let match_type:      String?
    let winner_id:       Int?
    let results:         [ResultData]?
    let opponents:       [Opponent]?
    let league_id:       Int
    let serie_id:        Int
    let serie:           Serie?
    let tournament_id:   Int
    let tournament:      Tournament?
    
    // Non-codable members
    // These should be stored, not computed. Faster
    private(set) var hourText: String            = "TBD"
    private(set) var hourTextColor: UIColor      = UIColor.black
    private(set) var meridiemText: String        = ""
    private(set) var meridiemTextColor: UIColor  = UIColor.black
    private(set) var team0FullNameText: String   = "TBD"
    private(set) var team0NameText: String       = "TBD"
    private(set) var team0NameTextColor: UIColor = UIColor.black
    private(set) var team0ImageUrl: URL?         = nil
    private(set) var team0ImageAlpha: CGFloat    = 1
    private(set) var team1FullNameText: String   = "TBD"
    private(set) var team1NameText: String       = "TBD"
    private(set) var team1NameTextColor: UIColor = UIColor.black
    private(set) var team1ImageUrl: URL?         = nil
    private(set) var team1ImageAlpha: CGFloat    = 1
    private(set) var scoresText: String          = ""
    private(set) var versusText: String          = ""
    private(set) var winnerStatus: Int           = -1
    private(set) var winnerImage: UIImage?       = nil
    private(set) var leagueText: String          = ""
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id              = try  container.decode(Int.self,          forKey: .id)
        //print("called 0")
        self.status          = try  container.decode(Status.self,       forKey: .status)
        //print("called 1")
        self.number_of_games = try?  container.decode(Int.self,         forKey: .number_of_games)
        //print("called 2")
        self.match_type      = try?  container.decode(String.self,      forKey: .match_type)
        //print("called 3")
        self.winner_id       = try? container.decode(Int.self,          forKey: .winner_id)
        //print("called 4")
        self.results         = try? container.decode([ResultData].self, forKey: .results)
        //print("called 5")
        self.opponents       = try? container.decode([Opponent].self,   forKey: .opponents)
        //print("called 6")
        self.league_id       = try  container.decode(Int.self,          forKey: .league_id)
        //print("called 7")
        self.serie_id        = try  container.decode(Int.self,          forKey: .serie_id)
        //print("called 8")
        self.serie           = try? container.decode(Serie.self,        forKey: .serie)
        //print("called 9")
        self.tournament_id   = try  container.decode(Int.self,          forKey: .tournament_id)
        //print("called 10")
        self.tournament      = try? container.decode(Tournament.self,   forKey: .tournament)
        //print("called 11")
        
        // Configure date
        let begin_at       = try  container.decode(String.self, forKey: .begin_at)
        let utcTimeZone    = TimeZone(abbreviation: "UTC")!
        let date           = Date.from(formattedDate: begin_at, timezone: utcTimeZone)!
        let convertedDate  = date.convertToTimeZone(initTimeZone: utcTimeZone, timeZone: TimeZone.current)
        
        self.begin_at = convertedDate.formatted!
        
        self.updateValues()
    }
    
    private mutating func updateValues() {
        //  Configure team 0 name
        if
            let opponents = self.opponents,
            let team0 = opponents[optional: 0],
            let team0FullName = team0.opponent?.name,
            let team0Acronym = team0.opponent?.acronym
        {
            self.team0FullNameText = team0FullName
            self.team0NameText = team0Acronym.uppercased()
        } else {
            self.team0NameText = "TBD"
        }
        
        // Configure team 1 name
        if
            let opponents = self.opponents,
            let team1 = opponents[optional: 1],
            let team1FullName = team1.opponent?.name,
            let team1Acronym = team1.opponent?.acronym
        {
            self.team1FullNameText = team1FullName
            self.team1NameText = team1Acronym.uppercased()
        } else {
            self.team1NameText = "TBD"
        }
        
        // Configure scores
        var team0Score = 0
        var team1Score = 0
        
        // Configure team 0 scores
        if
            let opponents = self.opponents,
            let team0Id   = opponents[optional: 0]?.opponent?.id,
            let results   = self.results
        {
            for result in results {
                if
                    let id    = result.team_id,
                    let score = result.score,
                    team0Id   == id
                {
                    team0Score = score
                    break
                }
            }
        }
        
        // Configure team 1 scores
        if
            let opponents = self.opponents,
            let team1Id   = opponents[optional: 1]?.opponent?.id,
            let results   = self.results
        {
            for result in results {
                if
                    let id = result.team_id,
                    let score = result.score,
                    team1Id == id
                {
                    team1Score = score
                    break
                }
            }
        }
        
        self.scoresText = "\(team0Score)-\(team1Score)"
        
        // Configure winner
        if
            let opponents = self.opponents,
            let team0Id = opponents[optional: 0]?.opponent?.id,
            let team1Id = opponents[optional: 1]?.opponent?.id,
            let winnerId = self.winner_id
        {
            if winnerId == team0Id {
                self.winnerStatus = 0
                self.winnerImage = UIImage(named: "Left Arrow")?
                    .resize(to: CGSize(width: 64, height: 64))?
                    .withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                
                self.team0ImageAlpha = 1
                self.team0NameTextColor = UIColor.Flat.Red.alizarin
                
                self.team1ImageAlpha = 0.3
                self.team1NameTextColor = UIColor.LOLEsports.Gray.lightGray
            } else if winnerId == team1Id {
                self.winnerStatus = 1
                self.winnerImage = UIImage(named: "Right Arrow")?
                    .resize(to: CGSize(width: 64, height: 64))?
                    .withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                
                self.team0ImageAlpha = 0.3
                self.team0NameTextColor = UIColor.LOLEsports.Gray.lightGray
                
                self.team1ImageAlpha = 1
                self.team1NameTextColor = UIColor.Flat.Red.alizarin
            } else {
                self.winnerStatus = -1
                self.winnerImage = nil
                
                self.team0ImageAlpha = 1
                self.team0NameTextColor = UIColor.Flat.Red.alizarin
                
                self.team1ImageAlpha = 1
                self.team1NameTextColor = UIColor.Flat.Red.alizarin
            }
        } else {
            self.team0ImageAlpha = 1
            self.team0NameTextColor = UIColor.black
            
            self.team1ImageAlpha = 1
            self.team1NameTextColor = UIColor.black
            
            self.winnerStatus = -1
            self.winnerImage = nil
        }
        
        // Configure status
        if self.status == .not_started {
            self.versusText        = "VS"
            self.hourTextColor     = UIColor.black
            self.meridiemTextColor = UIColor.black
            self.scoresText        = ""
        } else if self.status == .running {
            self.versusText        = ""
            self.hourTextColor     = UIColor.black
            self.meridiemTextColor = UIColor.black
        } else {
            self.versusText        = ""
            self.hourTextColor     = UIColor.LOLEsports.Gray.lightGray
            self.meridiemTextColor = UIColor.LOLEsports.Gray.lightGray
        }
        
        // Configure time
        if
            let beginAtStr = self.begin_at,
            let beginAt = Date.from(formattedDate: beginAtStr, timezone: .current)
        {
            let beginAt = beginAt.rounded(minutes: 30, rounding: DateRoundingType.round)
            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: beginAt)
            if
                let hour = dateComponents.hour,
                let minute = dateComponents.minute
            {
                let hourStr: String
                let minuteStr = minute == 0 ? "" : String(format: "%02d", minute) + " "
                let meridiemStr: String
                if hour == 0 {
                    hourStr = "\(hour + 12)"
                    meridiemStr = "\(minuteStr)AM"
                } else if hour > 12 {
                    hourStr = "\(hour - 12)"
                    meridiemStr = "\(minuteStr)PM"
                } else if hour == 12 {
                    hourStr = "\(hour)"
                    meridiemStr = "\(minuteStr)PM"
                } else {
                    hourStr = "\(hour)"
                    meridiemStr = "\(minuteStr)AM"
                }
                
                self.hourText = hourStr
                self.meridiemText = meridiemStr
            } else {
                self.hourText = "TBD"
                self.meridiemText = ""
            }
        } else {
            self.hourText = "TBD"
            self.meridiemText = ""
        }
        
        // Configure leagues
        if
            let league = League.leagues.leagues.first(where: { $0.id == self.league_id })
        {
            self.leagueText = league.name.uppercased()
        } else {
            self.leagueText = ""
        }
        
        // Configure team image urls
        if let opponents = self.opponents {
            if let team0 = opponents[optional: 0] {
                self.team0ImageUrl = team0.opponent?.image_url
            } else {
                self.team0ImageUrl = nil
            }
            
            if let team1 = opponents[optional: 1] {
                self.team1ImageUrl = team1.opponent?.image_url
            } else {
                self.team1ImageUrl = nil
            }
        }
    }
}

extension Match: Equatable, Comparable, Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    static func < (lhs: Match, rhs: Match) -> Bool {
        if
            let lhsBeginAt = lhs.begin_at,
            let rhsBeginAt = rhs.begin_at,
            let utc        = TimeZone(abbreviation: "UTC"),
            let lhsDate    = Date.from(formattedDate: lhsBeginAt, timezone: utc),
            let rhsDate    = Date.from(formattedDate: rhsBeginAt, timezone: utc)
        {
            if lhsDate != rhsDate {
                return lhsDate < rhsDate
            }
        }
        
        return lhs.id < rhs.id
    }
    
    static func == (lhs: Match, rhs: Match) -> Bool {
        return lhs.id == rhs.id
    }
}
