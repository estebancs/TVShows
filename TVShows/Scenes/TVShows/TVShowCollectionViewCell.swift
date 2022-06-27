//
//  TVShowCollectionViewCell.swift
//  TVShows
//
//  Created by Esteban Chavarria on 26/6/22.
//

import UIKit
import SDWebImage

class TVShowCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "TVShowCollectionViewCell"

    let tvShowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()


    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addViews()
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews(){
        backgroundColor = .black

        addSubview(tvShowImageView)
        addSubview(nameLabel)


        tvShowImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tvShowImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tvShowImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tvShowImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30).isActive = true

        nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5.0).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5.0).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5.0).isActive = true
    }
    
    func configure(tvShow:TVShow) {
        nameLabel.text = tvShow.name
        guard let placeHolder = UIImage(named: "MoviePlaceHolder"), let image = tvShow.image?.medium  else { return }
        tvShowImageView.sd_setImage(with: image, placeholderImage: placeHolder)
    }
}
