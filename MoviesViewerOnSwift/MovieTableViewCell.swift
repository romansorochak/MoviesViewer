//
//  MovieTableViewCell.swift
//  MoviesViewerOnSwift
//
//  Created by RomanSorochak on 13.07.15.
//  Copyright (c) 2015 SorikProduction. All rights reserved.
//

import UIKit
import Alamofire

class MovieTableViewCell : UITableViewCell {
    
    private var imageRequest: Request?
    
    @IBOutlet weak var movieThaumbnailImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    
    func loadThumbnail(imagePath: String?) {
        
        movieThaumbnailImageView.image = nil
        imageRequest?.cancel()
        
        imageRequest = MoviesImageLoader.loadImageForMoviePath(imagePath, size: .Small,
            completion: { (image, error) -> Void in
                
                if error == nil {
                    
                    self.movieThaumbnailImageView.image = image
                } else {
                    
                    println("error = \(error)")
                }
        })
    }
}
