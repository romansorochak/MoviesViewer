//
//  NetworkFetcher.swift
//  MoviesViewerOnSwift
//
//  Created by RomanSorochak on 10.07.15.
//  Copyright (c) 2015 SorikProduction. All rights reserved.
//

import Foundation
import Alamofire

class MoviesServiceApi {
    
    enum Router: URLRequestConvertible {
        
        enum ImageSize: String {
            case Small = "/w150"
            case Large = "/w500"
        }
        
        private static let API_KEY = "api_key"
        private static let PAGE = "page"
        
        private static let baseURLString = "http://api.themoviedb.org/3"
        private static let baseImageURLString = "http://image.tmdb.org/t/p"
        
        private static let apiKeyValue = "68771b3f5a97a2dc0ab330ba00210532"
        
        case Latest
        case NowPlaying(page: Int)
        case Popular(page: Int)
        case UpComing(page: Int)
        case Movie(id: Int)
        
        case Image (imagePath: String, size: ImageSize)
        
        var URLRequest: NSURLRequest {
            let (baseURLString: String, path: String, parameters: [String: AnyObject]) = {
                
                var baseURLString: String = Router.baseURLString
                var path: String!
                var params: [String: String] = [Router.API_KEY : Router.apiKeyValue]
                
                switch self {
                case .Latest:
                    path = "/movie/latest"
                    break
                case .NowPlaying (let page):
                    path = "/movie/now_playing"
                    params = [Router.API_KEY : Router.apiKeyValue, Router.PAGE : String(page)]
                    break
                case .Popular (let page):
                    path = "/movie/popular"
                    params = [Router.API_KEY : Router.apiKeyValue, Router.PAGE : String(page)]
                    break
                case .UpComing (let page):
                    path = "/movie/upcoming"
                    params = [Router.API_KEY : Router.apiKeyValue, Router.PAGE : String(page)]
                    break
                case .Movie (let id):
                    path = "/movie/\(id)"
                    break
                case .Image (let imagePath, let size):
                    baseURLString = Router.baseImageURLString
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
}
