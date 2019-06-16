//
//  MovieService.swift
//  TheMovie
//
//  Created by Mike Saradeth on 6/15/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation


struct MovieService {
    private struct SearchMovieService: Codable {
        var movies: [Movie]
        enum CodingKeys: String, CodingKey {
            case movies = "results"
        }
    }
    
    func search(query: String, completion: @escaping ([Movie]) -> Void) {
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=a8f60f96f427faecddc13ba4782b2686&language=en-US&query=\(query)&page=1&include_adult=false"
        
        HttpHelp.request(urlString, method: .get, success: { (dataResponse) in
            guard let data = dataResponse.data else { return }
            do {
                let decoder = JSONDecoder()
                let searchMovieService = try decoder.decode(SearchMovieService.self, from: data)
                let movies = searchMovieService.movies.filter{ $0.posterPath != nil && $0.backdropPath != nil }
                completion(movies)
            }catch let error {
                print(error.localizedDescription)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
