//
//  MovieModel.swift
//  TheMovie
//
//  Created by Mike Saradeth on 6/15/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import UIKit


struct Movie: Codable {
    var id: Int
    var title: String
    var posterPath: String?
    var backdropPath: String?
    var overview: String
    
    var posterImage: UIImage?
    var backdropImage: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case overview
    }
 }


