//
//  Leagues.swift
//  lolesports-calendar
//
//  Created by Theodore Gallao on 3/24/19.
//  Copyright © 2019 Theodore Gallao. All rights reserved.
//
/*
 Optional(4213)  -  Optional(LVP SLO)
 Optional(4199)  -  Optional(LLA)
 Optional(4198)  -  Optional(LCS)
 Optional(4197)  -  Optional(LEC)
 Optional(4180)  -  Optional(GPL)
 Optional(4143)  -  Optional(Rift Rivals: LCL vs. TCL vs. VCS)
 Optional(4142)  -  Optional(Challenger Korea)
 Optional(4141)  -  Optional(VCS)
 Optional(4140)  -  Optional(Demacia Cup)
 Optional(4139)  -  Optional(European Masters)
 Optional(4104)  -  Optional(NA Academy)
 Optional(4100)  -  Optional(Torneo de Pre-Copa)
 Optional(4097)  -  Optional(Rift Rivals: LCK vs. LPL vs. LMS)
 Optional(4096)  -  Optional(NA Scouting Grounds)
 Optional(4004)  -  Optional(LCL)
 Optional(2711)  -  Optional(KeSPA Cup)
 Optional(2133)  -  Optional(Rift Rivals: CB vs. CLS vs. LLN)
 Optional(2132)  -  Optional(Rift Rivals: LCL vs. TCL)
 Optional(2108)  -  Optional(Rift Rivals: GPL vs. LJL vs. OPL)
 Optional(2107)  -  Optional(Rift Rivals NA vs. EU)
 Optional(2092)  -  Optional(LJL)
 Optional(2063)  -  Optional(League of Origin)
 Optional(1089)  -  Optional(Turkey Challenger Series)
 Optional(1077)  -  Optional(CDLN)
 Optional(1003)  -  Optional(TCL)
 Optional(1002)  -  Optional(Liga Latinoamerica Norte)
 Optional(878)  -  Optional(Intel Extreme Masters)
 Optional(666)  -  Optional(Challenge France)
 Optional(527)  -  Optional(CDLS)
 Optional(305)  -  Optional(Copa Latinoamérica Norte)
 Optional(302)  -  Optional(CBLOL)
 Optional(301)  -  Optional(OPL)
 Optional(300)  -  Optional(Mid-Season-Invitational)
 Optional(299)  -  Optional(International Wildcard)
 Optional(298)  -  Optional(Copa Latinoamérica Sur)
 Optional(297)  -  Optional(World Championship)
 Optional(296)  -  Optional(All-Star)
 Optional(295)  -  Optional(LMS)
 Optional(294)  -  Optional(LPL)
 Optional(293)  -  Optional(LCK)
 Optional(292)  -  Optional(EU Challenger Series)
 Optional(291)  -  Optional(NA Challenger Series)
 Optional(290)  -  Optional(EU LCS)
 Optional(289)  -  Optional(NA LCS)
 */

import Foundation
import UIKit

struct League: Equatable {
    
    static func ==(lhs: League, rhs: League) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id:         Int
    let name:       String
    let fullName:   String
    let regionName: String
    let imageName:  String
    let image:      UIImage
    
    static let LCS = League(id:         4198,
                            name:       "LCS",
                            fullName:   "LoL Championship Series",
                            regionName: "North America",
                            imageName:  "LCS")
    
    static let LCSA = League(id:         4104,
                             name:       "LCSA",
                             fullName:   "LoL Championship Series Academy",
                             regionName: "North America",
                             imageName:  "LCSA")
    
    static let LEC = League(id:         4197,
                            name:       "LEC",
                            fullName:   "LoL European Championship",
                            regionName: "Europe",
                            imageName:  "LEC")
    static let EUM = League(id:         4139,
                            name:       "EUM",
                            fullName:   "European Masters",
                            regionName: "Europe",
                            imageName:  "EUM")
    
    static let LCK = League(id:         293,
                            name:       "LCK",
                            fullName:   "League Champions Korea",
                            regionName: "South Korea",
                            imageName:  "LCK")
    
    static let KeSPA = League(id:         2711,
                              name:       "KeSPA",
                              fullName:   "Korea Esports Association Cup",
                              regionName: "South Korea",
                              imageName:  "KeSPA")
    
    static let LPL = League(id:         294,
                            name:       "LPL",
                            fullName:   "LoL Pro League",
                            regionName: "China",
                            imageName:  "LPL")
    
    static let LMS = League(id:         295,
                            name:       "LMS",
                            fullName:   "League Master Series",
                            regionName: "Taiwan",
                            imageName:  "LMS")
    
    static let CBLOL = League(id:         302,
                              name:       "CBLOL",
                              fullName:   "Champions Brazil LoL",
                              regionName: "Brazil",
                              imageName:  "CBLOL")
    
    static let LCL = League(id:         4004,
                            name:       "LCL",
                            fullName:   "LoL Continental League",
                            regionName: "Russia",
                            imageName:  "LCL")
    
