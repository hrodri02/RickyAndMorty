//
//  Metadata.swift
//  RickAndMorty
//
//  Created by Eri on 1/8/20.
//  Copyright © 2020 Eri. All rights reserved.
//

import Foundation

struct Info: Codable
{
    var count: Int
    var pages: Int
    var next: String
    var prev: String
}
