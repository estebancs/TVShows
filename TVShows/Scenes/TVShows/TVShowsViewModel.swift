//
//  TVShowsViewModel.swift
//  TVShows
//
//  Created by Esteban Chavarria on 26/6/22.
//

import Combine
import Resolver

class TVShowsViewModel {
    @Injected var service: TVShowsServicing
    
    private let getTVShowsTrigger = PassthroughSubject<Void, Never>()
    
    // MARK: - Input

    private(set) lazy var input = {
        Input(getTVShows: getTVShowsTrigger)
    }()
    
    // MARK: - Output

    private(set) lazy var output: Output = {
        let episodesDataSource = PassthroughSubject<TVShows, Never>().eraseToAnyPublisher()
        return Output(tvShowsDataSource: episodesDataSource)
    }()
    
    
    /// Fecths the list of tv shows
    /// - Parameters:
    ///   - completion: completion block after getting results
    func fetchTvShows(page: Int, completion: @escaping (Result<TVShows, HttpError>) -> Void) {
        Task(priority: .background) {
            let result = await service.show(page: page)
            completion(result)
        }
    }
    
}

extension TVShowsViewModel {
    struct Input {
        let getTVShows: PassthroughSubject<Void, Never>
    }
    struct Output {
        let tvShowsDataSource: AnyPublisher<TVShows, Never>
    }
}
