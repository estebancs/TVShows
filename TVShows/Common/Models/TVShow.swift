//
//  TVShow.swift
//  TVShows
//
//  Created by Esteban Chavarria on 26/6/22.
//

import Foundation

struct TVShow: Codable, Hashable {
    let id: Int
    let name: String
    let image: ImageObject
    
    static func == (lhs: TVShow, rhs: TVShow) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
