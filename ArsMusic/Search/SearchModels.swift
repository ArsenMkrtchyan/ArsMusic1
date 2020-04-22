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
        case some
        case getTracks(searchText: String)
      }
    }
    struct Response {
      enum ResponseType {
        case some
        case presentTracks(searchRespons: SearchResponse?)
        
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case some
        case displayTracks(searchViewModel: SearchViewModel)
      }
    }
  }
  
}
struct SearchViewModel {
    struct Cell:TrackCellViewModel {
        var iconUrlString: String?
        var trackName: String
        var collectinName: String
        var artistName: String
        var previewUrl: String?
    }
    let cells: [Cell]
}
