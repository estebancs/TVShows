//
//  HTTPError.swift
//  TVShows
//
//  Created by Esteban Chavarria on 26/6/22.
//

enum HttpError: Error {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown
    
    var errorMessage: String {
        switch self {
        case .decode:
            return "Decoding error"
        default:
            return "Unknown error"
        }
    }
}
