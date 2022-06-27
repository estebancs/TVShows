//
//  Schedule.swift
//  TVShows
//
//  Created by Esteban Chavarria on 26/6/22.
//

import Foundation

struct Schedule: Codable {
    let time: String
    let days: [String]
    
    var scheduleTime: String {
        let daysFormatted = days.map {
            "\($0)"
        }.joined(separator:", ")
        return "\(daysFormatted) at \(time)"
    }
}
