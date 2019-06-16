//
//  DetailCell.swift
//  TheMovie
//
//  Created by Mike Saradeth on 6/15/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

class DetailCell: UICollectionViewCell {
    static let cellIdentifier = "cell"
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    var cellHeight: CGFloat {
        return movieTitle.frame.size.height + movieDescription.frame.size.height
    }
    
    func configure(movie: Movie) {
        self.movieTitle.text = movie.title
        self.movieDescription.text = movie.overview        
    }
}
