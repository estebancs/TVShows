//
//  TVShowsViewController.swift
//  TVShows
//
//  Created by Esteban Chavarria on 26/6/22.
//

import UIKit
import Resolver

class TVShowsViewController: UIViewController {

    enum Section {
        case all
    }
    
    @Injected var service: TVShowsServicing
    
    lazy var tvShows = TVShows()
    lazy var dataSource = configureDataSource()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 150)
        layout.estimatedItemSize = .zero
        layout.minimumInteritemSpacing = 5
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.contentInset = .init(top: 5, left:5, bottom: 5, right: 5)
        collectionView.register(TVShowCollectionViewCell.self, forCellWithReuseIdentifier: TVShowCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        updateSnapshot()
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
    }
    
    /// Configures the collectionview datasource
    /// - Returns:
    ///   - The collectionview diffable data source
    func configureDataSource() -> UICollectionViewDiffableDataSource<Section, TVShow> {
        let dataSource = UICollectionViewDiffableDataSource<Section, TVShow>(collectionView: collectionView) { (collectionView, indexPath, tvShow) -> UICollectionViewCell? in
     
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TVShowCollectionViewCell.reuseIdentifier, for: indexPath) as! TVShowCollectionViewCell
            cell.configure(tvShow: tvShow)
            return cell
        }
        return dataSource
    }
    
    /// Updates the datasource snapshot
    /// - Parameters:
    ///   - animatingChange: to set diffable animation
    func updateSnapshot(animatingChange: Bool = false) {
        // Create a snapshot and populate the data
        var snapshot = NSDiffableDataSourceSnapshot<Section, TVShow>()
        snapshot.appendSections([.all])
        fetchTvShows { [weak self] result in
            switch result {
            case .success(let tvShows):
                var snapshot = NSDiffableDataSourceSnapshot<Section, TVShow>()
                snapshot.appendSections([.all])
                snapshot.appendItems(tvShows, toSection: .all)
                self?.dataSource.apply(snapshot, animatingDifferences: false)
            case .failure(let error):
                print("error: \(error.errorMessage)")
            }
        }
    }
    
    /// Fecths the list of tv shows
    /// - Parameters:
    ///   - completion: completion block after getting results
    func fetchTvShows(completion: @escaping (Result<TVShows, HttpError>) -> Void) {
        Task(priority: .background) {
            let result = await service.show()
            completion(result)
        }
    }
    
}
