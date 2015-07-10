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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Alamofire.request(NetworkFetcher.Router.Latest).validate().responseJSON {
            (_, _, JSON, error) in
            
            println(JSON)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

