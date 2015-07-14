//
//  MovieCollectionCell.swift
//  MoviesViewerOnSwift
//
//  Created by RomanSorochak on 13.07.15.
//  Copyright (c) 2015 SorikProduction. All rights reserved.
//

import UIKit
//import Alamofire
import SDWebImage

class MovieCollectionViewCell : UICollectionViewCell {
    
//    private var imageRequest: Request?
    private var imageRequest: SDWebImageOperation?
    
    @IBOutlet weak var movieThumbnailImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.movieThumbnailImageView.layer.cornerRadius = 5
        
        self.movieThumbnailImageView.layer.borderWidth = 1
        self.movieThumbnailImageView.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.movieThumbnailImageView.clipsToBounds = true
    }
    
    func loadThumbnail(imagePath: String?) {
        
        movieThumbnailImageView.image = nil
        imageRequest?.cancel()
        
//        imageRequest = MoviesImageLoader.loadImageForMoviePath(imagePath, size: .Small,
//            completion: { (image, error) -> Void in
//                
//                if error == nil {
//                    
//                    self.movieThumbnailImageView.image = image
//                } else {
//                    
//                    println("error = \(error)")
//                }
//        })
        
        imageRequest = MoviesImageCashedLoader.loadAndCasheImageForMoviePath(imagePath,
            size: .Small) { (image, error) -> Void in
                
                if error == nil {
                    
                    self.movieThumbnailImageView.image = image
                } else {
                    
                    println("error = \(error)")
                }
                
        }
    }
}
