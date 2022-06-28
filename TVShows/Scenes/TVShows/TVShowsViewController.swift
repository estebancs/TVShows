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
    
    /// List of tvShows to show
    lazy var tvShows = TVShows()
    
    /// List of tvShows to show if filtering with search bar
    lazy var filteredTVShows = TVShows()
    
    /// Diffable datasource
    lazy var dataSource = configureDataSource()
    
    /// Pagination number for requesting more episodes
    var pageNumber = 0
    
    @Injected var viewModel: TVShowsViewModeling
    
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
        viewModel.fetchTvShows()
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
        
        viewModel.output = self
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
}

// MARK: - UICollectionViewDataSourcePrefetching
extension TVShowsViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let lastItem = indexPaths.last?.row else { return }
        if lastItem == tvShows.count-1 {
//            updateSnapshot(page: pageNumber, animatingChange: true)
            viewModel.fetchTvShows()
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
        viewModel.searchTvShow(text: searchText)
    }
}

// MARK: - TVShowsViewOutput
extension TVShowsViewController: TVShowsViewOutput {
    func fetchedTvShows(tvShows: TVShows) {
        self.tvShows.append(contentsOf: tvShows)
        self.applySnapshot()
    }
    
    func foundSerchedTvShows(tvShows: TVShows) {
        self.filteredTVShows = tvShows
        self.applySnapshot()
    }
}
