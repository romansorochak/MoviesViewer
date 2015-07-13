//
//  AlamofireExtension.swift
//  MoviesViewerOnSwift
//
//  Created by Roman Sorochak on 10.07.15.
//  Copyright (c) 2015 SorikProduction. All rights reserved.
//

import Foundation
import Alamofire

extension Alamofire.Request {
    
    public func responseObject<T: ResponseObjectSerializable>(
        completionHandler: (NSURLRequest, NSHTTPURLResponse?, T?, NSError?) -> Void) -> Self {
            
            let serializer: Serializer = { (request, response, data) in
                
                let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
                let (JSON: AnyObject?, serializationError) = JSONSerializer(
                    request, response, data
                )
                if response != nil && JSON != nil {
                    return (T(response: response!, representation: JSON!), nil)
                } else {
                    return (nil, serializationError)
                }
            }
            
            return response(serializer: serializer,
                completionHandler: { (request, response, object, error) in
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        completionHandler(request, response, object as? T, error)
                    })
            })
    }
    
    public func responseImage(completionHandler: (NSURLRequest, NSHTTPURLResponse?, UIImage?, NSError?) -> Void) -> Self {
        
        let serializer: Serializer = { (request, response, data) in
            
            if data == nil {
                return (nil, nil)
            }
            
            let image = UIImage(data: data!, scale: UIScreen.mainScreen().scale)
            
            return (image, nil)
        }
        
        return response(serializer: serializer,
            completionHandler: { (request, response, image, error) in
                
                completionHandler(request, response, image as? UIImage, error)
        })
    }
}