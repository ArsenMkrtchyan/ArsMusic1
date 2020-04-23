//
//  SearchInteractor.swift
//  ArsMusic
//
//  Created by Arsen Mkrtchyan on 4/21/20.
//  Copyright (c) 2020 smu117. All rights reserved.
//

import UIKit

protocol SearchBusinessLogic {
  func makeRequest(request: Search.Model.Request.RequestType)
}

class SearchInteractor: SearchBusinessLogic {
    var networkService = NetworkService()
  var presenter: SearchPresentationLogic?
  var service: SearchService?
  
  func makeRequest(request: Search.Model.Request.RequestType) {
    if service == nil {
      service = SearchService()
    }
    
    switch request {
    case .getTracks(let searchText):
        presenter?.presentData(response: Search.Model.Response.ResponseType.presentFooterView)
        networkService.fetchTracks(searchText: searchText) {[weak self] (searchResponse) in
            self?.presenter?.presentData(response: Search.Model.Response.ResponseType.presentTracks(searchRespons: searchResponse))
        }
    }
  }
  
}
