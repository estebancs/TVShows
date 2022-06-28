//
//  TVShowsViewModel.swift
//  TVShows
//
//  Created by Esteban Chavarria on 26/6/22.
//

import Combine
import Resolver

protocol TVShowsViewModeling {
    var output: TVShowsViewOutput { get set}
    func fetchTvShows()
    func searchTvShow(text: String)
}

protocol TVShowsViewOutput: AnyObject {
    func fetchedTvShows(tvShows: TVShows)
    func foundSerchedTvShows(tvShows: TVShows)
}

class TVShowsViewModel {
    @Injected var service: TVShowsServicing
    
    weak var _output: TVShowsViewOutput?
    
    var pageNumber = 0
    
    /// Fecths the list of tv shows
    /// - Parameters:
    ///   - completion: completion block after getting results
    func fetchTvShows(page: Int, completion: @escaping (Result<TVShows, HttpError>) -> Void) {
        Task(priority: .background) {
            let result = await service.show(page: page)
            completion(result)
        }
    }
    
    /// Search for tv shows based in a string
    /// - Parameters:
    ///     - text: searching text
    ///     - completion: completion block after getting results
    func searchTvShows(text: String, completion: @escaping (Result<[SearchResult], HttpError>) -> Void) {
        Task(priority: .background) {
            let result = await service.searchShow(text: text)
            completion(result)
        }
    }
    
}

extension TVShowsViewModel: TVShowsViewModeling {
    var output: TVShowsViewOutput {
        get {
            return _output!
        }
        set {
            _output = newValue
        }
    }
    
    
    /// Calls the  service to browse the tv series and returns the result
    func fetchTvShows() {
        fetchTvShows(page: pageNumber) { [weak self] result in
            switch result {
            case .success(let newTvShows):
                guard let `self` = self else { return }
                self.pageNumber += 1
                DispatchQueue.main.async {
                    self._output?.fetchedTvShows(tvShows: newTvShows)
                }
            case .failure(let error):
                print("error: \(error.errorMessage)")
            }
        }
    }
    
    
    /// Calls the search service and returns tv shows
    /// - Parameters:
    ///   - text: text to search
    func searchTvShow(text: String) {
        searchTvShows(text: text) { [weak self] result in
            switch result {
            case .success(let searchResult):
                guard let `self` = self else { return }
                let filteredTVShows = searchResult.map{$0.show}
                DispatchQueue.main.async {
                    self._output?.foundSerchedTvShows(tvShows: filteredTVShows)
                }
            case .failure(let error):
                print("error: \(error.errorMessage)")
            }
        }
    }
}
