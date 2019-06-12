//
//  UIImageViewExtension.swift
//  PubsGuide
//
//  Created by Adrian Sandru on 20/04/2019.
//  Copyright © 2019 Adrian Sandru. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    
    func imageFromServerURL(_ URLString: String, placeHolder: UIImage? = nil, circularShape: Bool? = false) {
        
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString + String(circularShape!))) {
            self.image = cachedImage
            return
        }
        if let ph = placeHolder {
            self.image = ph
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
                                UIView.transition(with: self, duration: 0.25, options: .transitionCrossDissolve, animations: {
                                    [weak self] in
                                    self?.image = result
                                }, completion: nil)
                            }
                    }
                }
            }).resume()
        }
    }
}
