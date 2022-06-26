//
//  TVShowsEndPoint.swift
//  TVShows
//
//  Created by Esteban Chavarria on 26/6/22.
//

enum TVShowsEndpoint {
    case shows(page: Int)
}

extension TVShowsEndpoint: Endpoint {
    var method: HttpMethod {
        switch self {
        case .shows:
            return .get
        }
    }
    
    var header: [String : String]? {
        switch self {
        case .shows:
            return [
                "Content-Type": "application/json;charset=utf-8"
            ]
        }
    }
    
    var body: [String : String]? {
        switch self {
        case .shows:
            return nil
        }
    }
    
    var path: String {
        switch self {
        case .shows(let page):
            return "shows?page=\(page)"
        }
    }
}

