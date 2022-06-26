//
//  EndPoint.swift
//  TVShows
//
//  Created by Esteban Chavarria on 26/6/22.
//

import Foundation
protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HttpMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
}

extension Endpoint {
    var baseURL: String {
        return "https://api.tvmaze.com/"
    }
}
