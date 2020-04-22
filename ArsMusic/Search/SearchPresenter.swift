//
//  SearchPresenter.swift
//  ArsMusic
//
//  Created by Arsen Mkrtchyan on 4/21/20.
//  Copyright (c) 2020 smu117. All rights reserved.
//

import UIKit

protocol SearchPresentationLogic {
  func presentData(response: Search.Model.Response.ResponseType)
}

class SearchPresenter: SearchPresentationLogic {
  weak var viewController: SearchDisplayLogic?
  
  func presentData(response: Search.Model.Response.ResponseType) {
    switch response {
    case .some:
        print("prisenter .some")
    case .presentTracks(let searchResult):
        let cells = searchResult?.results.map{
            cellViewModel(from: $0)
        } ?? []
        let searchViewModel = SearchViewModel.init(cells: cells)
        viewController?.displayData(viewModel: Search.Model.ViewModel.ViewModelData.displayTracks(searchViewModel: searchViewModel))
    }
  }
    private func cellViewModel(from treck: Track) -> SearchViewModel.Cell {
        return SearchViewModel.Cell.init(iconUrlString: treck.artworkUrl100 ?? "" ,
                                         trackName: treck.trackName,
                                         collectinName: treck.collectionName ?? " ",
                                         artistName: treck.artistName,
                                         previewUrl: treck.previewUrl)
    }
}
