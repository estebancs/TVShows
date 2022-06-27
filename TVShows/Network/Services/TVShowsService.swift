//
//  TVShowsService.swift
//  TVShows
//
//  Created by Esteban Chavarria on 26/6/22.
//

import Foundation

protocol TVShowsServicing {
    func show(page:Int) async -> Result<TVShows, HttpError>
    func showEpisodes(showId:Int) async -> Result<[Episode], HttpError>
    func searchShow(text:String) async -> Result<[SearchResult], HttpError>
}

struct TVShowsService: HttpClient, TVShowsServicing {
    func show(page: Int) async -> Result<TVShows, HttpError> {
        return await sendRequest(endpoint: TVShowsEndpoint.shows(page: page), responseModel: TVShows.self)
    }
    
    func showEpisodes(showId: Int) async -> Result<[Episode], HttpError> {
        return await sendRequest(endpoint: TVShowsEndpoint.episodes(showId: showId), responseModel: [Episode].self)
    }
    
    func searchShow(text: String) async -> Result<[SearchResult], HttpError> {
        return await sendRequest(endpoint: TVShowsEndpoint.searchShow(text: text), responseModel: [SearchResult].self)
    }
}