    static let LJL = League(id:         2092,
                            name:       "LJL",
                            fullName:   "LoL Japan League",
                            regionName: "Japan",
                            imageName:  "LJL")
    
    static let LLA = League(id:         4199,
                            name:       "LLA",
                            fullName:   "League Latin America",
                            regionName: "Latin America",
                            imageName:  "LLA")
    
    static let OPL = League(id:         301,
                            name:       "OPL",
                            fullName:   "Oceanic Pro League",
                            regionName: "Oceania",
                            imageName:  "OPL")
    
    static let TCL = League(id:         1003,
                            name:       "TCL",
                            fullName:   "Turkish Champions League",
                            regionName: "Turkey",
                            imageName:  "TCL")
    
    static let VCS = League(id:         4141,
                            name:       "VCS",
                            fullName:   "Vietnam Championship Series",
                            regionName: "Vietnam",
                            imageName:  "VCS")
    
    static let Worlds = League(id:         297,
                               name:       "Worlds",
                               fullName:   "World Championship",
                               regionName: "International",
                               imageName:  "Worlds")
    
    static let MSI = League(id:         300,
                            name:       "MSI",
                            fullName:   "Mid-Season Invitaional",
                            regionName: "International",
                            imageName:  "MSI")
    
    static let AllStar = League(id:         296,
                                name:       "All-Star",
                                fullName:   "All-Star International Event",
                                regionName: "International",
                                imageName:  "All-Star")
    
    static let RR_LCS_LEC = League(id:         2107,
                                   name:       "Rift Rivals",
                                   fullName:   "Rift Rivals, LCS - LEC",
                                   regionName: "LCS - LEC",
                                   imageName:  "RR-LCS-LEC")
    
    static let RR_LCK_LPL_LMS = League(id:         4097,
                                       name:       "Rift Rivals",
                                       fullName:   "Rift Rivals, LCK - LPL - LMS",
                                       regionName: "LCK - LPL - LMS",
                                       imageName:  "RR-LCK-LPL-LMS")
    
    static let RR_LCL_TCL_VCS = League(id:         4143,
                                       name:       "Rift Rivals",
                                       fullName:   "Rift Rivals, LCL - TCL - VCS",
                                       regionName: "LCL - TCL - VCS",
                                       imageName:  "RR-LCL-TCL-VCS")
    
    static let RR_CBLOL_CLS_LLN = League(id:         2133,
                                         name:       "Rift Rivals",
                                         fullName:   "Rift Rivals, CBLOL - CLS - LLN",
                                         regionName: "CBLOL - CLS - LLN",
                                         imageName:  "RR-CBLOL-CLS-LLN")
    
    static let RR_SEA_LJL_OPL = League(id:         2108,
                                       name:       "Rift Rivals",
                                       fullName:   "Rift Rivals, SEA - LJL - OPL",
                                       regionName: "SEA - LJL - OPL",
                                       imageName:  "RR-SEA-LJL-OPL")
    
    static let leagues = LeagueCollection(name: "Leagues", leagues: [
        League.LCS,
        League.LCSA,
        League.LEC,
        League.EUM,
        League.LCK,
        League.KeSPA,
        League.LPL,
        League.LMS,
        League.CBLOL,
        League.LCL,
        League.LJL,
        League.LLA,
        League.OPL,
        League.TCL,
        League.VCS,
        League.Worlds,
        League.MSI,
        League.AllStar,
        League.RR_LCS_LEC,
        League.RR_LCK_LPL_LMS,
        League.RR_LCL_TCL_VCS,
        League.RR_CBLOL_CLS_LLN,
        League.RR_SEA_LJL_OPL
    ])
    
    static let regional = LeagueCollection(name: "Regional", leagues: [
        League.LCS,
        League.LEC,
        League.LCK,
        League.LPL,
        League.LMS,
        League.CBLOL,
        League.LCL,
        League.LJL,
        League.LLA,
        League.OPL,
        League.TCL,
        League.VCS,
    ])
    
    static let international = LeagueCollection(name: "International", leagues: [
        League.Worlds,
        League.MSI,
        League.AllStar,
        League.RR_LCS_LEC,
        League.RR_LCK_LPL_LMS,
        League.RR_LCL_TCL_VCS,
        League.RR_CBLOL_CLS_LLN,
        League.RR_SEA_LJL_OPL
    ])
    
    static let other = LeagueCollection(name: "Other", leagues: [
        League.LCSA,
        League.EUM,
        League.KeSPA,
    ])
    
    init(id:         Int,
         name:       String,
         fullName:   String,
         regionName: String,
         imageName:  String)
    {
        self.id         = id
        self.name       = name
        self.fullName   = fullName
        self.regionName = regionName
        self.imageName  = imageName
        self.image      =  UIImage(named: imageName)!.resize(to: CGSize(width: 128, height: 128))!
    }
}

struct LeagueCollection {
    let name: String
    let leagues: [League]
}
