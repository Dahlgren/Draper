//
//  MuzeiFeaturedArt.swift
//  Draper
//
//  Created by Björn Dahlgren on 2017-06-17.
//  Copyright © 2017 Björn Dahlgren. All rights reserved.
//

import Foundation
import UIKit

class MuzeiFeaturedArt {
    let url = "https://muzeiapi.appspot.com/featured?cachebust=1"
    
    enum JSONError: String, Error {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    enum SourceError: String, Error {
        case ImageError = "ERROR: unable to load image"
        case ImageURLError = "ERROR: unable to create image url"
        case ParseError = "ERROR: invalid JSON data"
    }
    
    func load(completion: @escaping (Artwork?) -> ()) {
        guard let endpoint = URL(string: url) else {
            print("Error creating endpoint")
            return
        }
        URLSession.shared.dataTask(with: endpoint) { (data, response, error) in
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
                    throw JSONError.ConversionFailed
                }
                
                guard let title = json["title"] as? String else {
                    throw SourceError.ParseError
                }
                guard let imageUri = json["imageUri"] as? String else {
                    throw SourceError.ParseError
                }
                
                guard let imageURL = URL(string: imageUri.replacingOccurrences(of: "http://", with: "https://")) else {
                    throw SourceError.ImageURLError
                }
                guard let image = try UIImage(data: Data(contentsOf: imageURL)) else {
                    throw SourceError.ImageError
                }
                
                let artwork = Artwork(title: title, image: image)
                completion(artwork)
            } catch let error as JSONError {
                print(error.rawValue)
            } catch let error as SourceError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            }
        }.resume()
    }
}
