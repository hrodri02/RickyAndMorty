//
//  WebService.swift
//  RickAndMorty
//
//  Created by Eri on 1/7/20.
//  Copyright © 2020 Eri. All rights reserved.
//

import Foundation

struct WebServices
{
    static func loadCharacters(completionHandler: @escaping (RickAndMortyCharacters?, Info?, Bool?) -> Void) {
        Network.loadJSONData(from: "https://rickandmortyapi.com/api/character", type: RickAndMortyCharacters.self, metaDataType: Metadata.self) { (characters, metaData, error) in
            if let err = error {
                print(err)
                completionHandler(nil, nil, false)
                return
            }
            else {
                completionHandler(characters, metaData?.info, true)
            }
        }
    }
}
