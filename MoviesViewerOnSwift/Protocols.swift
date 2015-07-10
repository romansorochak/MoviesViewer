//
//  Protocols.swift
//  MoviesViewerOnSwift
//
//  Created by Roman Sorochak on 10.07.15.
//  Copyright (c) 2015 SorikProduction. All rights reserved.
//

import Foundation

@objc public protocol ResponseObjectSerializable {
    init(response: NSHTTPURLResponse, representation: AnyObject)
}
