//
//  TVShowsViewController.swift
//  TVShows
//
//  Created by Esteban Chavarria on 26/6/22.
//

import UIKit
import Resolver

class TVShowsViewController: UIViewController {
    /// cell width based on Screen width
    static let cellWidth = UIScreen.width/3-10
    
    /// Section of the collection view, using DiffableDataSource
    enum Section {
        case all
    }
    
    /// Network service being inject by IoC
    @Injected var service: TVShowsServicing
    
    /// List of tvShows to show
    lazy var tvShows = TVShows()
    
    /// List of tvShows to show if filtering with search bar
    lazy var filteredTVShows = TVShows()
    
    /// Diffable datasource
    lazy var dataSource = configureDataSource()
    
    /// Pagination number for requesting more episodes
    var pageNumber = 0
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    /// flag to veirfy is we are filtering
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    /// Collection configured to use flow layout
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: TVShowsViewController.cellWidth, height: TVShowsViewController.cellWidth*1.5)
        layout.estimatedItemSize = .zero
        layout.minimumInteritemSpacing = 5
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.contentInset = .init(top: 5, left:5, bottom: 5, right: 5)
        collectionView.register(TVShowCollectionViewCell.self, forCellWithReuseIdentifier: TVShowCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        updateSnapshot(page: 0, animatingChange: false)
    }
    
}

private extension TVShowsViewController {
    
    /// Configures the child view of the view controller
    func setupViews() {
        tabBarItem.title = String(localized: "TVShows")
        tabBarItem.image = UIImage(systemName: "film")
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        collectionView.dataSource = dataSource
        collectionView.prefetchDataSource = self
        collectionView.delegate = self
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = String(localized: "SearchTVShows")
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    /// Configures the collectionview datasource
    /// - Returns:
    ///   - The collectionview diffable data source
    func configureDataSource() -> UICollectionViewDiffableDataSource<Section, TVShow> {
        let dataSource = UICollectionViewDiffableDataSource<Section, TVShow>(collectionView: collectionView) { (collectionView, indexPath, tvShow) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TVShowCollectionViewCell.reuseIdentifier, for: indexPath) as? TVShowCollectionViewCell else {return UICollectionViewCell()}
            cell.configure(tvShow: tvShow)
            return cell
        }
        return dataSource
    }
    
    /// Updates the datasource snapshot
    /// - Parameters:
    ///   - animatingChange: to set diffable animation
    func updateSnapshot(page:Int, animatingChange: Bool = false) {
        // Create a snapshot and populate the data
        fetchTvShows(page: page) { [weak self] result in
            switch result {
            case .success(let newTvShows):
                guard let `self` = self else { return }
                self.pageNumber += 1
                self.tvShows.append(contentsOf: newTvShows)
                self.applySnapshot()
            case .failure(let error):
                print("error: \(error.errorMessage)")
            }
        }
    }
    
    /// Updates the datasource snapshot
    /// - Parameters:
    ///   - animatingChange: to set diffable animation
    func searchForShowAndApplySnapshot(text:String, animatingChange: Bool = false) {
        // Create a snapshot and populate the data
        searchTvShows(text: text) { [weak self] result in
            switch result {
            case .success(let searchResult):
                guard let `self` = self else { return }
                self.pageNumber += 1
                self.filteredTVShows = searchResult.map{$0.show}
                self.applySnapshot()
            case .failure(let error):
                print("error: \(error.errorMessage)")
            }
        }
    }
    
    /// Applies snapshot to collection view depending on isFiltering flag
    /// - Parameters:
    ///     - animatingDifferences: animate changes
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, TVShow>()
        snapshot.appendSections([.all])
        if isFiltering {
            snapshot.appendItems(self.filteredTVShows, toSection: .all)
        } else {
            snapshot.appendItems(self.tvShows, toSection: .all)
        }
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    
    /// Fecths the list of tv shows
    /// - Parameters:
    ///     - page: Pagination number
    ///     - completion: completion block after getting results
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

// MARK: - UICollectionViewDataSourcePrefetching
extension TVShowsViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let lastItem = indexPaths.last?.row else { return }
        if lastItem == tvShows.count-1 {
            updateSnapshot(page: pageNumber, animatingChange: true)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension TVShowsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var tvShowInfo = tvShows[indexPath.row]
        if isFiltering {
            tvShowInfo = filteredTVShows[indexPath.row]
        }
        
        let detailViewController = TVShowDetailViewController(tvShowDetail: tvShowInfo)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - UISearchResultsUpdating
extension TVShowsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    /// Filter the tv Shows based on the text provided
    /// - Parameters:
    ///     - searchText: Text to search
    func filterContentForSearchText(_ searchText: String) {
//        filteredTVShows = tvShows.filter { (tvShow: TVShow) -> Bool in
//            return tvShow.name.lowercased().contains(searchText.lowercased())
//        }
//        applySnapshot()
        searchForShowAndApplySnapshot(text: searchText, animatingChange: true)
    }
}
