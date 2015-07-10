//
//  MoviesList.swift
//  MoviesViewerOnSwift
//
//  Created by Roman Sorochak on 11.07.15.
//  Copyright (c) 2015 SorikProduction. All rights reserved.
//

import Foundation

final class MoviesList : NSObject, ResponseObjectSerializable {
    
    var movies: [Movie]
    
    init(response: NSHTTPURLResponse, representation: AnyObject) {
        
        self.movies = [Movie]()
        
        for movie in representation.valueForKey("results") as! NSArray {
            
            self.movies.append(Movie(response: response, representation: movie))
        }
    }
}
