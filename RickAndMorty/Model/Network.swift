//
//  Network.swift
//  RickAndMorty
//
//  Created by Eri on 1/7/20.
//  Copyright © 2020 Eri. All rights reserved.
//

import Foundation

struct Network {
    static func loadJSONData<T: Codable, M: Codable>(from urlStr: String,
                                                     type: T.Type,
                                                     metaDataType: M.Type,
                                                     queue: DispatchQueue = DispatchQueue.main,
                                                     completionHandler: @escaping (T?, M?, NetworkError?) -> Void)
    {
        guard let url = URL(string: urlStr) else {
            completionHandler(nil, nil, .invalidPath)
            return
        }
        
        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 200
            
            if statusCode != 200 {
                queue.async {
                    completionHandler(nil, nil, .requestError)
                }
                return
            }
            
            do {
                if let jsonData = data {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                        let value = try decoder.singleValueContainer().decode(String.self)
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        
                        if let date = formatter.date(from: value) {
                            return date
                        }
                        
                        throw NetworkError.dateParseError
                    })
                    
                    
                    let typedObject: T? = try decoder.decode(T.self, from: jsonData)
                    let metaDataObject: M? = try decoder.decode(M.self, from: jsonData)
                    queue.async {
                        completionHandler(typedObject, metaDataObject, nil)
                    }
                }
            }
            catch {
                print(error)
                queue.async {
                    completionHandler(nil, nil, .parseError)
                }
            }
        }
        
        dataTask.resume()
    }
}
