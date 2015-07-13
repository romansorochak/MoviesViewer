//
//  MoviesImageLoader.swift
//  MoviesViewerOnSwift
//
//  Created by RomanSorochak on 13.07.15.
//  Copyright (c) 2015 SorikProduction. All rights reserved.
//

import UIKit
import Alamofire

class MoviesImageLoader {
    
    private static let imageCache = NSCache()
    
    enum Router: URLRequestConvertible {
        
        private static let API_KEY = "api_key"
        private static let baseURLString = "http://image.tmdb.org/t/p"
        
        enum ImageSize: String {
            case Small = "/w150"
            case Large = "/w500"
        }
        
        case Image (imagePath: String, size: ImageSize)
        
        var URLRequest: NSURLRequest {
            let (baseURLString: String, path: String, parameters: [String: AnyObject]) = {
                
                var baseURLString: String = Router.baseURLString
                var path: String!
                var params: [String: String] = [Router.API_KEY : Constants.apiKeyValue]
                
                switch self {
                case .Image (let imagePath, let size):
                    path = size.rawValue + imagePath
                    break
                }
                
                return (baseURLString, path, params)
                }()
            
            let URL = NSURL(string: baseURLString)
            let URLRequest = NSURLRequest(URL: URL!.URLByAppendingPathComponent(path))
            let encoding = Alamofire.ParameterEncoding.URL
            
            return encoding.encode(URLRequest, parameters: parameters).0
        }
    }
    
    class func loadImageForMoviePath(path: String?, size: MoviesImageLoader.Router.ImageSize,
        completion: ((image: UIImage?, error: NSError?)->Void)) -> Request? {
            
            if path == nil {
                
                return nil
            }
            
            if let image = self.imageCache.objectForKey(path!) as? UIImage {
            
                println("imageCache - \(path)")
                
                completion(image: image, error: nil)
                return nil
            }
            
            return Alamofire.request(Router.Image(imagePath: path!, size: size)).validate().responseImage {
                (_, _, image, error) -> Void in
                
                self.imageCache.setObject(image!, forKey: path!)
                
                completion(image: image, error: error)
            }
    }
}
