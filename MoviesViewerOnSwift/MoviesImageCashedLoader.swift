//
//  MoviesImageCashedLoader.swift
//  MoviesViewerOnSwift
//
//  Created by RomanSorochak on 14.07.15.
//  Copyright (c) 2015 SorikProduction. All rights reserved.
//

import UIKit
import SDWebImage

public protocol URLConvertible {
    
    var URL: NSURL { get }
}

class MoviesImageCashedLoader {
    
    private static let imageCache = NSCache()
    
    enum Router: URLConvertible {
        
        private static let API_KEY = "api_key"
        private static let baseURLString = "http://image.tmdb.org/t/p"
        
        enum ImageSize: String {
            case Small = "/w150"
            case Large = "/w500"
        }
        
        case Image (imagePath: String, size: ImageSize)
        
        var URL: NSURL {
            let (absoluteURLPath: String) = {
                
                var baseURLString: String = Router.baseURLString
                var path: String!
                var params: [String: String] = [Router.API_KEY : Constants.apiKeyValue]
                
                switch self {
                case .Image (let imagePath, let size):
                    path = size.rawValue + imagePath
                    break
                }
                
                return (baseURLString + path + "?" + Router.API_KEY + "=" + Constants.apiKeyValue)
                }()
            
            return NSURL(string: absoluteURLPath)!
        }
    }
    
    
    class func loadAndCasheImageForMoviePath(path: String?, size: MoviesImageCashedLoader.Router.ImageSize,
        completion: ((image: UIImage?, error: NSError?)->Void)) -> SDWebImageOperation? {
            
            if path == nil {
                return nil
            }
            
            return SDWebImageDownloader.sharedDownloader().downloadImageWithURL(Router.Image(imagePath: path!, size: size).URL,
                options: SDWebImageDownloaderOptions.allZeros,
                progress: { (receivedSize, expectedSize) -> Void in
                    
                    
                }) { (image, _, error, finished) -> Void in
                    
                    if error == nil {
                        if finished == true {
                            completion(image: image, error: error)
                        }
                    } else {
                        completion(image: nil, error: error)
                    }
            }
    }
}

