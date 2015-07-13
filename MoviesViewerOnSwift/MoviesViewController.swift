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
        
        static let MovieTableViewCellId = "MovieTableViewCell"
        static let MovieCollectionViewCellId = "MovieCollectionViewCell"
    }
    
    
    // MARK - outlers
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK - ivars
    
    var moviesList: MoviesList!
    var pageToload: Int = 1
    var moviesType: MoviesServiceApi.Router = .Latest
    
    var isTableViewShowed: Bool = true
    
    
    // MARK - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        loadMovies(.Popular(page: 1))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK - NavigationBar
    
    @IBAction func switchPresentetion(sender: UIBarButtonItem) {
        
        isTableViewShowed = !isTableViewShowed
        
        self.navigationItem.leftBarButtonItem?.title = isTableViewShowed ? "Table" : "Collection"
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            
            self.tableView.alpha = self.isTableViewShowed ? 1 : 0
            self.collectionView.alpha = self.isTableViewShowed ? 0 : 1
        })
    }
    
    @IBAction func switchMoviesType(sender: AnyObject) {
        
        let actionSheet = UIActionSheet(title: "Movies list",
            delegate: self,
            cancelButtonTitle: "Cancel",
            destructiveButtonTitle: nil)
        actionSheet.addButtonWithTitle("Popular")
        actionSheet.addButtonWithTitle("Now playing")
        actionSheet.addButtonWithTitle("Up coming")
        actionSheet.actionSheetStyle = UIActionSheetStyle.BlackTranslucent
        
        actionSheet.showFromBarButtonItem(self.navigationItem.rightBarButtonItem, animated: true)
    }
    
    // MARK - private - load movies
    
    private func loadMovies(type: MoviesServiceApi.Router) {
        
        moviesType = type
        
        MoviesServiceApi.loadMovies(moviesType,
            completion: { (moviesList, error) -> Void in
                
                if error == nil {
                    
                    if self.pageToload == 1 {
                        
                        self.moviesList = moviesList
                        
                        self.tableView.reloadData()
                        self.collectionView.reloadData()
                    } else {
                        
                        let rows = self.moviesList.movies.count
                        let additionalRows = moviesList.movies.count
                        
                        var indexPaths = [NSIndexPath]()
                        for var i: Int = 0; i < additionalRows; i++ {
                            
                            indexPaths.append(NSIndexPath(forRow: rows + i, inSection: 0))
                        }
                        
                        self.moviesList.movies += moviesList.movies
                        
                        self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
                        self.collectionView.insertItemsAtIndexPaths(indexPaths)
                    }
                } else {
                    
                    println("error = \(error)")
                }
        })
    }
    
    private func loadMoreMoviesIfNeedWith(indexPath: NSIndexPath) {
        
        println("indexPath.row - \(indexPath.row)")
        println(self.moviesList.movies.count - 1)
        
        if indexPath.row == self.moviesList.movies.count - 1 {
            
            pageToload++
            
            switch moviesType {
            case .Latest:
                moviesType = .Latest
                break
            case .NowPlaying(page: pageToload-1):
                moviesType = .NowPlaying(page: pageToload)
                break
            case .Popular(page: pageToload-1):
                moviesType = .Popular(page: pageToload)
                break
            case .UpComing(page: pageToload-1):
                moviesType = .UpComing(page: pageToload)
                break
            default:
                break
            }
            
            loadMovies(moviesType)
        }
    }
}


extension MoviesViewController : UIActionSheetDelegate {
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
        pageToload = 1
        
        switch (buttonIndex) {
        case 0: // Cancel
            break
        case 1: // Popular
            navigationItem.rightBarButtonItem?.title = "Popular"
            moviesType = .Popular(page: pageToload)
            break
        case 2: // NowPlaying
            navigationItem.rightBarButtonItem?.title = "Now playing"
            moviesType = .NowPlaying(page: pageToload)
            break
        case 3: // UpComing
            moviesType = .UpComing(page: pageToload)
            navigationItem.rightBarButtonItem?.title = "Up Coming"
            break
        default:
            break
        }
        
        self.moviesList = nil
        self.loadMovies(moviesType)
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.MovieTableViewCellId, forIndexPath: indexPath) as! MovieTableViewCell
        
        let movie = moviesList.movies[indexPath.row]
        
        cell.movieTitleLabel.text = movie.title
        
        cell.loadThumbnail(movie.posterPath)
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        loadMoreMoviesIfNeedWith(indexPath)
    }
}


extension MoviesViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return moviesList == nil ? 0 : moviesList.movies.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.MovieCollectionViewCellId, forIndexPath: indexPath) as! MovieCollectionViewCell
        
        let movie = moviesList.movies[indexPath.row]
        
        cell.loadThumbnail(movie.posterPath)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        loadMoreMoviesIfNeedWith(indexPath)
    }
}
