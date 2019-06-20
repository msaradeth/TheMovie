//
//  SearchViewModel.swift
//  TheMovie
//
//  Created by Mike Saradeth on 6/15/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import UIKit

enum ImageType {
    case poster
    case backdrop
}
protocol LoadImagesDelegate {
    func loadImage(imageType: ImageType, index: Int, completion: @escaping (UIImage?) -> Void)
}

class MovieViewModel: NSObject {
    var movies: [Movie]
    var movieService: MovieService
    var isSearching: Bool
    var count: Int {
        return movies.count
    }
    subscript(index: Int) -> Movie {
        return movies[index]
    }
    
    init(movies: [Movie], movieService: MovieService) {
        self.movies = movies
        self.movieService = movieService
        self.isSearching = false
    }
    
    func search(query: String, completion: @escaping () -> Void) {
        guard query.count > 0, isSearching == false else { return }
        isSearching = true
        movieService.search(query: query) { [weak self] (movies) in
            self?.isSearching = false
            self?.movies = movies
            completion()
        }
    }
}

extension MovieViewModel: LoadImagesDelegate, LoadImageService {
    func loadImage(imageType: ImageType, index: Int, completion: @escaping (UIImage?) -> Void) {
        let imageUrl = (imageType == .poster) ? movies[index].posterPath : movies[index].backdropPath
        
        loadImage(imageUrl: imageUrl) { [weak self] (image) in
            if imageType == .poster {
                self?.movies[index].posterImageCache = image
            }else {
                self?.movies[index].backdropImageCache = image
            }
            completion(image)
        }
    }
}
