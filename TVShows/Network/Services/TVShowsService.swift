//
//  TVShowsService.swift
//  TVShows
//
//  Created by Esteban Chavarria on 26/6/22.
//

import Foundation

protocol TVShowsServicing {
    func show(page:Int) async -> Result<TVShows, HttpError>
}

struct TVShowsService: HttpClient, TVShowsServicing {
    func show(page: Int) async -> Result<TVShows, HttpError> {
        return await sendRequest(endpoint: TVShowsEndpoint.shows(page: page), responseModel: TVShows.self)
    }
}
