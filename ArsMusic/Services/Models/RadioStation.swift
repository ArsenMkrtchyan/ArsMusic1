//
//  RadioStation.swift
//  ArsMusic
//
//  Created by Arsen Mkrtchyan on 5/2/20.
//  Copyright © 2020 smu117. All rights reserved.
//

import Foundation

struct RadioStation: Codable {
    
    var name: String
    var streamURL: String
    var imageURL: String
    var desc: String
    var longDesc: String
    
    init(name: String, streamURL: String, imageURL: String, desc: String, longDesc: String = "") {
        self.name = name
        self.streamURL = streamURL
        self.imageURL = imageURL
        self.desc = desc
        self.longDesc = longDesc
    }
}

extension RadioStation: Equatable {
    
    static func == (lhs: RadioStation, rhs: RadioStation) -> Bool {
        return (lhs.name == rhs.name) && (lhs.streamURL == rhs.streamURL) && (lhs.imageURL == rhs.imageURL) && (lhs.desc == rhs.desc) && (lhs.longDesc == rhs.longDesc)
    }
}

extension RadioStation: TrackCellViewModel  {
    var trackUrl: String {
        return streamURL
    }
    
    var iconUrlString: String? {
        return imageURL
    }
    
    var trackName: String {
        return desc
    }
    
    var collectinName: String {
        return desc
    }
    
    var artistName: String {
        return name
    }
    
    
}
