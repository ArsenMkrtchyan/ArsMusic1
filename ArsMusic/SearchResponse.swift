//
//  SearchResponse.swift
//  ArsMusic
//
//  Created by Arsen Mkrtchyan on 4/21/20.
//  Copyright © 2020 smu117. All rights reserved.
//

import Foundation

struct SearchResponse: Decodable {
    var resultCount:Int?
    var results: [Track]
}

struct Track: Decodable{
    var trackName:String
    var collectionName:String?
    var artistName:String
    var artworkUrl100: String?
    var previewUrl: String?
}
