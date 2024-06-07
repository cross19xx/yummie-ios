//
//  OnboardingCollectionViewCell.swift
//  Yummie
//
//  Created by Kenneth Kwakye-Gyamfi on 06/06/2024.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    static let identifer = String(describing: OnboardingCollectionViewCell.self)
    
    private lazy var illustration: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)

        return label
    }()
    
    private lazy var content: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    public func configure(with slide: OnboardingSlide) {
        illustration.image = slide.image
        title.text = slide.title
        content.text = slide.description
    }
    
    /**
     * Add subviews and constraints to the items in the cell.
     *
     * Since we know there are three items to be added, we'll be adopting the approach of centering
     * the middle item (title) first, and placing items relative to the middle item
     */
    private func setupViews() {
        contentView.addSubview(title)
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        contentView.addSubview(illustration)
        let screenBounds = UIScreen.main.bounds
        let imageSize = screenBounds.width * (2 / 3)
        NSLayoutConstraint.activate([
            illustration.widthAnchor.constraint(equalToConstant: imageSize),
            illustration.heightAnchor.constraint(equalToConstant: imageSize),
            illustration.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            illustration.bottomAnchor.constraint(equalTo: title.topAnchor, constant: -24.0),
        ])
        
        contentView.addSubview(content)
        NSLayoutConstraint.activate([
            content.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            content.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            content.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 16.0),
        ])
    }
    
}
