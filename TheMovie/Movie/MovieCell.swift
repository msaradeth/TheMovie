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
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(movie: Movie, index: Int, delegate: LoadImagesDelegate?) {
        if let image = movie.posterImage {
            self.imageView.image = image
        }else {
            delegate?.loadBackdropImage(index: index) { [weak self] (image) in
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }                
            }
        }
    }
}
