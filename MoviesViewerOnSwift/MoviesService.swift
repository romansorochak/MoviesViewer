//
//  NetworkFetcher.swift
//  MoviesViewerOnSwift
//
//  Created by RomanSorochak on 10.07.15.
//  Copyright (c) 2015 SorikProduction. All rights reserved.
//

import Foundation
import Alamofire

class MoviesService {
    
    enum Router: URLRequestConvertible {
        private static let API_KEY = "api_key"
        private static let PAGE = "page"
        
        private static let baseURLString = "http://api.themoviedb.org"
        private static let apiKeyValue = "68771b3f5a97a2dc0ab330ba00210532"
        
        case Latest
        case Movie(id: Int)
        
        var URLRequest: NSURLRequest {
            let (path: String, parameters: [String: AnyObject]) = {
                switch self {
                case .Latest:
                    let path = "/3/movie/latest"
                    let params = [Router.API_KEY : Router.apiKeyValue]
                    return (path, params)
                case .Movie (let id):
                    let path = "/3/movie/\(id)"
                    let params = [Router.API_KEY : Router.apiKeyValue]
                    return (path, params)
                }
                }()
            
            let URL = NSURL(string: Router.baseURLString)
            let URLRequest = NSURLRequest(URL: URL!.URLByAppendingPathComponent(path))
            let encoding = Alamofire.ParameterEncoding.URL
            
            return encoding.encode(URLRequest, parameters: parameters).0
        }
    }
}
