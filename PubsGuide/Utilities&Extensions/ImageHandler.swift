//
//  ImageHandler.swift
//  PubsGuide
//
//  Created by Adrian Sandru on 23/04/2019.
//  Copyright © 2019 Adrian Sandru. All rights reserved.
//

import Foundation
import UIKit

class ImageHandler {
    static func imageFromServerURL(_ URLString: String,
                                   circularShape: Bool? = false,
                                   with completion: ((UIImage)->())? = nil) {
        
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString + String(circularShape!))) {
            completion?(cachedImage)
        }
        
        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(String(describing: error))")
                    return
                }
                if let data = data {
                    if let downloadedImage = UIImage(data: data) {
                        var result = downloadedImage
                        if circularShape! {
                            result = result.circleMasked!
                        }
                        DispatchQueue.main.async {
                            imageCache.setObject(result, forKey: NSString(string: URLString + String(circularShape!)))
                            completion?(result)
                        }
                    }
                }
            }).resume()
        }
    }
}
