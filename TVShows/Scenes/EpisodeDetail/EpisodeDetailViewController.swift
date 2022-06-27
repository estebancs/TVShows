//
//  EpisodeDetailViewController.swift
//  TVShows
//
//  Created by Esteban Chavarria on 26/6/22.
//

import UIKit

class EpisodeDetailViewController: UIViewController {
    private static let padding: CGFloat = 16.0
    
    private var episode: Episode
    
    private lazy var headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var stackViewInfo: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
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
    
    private lazy var episodeNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var seasonNumberLabel: UILabel = {
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
    
    
    private lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        return v
    }()
    
   
    init(episodeDetail: Episode) {
        self.episode = episodeDetail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        showDetailInfo(episode: episode)
    }
    
}

private extension EpisodeDetailViewController {
    
    /// Configures the child view of the view controller
    func setupViews() {
        self.view.addSubview(scrollView)
        let safeLayoutGuide = view.safeAreaLayoutGuide
        let contentLayoutGuide = scrollView.contentLayoutGuide
        
        
        view.backgroundColor = .white
        scrollView.addSubview(headerImageView)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(stackViewInfo)
        scrollView.addSubview(summaryLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor, constant: EpisodeDetailViewController.padding),
            scrollView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor, constant: EpisodeDetailViewController.padding),
            scrollView.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor, constant: -EpisodeDetailViewController.padding),
            scrollView.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor, constant: -EpisodeDetailViewController.padding),
            
            headerImageView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor, constant: EpisodeDetailViewController.padding),
            headerImageView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor, constant: EpisodeDetailViewController.padding),
            headerImageView.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor, constant: -EpisodeDetailViewController.padding),
            headerImageView.heightAnchor.constraint(equalToConstant: UIScreen.width/2),
            
            nameLabel.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: EpisodeDetailViewController.padding),
            nameLabel.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor, constant: EpisodeDetailViewController.padding),
            nameLabel.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor, constant: -EpisodeDetailViewController.padding),
            
            stackViewInfo.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: EpisodeDetailViewController.padding),
            stackViewInfo.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor, constant: EpisodeDetailViewController.padding),
            stackViewInfo.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor, constant: -EpisodeDetailViewController.padding),
            
            summaryLabel.topAnchor.constraint(equalTo: stackViewInfo.bottomAnchor, constant: EpisodeDetailViewController.padding),
            summaryLabel.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor, constant: EpisodeDetailViewController.padding),
            summaryLabel.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor, constant: -EpisodeDetailViewController.padding),
            
            summaryLabel.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor, constant: -EpisodeDetailViewController.padding),
        ])
        
        stackViewInfo.addArrangedSubview(attributeLabel(text: String(localized: "Season")))
        stackViewInfo.addArrangedSubview(seasonNumberLabel)
        stackViewInfo.addArrangedSubview(attributeLabel(text: String(localized: "Episode")))
        stackViewInfo.addArrangedSubview(episodeNumberLabel)
    }
    
    func showDetailInfo(episode: Episode) {
        guard let placeHolder = UIImage(named: "MoviePlaceHolder") else { return }
        headerImageView.sd_setImage(with: episode.image.original, placeholderImage: placeHolder)
        nameLabel.text = episode.name
        episodeNumberLabel.text = "\(episode.number)"
        seasonNumberLabel.text = "\(episode.season)"
        summaryLabel.attributedText = episode.summary.htmlToAttributedString
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
