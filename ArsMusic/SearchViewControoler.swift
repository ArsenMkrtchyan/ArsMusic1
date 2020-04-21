//
//  SearchViewControoler.swift
//  ArsMusic
//
//  Created by Arsen Mkrtchyan on 4/20/20.
//  Copyright © 2020 smu117. All rights reserved.
//

import UIKit
import Alamofire

struct TreckModel {
    var artistName:String
    var treckName:String
}

class SearchViewControoler: UITableViewController {
    private var timer: Timer?
    var networkService = NetworkService()
    var searchController = UISearchController(searchResultsController: nil)
    
    var trecks = [Track]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupSearchBar()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
    }
    
    
    private func setupSearchBar() {
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchBar.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trecks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId",for: indexPath)
        let treck = trecks[indexPath.row]
        cell.textLabel?.text = "\(treck.trackName) \n \(treck.artistName)"
        cell.textLabel?.numberOfLines = 2
        cell.imageView?.image = #imageLiteral(resourceName: "Image")
        return cell
        
    }
}

extension SearchViewControoler: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkService.fetchTracks(searchText: searchText) { [weak self](searchResult) in
                self?.trecks = searchResult?.results ?? []
                self?.tableView.reloadData()
            }
        })
        
     
            
        }
    
}
