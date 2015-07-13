//
//  ViewController.swift
//  MoviesViewerOnSwift
//
//  Created by RomanSorochak on 10.07.15.
//  Copyright (c) 2015 SorikProduction. All rights reserved.
//

import UIKit
import Alamofire

class MoviesViewController: UIViewController {
    
    private struct Constants {
        
        static let MovieCellId = "MovieTableViewCell"
    }
    
    
    // MARK - outlers
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK - ivars
    
    var moviesList: MoviesList!
    var pageToload: Int = 1
    var moviesType: MoviesServiceApi.Router = .Latest
    
    
    // MARK - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMovies(.Popular(page: 1))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK - private
    
    private func loadMovies(type: MoviesServiceApi.Router) {
        
        moviesType = type
        
        MoviesServiceApi.loadMovies(moviesType,
            completion: { (moviesList, error) -> Void in
                
                if error == nil {
                    
                    self.moviesList = moviesList
                    self.tableView.reloadData()
                    
                    for movie in moviesList.movies {
                        
                        println("\(movie.id) - \(movie.title)")
                    }
                } else {
                    
                    println("error = \(error)")
                }
        })
    }
}

extension MoviesViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return moviesList == nil ? 0 : moviesList.movies.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 70
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.MovieCellId, forIndexPath: indexPath) as! MovieTableViewCell
        
        let movie = moviesList.movies[indexPath.row]
        
        cell.movieTitleLabel.text = movie.title
        
        cell.loadThumbnail(movie.posterPath)
        
        return cell
    }
}
