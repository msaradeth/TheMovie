//
//  SearchViewModel.swift
//  TheMovie
//
//  Created by Mike Saradeth on 6/15/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import UIKit

protocol LoadImagesDelegate {
    func loadPosterImage(index: Int, completion: @escaping (UIImage?) -> Void)
    func loadBackdropImage(index: Int, completion: @escaping (UIImage?) -> Void)
}

class MovieViewModel: NSObject {
    var movies: [Movie]
    var movieService: MovieService
    var count: Int {
        return movies.count
    }
    subscript(index: Int) -> Movie {
        return movies[index]
    }
    
    init(movies: [Movie], movieService: MovieService) {
        self.movies = movies
        self.movieService = movieService
    }
    
    func search(query: String, completion: @escaping () -> Void) {
        movieService.search(query: query) { [weak self] (movies) in
            self?.movies = movies
            completion()
        }
    }
}

extension MovieViewModel: LoadImagesDelegate, LoadImageService {
    func loadPosterImage(index: Int, completion: @escaping (UIImage?) -> Void) {
        guard let imageUrl = movies[index].posterPath else { return }
        loadImage(imageUrl: imageUrl) { [weak self] (image) in
            self?.movies[index].posterImage = image
            completion(image)
        }
    }
    
    func loadBackdropImage(index: Int, completion: @escaping (UIImage?) -> Void) {
        guard let imageUrl = movies[index].backdropPath else { return }
        loadImage(imageUrl: imageUrl) { [weak self] (image) in
            self?.movies[index].backdropImage = image
            completion(image)
        }
    }
}
