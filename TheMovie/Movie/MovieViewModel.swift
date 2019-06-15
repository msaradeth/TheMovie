//
//  SearchViewModel.swift
//  TheMovie
//
//  Created by Mike Saradeth on 6/15/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation

class SearchViewModel {
    var movies: [Movie]
    var movieService: MovieService
    
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
