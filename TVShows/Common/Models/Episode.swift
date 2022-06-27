//
//  Episode.swift
//  TVShows
//
//  Created by Esteban Chavarria on 26/6/22.
//

import Foundation
struct Episode: Codable {
    let id: Int
    let name: String
    let season: Int
    let number: Int
    let image: ImageObject?
    let summary: String?
}
