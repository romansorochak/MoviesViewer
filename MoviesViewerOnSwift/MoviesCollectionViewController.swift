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
        
        Alamofire.request(MoviesService.Router.Latest).validate().responseJSON {
            (_, _, JSON, error) in
            
            println(JSON)
        }
        
        Alamofire.request(MoviesService.Router.Movie(id: id)).validate().responseObject { (_, _, movie: Movie?, error) -> Void in
            
            if error == nil {
                
                println(movie?.id)
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

