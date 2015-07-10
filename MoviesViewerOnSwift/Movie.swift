//
//  Movie.swift
//  MoviesViewerOnSwift
//
//  Created by Roman Sorochak on 10.07.15.
//  Copyright (c) 2015 SorikProduction. All rights reserved.
//

import Foundation

class Movie: NSObject, ResponseObjectSerializable {
    
    var id: Int
    var title: String
    
    var releaseDate: NSDate?
    var posterPath: String?
    var overview: String?
    
    required init(response: NSHTTPURLResponse, representation: AnyObject) {
        
        self.id = representation.valueForKeyPath("id") as! Int
        self.title = representation.valueForKeyPath("title") as! String
        
        self.releaseDate = representation.valueForKeyPath("title") as? NSDate
        self.posterPath = representation.valueForKeyPath("poster_path") as? String
        self.overview = representation.valueForKeyPath("overview") as? String
    }
}
