//
//  MovieCell.swift
//  TheMovie
//
//  Created by Mike Saradeth on 6/15/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    static let cellIdentifier = "cell"
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill  
        imageView.clipsToBounds = true
        layoutIfNeeded()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.fillSuperview()
    }
    
    func configure(movie: Movie, index: Int, delegate: LoadImagesDelegate?) {
        if let image = movie.posterImageCache {
            self.imageView.image = image
        }else {
            delegate?.loadImage(imageType: .poster, index: index) { [weak self] (image) in
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }                
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
