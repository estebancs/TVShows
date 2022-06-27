//
//  TVShowsEndPoint.swift
//  TVShows
//
//  Created by Esteban Chavarria on 26/6/22.
//

enum TVShowsEndpoint {
    case shows(page: Int)
    case episodes(showId: Int)
    case searchShow(text: String)
}

extension TVShowsEndpoint: Endpoint {
    var method: HttpMethod {
        switch self {
        case .shows, .episodes, .searchShow:
            return .get
        }
    }
    
    var header: [String : String]? {
        switch self {
        case .shows, .episodes, .searchShow:
            return [
                "Content-Type": "application/json;charset=utf-8"
            ]
        }
    }
    
    var body: [String : String]? {
        switch self {
        case .shows, .episodes, .searchShow:
            return nil
        }
    }
    
    var path: String {
        switch self {
        case .shows(let page):
            return "shows?page=\(page)"
        case .episodes(let showId):
            return "shows/\(showId)/episodes"
        case .searchShow(let text):
            return "search/shows?q=\(text)"
        }
    }
}

