//
//  TVShowsViewController.swift
//  TVShows
//
//  Created by Esteban Chavarria on 26/6/22.
//

import UIKit
import Resolver

class TVShowsViewController: UIViewController {
    static let cellWidth = UIScreen.width/3-10
    enum Section {
        case all
    }
    
    @Injected var service: TVShowsServicing
    
    lazy var tvShows = TVShows()
    lazy var dataSource = configureDataSource()
    
    var pageNumber = 0
    
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
        tabBarItem.title = "TV Shows"
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
                var snapshot = NSDiffableDataSourceSnapshot<Section, TVShow>()
                self.tvShows.append(contentsOf: newTvShows)
                snapshot.appendSections([.all])
                snapshot.appendItems(self.tvShows, toSection: .all)
                self.dataSource.apply(snapshot, animatingDifferences: true)
            case .failure(let error):
                print("error: \(error.errorMessage)")
            }
        }
    }
    
    
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
        let tvShowInfo = tvShows[indexPath.row]
        let detailViewController = TVShowDetailViewController(tvShowDetail: tvShowInfo)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}




