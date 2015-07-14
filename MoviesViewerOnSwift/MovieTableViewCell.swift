//
//  MovieTableViewCell.swift
//  MoviesViewerOnSwift
//
//  Created by RomanSorochak on 13.07.15.
//  Copyright (c) 2015 SorikProduction. All rights reserved.
//

import UIKit
import SDWebImage

class MovieTableViewCell : UITableViewCell {
    
    private var imageRequest: SDWebImageOperation?
    
    @IBOutlet weak var movieThaumbnailImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.movieThaumbnailImageView.layer.cornerRadius = 5
        
        self.movieThaumbnailImageView.layer.borderWidth = 1
        self.movieThaumbnailImageView.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.movieThaumbnailImageView.clipsToBounds = true
    }
    
    func loadThumbnail(imagePath: String?) {
        
        movieThaumbnailImageView.image = nil
        imageRequest?.cancel()
        
        imageRequest = MoviesImageCashedLoader.loadAndCasheImageForMoviePath(imagePath,
            size: .Small) { (image, error) -> Void in
                
                if error == nil {
                    
                    self.movieThaumbnailImageView.image = image
                } else {
                    
                    println("error = \(error)")
                }
                
        }
    }
}
