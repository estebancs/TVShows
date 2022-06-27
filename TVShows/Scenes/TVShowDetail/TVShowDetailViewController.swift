//
//  TVShowDetailViewController.swift
//  TVShows
//
//  Created by Esteban Chavarria on 26/6/22.
//

import UIKit
import Resolver

class TVShowDetailViewController: UIViewController {
    @Injected var service: TVShowsServicing
    
    private static let cellReuseIdentifier = "TVShowDetailViewControllerCellId"
    private var tvShowDetail: TVShow
    
    private var episodes = [Episode]()
    
    var episodesBySeason:  [Int : [Episode]] {
        return Dictionary(grouping: episodes) {
            $0.season
        }
    }
    
    private lazy var headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var stackViewInfo: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var scheduleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var genresLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var summaryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var episodesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Episodes"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        return v
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: TVShowDetailViewController.cellReuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    init(tvShowDetail: TVShow) {
        self.tvShowDetail = tvShowDetail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        showDetailInfo(tvShow: tvShowDetail)
        getEpisodes()
    }
    
}

private extension TVShowDetailViewController {
    
    /// Configures the child view of the view controller
    func setupViews() {
        self.view.addSubview(scrollView)
        let safeLayoutGuide = view.safeAreaLayoutGuide
        let contentLayoutGuide = scrollView.contentLayoutGuide
        
        
        view.backgroundColor = .white
        scrollView.addSubview(headerImageView)
        scrollView.addSubview(stackViewInfo)
        scrollView.addSubview(summaryLabel)
        scrollView.addSubview(episodesLabel)
        scrollView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor, constant: 8.0),
            scrollView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor, constant: 8.0),
            scrollView.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor, constant: -8.0),
            scrollView.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor, constant: -10.0),
            
            headerImageView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor, constant: 16.0),
            headerImageView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor, constant: 16.0),
            
            stackViewInfo.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor, constant: 20.0),
            stackViewInfo.leadingAnchor.constraint(equalTo: headerImageView.trailingAnchor, constant: 10.0),
            stackViewInfo.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor, constant: -10.0),
            
            summaryLabel.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 20.0),
            summaryLabel.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor, constant: 10.0),
            summaryLabel.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor, constant: -10.0),
            
            episodesLabel.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 10.0),
            episodesLabel.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor, constant: 10.0),
            episodesLabel.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor, constant: -10.0),
            
            tableView.topAnchor.constraint(equalTo: episodesLabel.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor, constant: 10.0),
            tableView.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor, constant: -10.0),
            tableView.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor, constant: -16.0),
            
            
            //                    headerImageView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor, constant: -16.0),
        ])
        
        
        stackViewInfo.addArrangedSubview(nameLabel)
        stackViewInfo.addArrangedSubview(UIView())
        stackViewInfo.addArrangedSubview(attributeLabel(text: "Scheduled:"))
        stackViewInfo.addArrangedSubview(scheduleLabel)
        stackViewInfo.addArrangedSubview(UIView())
        stackViewInfo.addArrangedSubview(attributeLabel(text: "Genres:"))
        stackViewInfo.addArrangedSubview(genresLabel)
        
    }
    
    func showDetailInfo(tvShow: TVShow) {
        guard let placeHolder = UIImage(named: "MoviePlaceHolder") else { return }
        headerImageView.sd_setImage(with: tvShow.image.medium, placeholderImage: placeHolder)
        nameLabel.text = tvShow.name
        scheduleLabel.text = tvShow.schedule.scheduleTime
        genresLabel.text = tvShow.genresFormatted
        summaryLabel.attributedText = tvShow.summary.htmlToAttributedString
        tableView.reloadData()
    }
    
    /// Fecths the list of episodes
    /// - Parameters:
    ///   - completion: completion block after getting results
    func fetchEpisodes(showId: Int, completion: @escaping (Result<[Episode], HttpError>) -> Void) {
        Task(priority: .background) {
            let result = await service.showEpisodes(showId: showId)
            completion(result)
        }
    }
    
    func getEpisodes() {
        fetchEpisodes(showId: tvShowDetail.id) { [weak self] result in
            switch result {
            case .success(let fetchedEpisodes):
                guard let `self` = self else { return }
                self.episodes.append(contentsOf: fetchedEpisodes)
                self.tableView.reloadData()
            case .failure(let error):
                print("error: \(error.errorMessage)")
            }
        }
    }
    
    func attributeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}


extension TVShowDetailViewController: UITableViewDelegate {
    
}

extension TVShowDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let season = episodesBySeason[section+1] else { return 0 }
        return season.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return episodesBySeason.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Season \(section+1)"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TVShowDetailViewController.cellReuseIdentifier, for: indexPath)
        guard let episodeInfo = episodesBySeason[indexPath.section+1]?[indexPath.row] else { return UITableViewCell() }
        cell.textLabel?.text = episodeInfo.name
        return cell
    }
    
}
