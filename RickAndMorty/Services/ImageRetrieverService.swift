//
//  ImageRetrieverService.swift
//  RickAndMorty
//
//  Created by Eri on 1/8/20.
//  Copyright © 2020 Eri. All rights reserved.
//

import UIKit

class ImageRetrieverService
{
    static let shared = ImageRetrieverService()
    private let imageCache: NSCache<AnyObject, AnyObject>
    
    private init() {
        self.imageCache = NSCache<AnyObject, AnyObject>()
    }
    
    func downloadImage(from imageURLStr: String, completionHandler: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: imageURLStr) else {
            DispatchQueue.main.async {
                completionHandler(nil)
            }
            return
        }
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            print("got image from cache")
            DispatchQueue.main.async {
                completionHandler(cachedImage)
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let err = error {
                print(err.localizedDescription)
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
            else {
                guard let imgData = data else {
                    DispatchQueue.main.async {
                        completionHandler(nil)
                    }
                    return
                }
                
                if let image = UIImage(data: imgData) {
                    print("got image from url (bytes = \(imgData.count))")
                    self.imageCache.setObject(image as AnyObject, forKey: url.absoluteString as AnyObject)
                    DispatchQueue.main.async {
                        completionHandler(image)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        completionHandler(nil)
                    }
                }
            }
        }.resume()
    }
}
