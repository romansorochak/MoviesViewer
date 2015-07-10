//
//  ViewController.swift
//  MoviesViewerOnSwift
//
//  Created by RomanSorochak on 10.07.15.
//  Copyright (c) 2015 SorikProduction. All rights reserved.
//

import UIKit
import Alamofire

class MoviesCollectionViewController: UICollectionViewController {
    
    var id: Int = 348199
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Alamofire.request(MoviesServiceApi.Router.Latest).validate().responseJSON {
            (_, _, JSON, error) in
            
            println(JSON)
        }
        
        Alamofire.request(MoviesServiceApi.Router.Movie(id: id)).validate().responseObject { (_, _, movie: Movie?, error) -> Void in
            
            if error == nil {
                
                println(movie?.id)
            } else {
                
                println(error)
            }
        }
        
        Alamofire.request(MoviesServiceApi.Router.NowPlaying(page: 1)).validate().responseObject {
            (_, _, moviesList: MoviesList?, error) -> Void in
            
            if error == nil {
                
                for movie in moviesList!.movies {
                    
                    println(movie.title)
                    
                    var images = [UIImage]()
                    
                    if let posterPath = movie.posterPath {
                        Alamofire.request(
                            MoviesServiceApi.Router.Image(
                                imagePath: posterPath,
                                size: .Small)
                            ).validate().responseImage({ (_, _, image: UIImage?, error) -> Void in
                                
                                if error == nil {
                                    images.append(image!)
                                } else {
                                    
                                    println(error)
                                }
                            })
                    }
                    
                }
            } else {
                
                println(error)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

