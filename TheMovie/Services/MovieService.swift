//
//  MovieService.swift
//  TheMovie
//
//  Created by Mike Saradeth on 6/15/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation

struct Movie: Codable {
    var id: String
    var title: String
    var posterPath: String
    var backdropPath: String
    var overview: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case overview
    }
}

struct MovieService {
    
    func search(query: String) {
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=a8f60f96f427faecddc13ba4782b2686&language=en-US&query=\(query)&page=1&include_adult=false"
        
        
    }
}
