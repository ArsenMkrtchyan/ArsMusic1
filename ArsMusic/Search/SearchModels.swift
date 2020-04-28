//
//  SearchModels.swift
//  ArsMusic
//
//  Created by Arsen Mkrtchyan on 4/21/20.
//  Copyright (c) 2020 smu117. All rights reserved.
//

import UIKit

enum Search {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getTracks(searchText: String)
      }
    }
    struct Response {
      enum ResponseType {
        case presentTracks(searchRespons: SearchResponse?)
        case presentFooterView
        
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayTracks(searchViewModel: SearchViewModel)
        case displayFooterView
      }
    }
  }
  
}
class SearchViewModel:NSObject, NSCoding {
    func encode(with coder: NSCoder) {
        coder.encode(cells, forKey: "cells")
    }
    
    required init?(coder: NSCoder) {
        cells = coder.decodeObject(forKey: "cells") as? [SearchViewModel.Cell] ?? []
    }
    
    
    @objc(_TtCC8ArsMusic15SearchViewModel4Cell)class Cell:NSObject,NSCoding {
        
        
        var iconUrlString: String?
        var trackName: String
        var collectinName: String
        var artistName: String
        var previewUrl: String?
        
        
        func encode(with coder: NSCoder) {
            coder.encode(iconUrlString, forKey: "iconUrlString")
            coder.encode(trackName, forKey: "trackName")
            coder.encode(collectinName, forKey: "collectinName")
            coder.encode(artistName, forKey: "artistName")
            coder.encode(previewUrl, forKey: "previewUrl")
        }
        
        required init?(coder: NSCoder) {
            iconUrlString = coder.decodeObject(forKey: "iconUrlString") as! String?
            trackName = coder.decodeObject(forKey: "trackName") as! String
            collectinName = coder.decodeObject(forKey: "collectinName") as! String
            artistName = coder.decodeObject(forKey: "artistName") as! String
            previewUrl = coder.decodeObject(forKey: "previewUrl") as! String?
        }
        
        
        init(iconUrlString: String?,
             trackName: String,
             collectinName: String,
             artistName: String,
             previewUrl: String? ) {
            
            self.iconUrlString = iconUrlString
            self.trackName = trackName
            self.collectinName = collectinName
            self.artistName = artistName
            self.previewUrl = previewUrl
        }
    }
    init(cells:[Cell]) {
        self.cells = cells
    }
    let cells: [Cell]
}
