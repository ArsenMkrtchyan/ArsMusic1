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
    var searchController = UISearchController(searchResultsController: nil)
    
    var trecks = [TreckModel(artistName: "Bon Jovi", treckName: "gud by"),
    TreckModel(artistName: "Eminem", treckName: "8 mile")]
    
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
        cell.textLabel?.text = "\(treck.treckName) \n \(treck.artistName)"
        cell.textLabel?.numberOfLines = 2
        cell.imageView?.image = #imageLiteral(resourceName: "Image")
        return cell
        
    }
}

extension SearchViewControoler: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            
            self.timer?.invalidate()
            let url = "https://itunes.apple.com/search?term=\(searchText)"
            
            AF.request(url).responseData { (dataResponse) in
                if let error = dataResponse.error {
                    print("Error received requestiong data: \(error.localizedDescription)")
                    return
                }
                
                
                guard let data = dataResponse.data else { return }
                
                let decoder = JSONDecoder()
                do {
                    let objects = try decoder.decode(SearchResponse.self, from: data)
                    print("Onject: \(objects)")
                }catch let jsonError{
                    print("JsoneError: \(jsonError)")
                }
                let someString = String(data: data, encoding: .utf8)
                
            }
        })
        
       
            
        }
    
}
