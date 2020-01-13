//
//  NetworkError.swift
//  RickAndMorty
//
//  Created by Eri on 1/7/20.
//  Copyright © 2020 Eri. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case dateParseError
    case invalidPath
    case parseError
    case requestError
}
