//
//  SearchViewController.swift
//  ArsMusic
//
//  Created by Arsen Mkrtchyan on 4/21/20.
//  Copyright (c) 2020 smu117. All rights reserved.
//

import UIKit

protocol SearchDisplayLogic: class {
  func displayData(viewModel: Search.Model.ViewModel.ViewModelData)
}

class SearchViewController: UIViewController, SearchDisplayLogic {
    

    var interactor: SearchBusinessLogic?
    var router: (NSObjectProtocol & SearchRoutingLogic)?
    var searchController = UISearchController(searchResultsController: nil)
    private var searchViewModel = SearchViewModel.init(cells: [])
    private lazy var footerView = FooterView()
    private var timer: Timer?
    @IBOutlet weak var table: UITableView!
    
  
  
  // MARK: Setup
  
  private func setup() {
    let viewController        = self
    let interactor            = SearchInteractor()
    let presenter             = SearchPresenter()
    let router                = SearchRouter()
    viewController.interactor = interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }
  
  // MARK: Routing
  

  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    setupSearchBar()
    setupTableView()
  }
    
    private func setupSearchBar(){
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    private func setupTableView() {
        table.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
        let nib = UINib(nibName: "TrackCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: TrackCell.reusleId)
        table.tableFooterView = footerView
    }
    
  func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
    
    switch viewModel {
    case .displayTracks(let searchViewModel ):
        self.searchViewModel = searchViewModel
        self.table.reloadData()
        footerView.hideLoder()
    case .displayFooterView:
        footerView.showLoder()
    }

  }
  
}

// MARK: - UITableViewDelegate,UITableViewDataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: TrackCell.reusleId, for: indexPath) as! TrackCell
        let cellViewModel = searchViewModel.cells[indexPath.row]
        
        
        cell.set(viewModel:cellViewModel)
//        cell.textLabel?.text = "\(cellViewModel.artistName)\n \(cellViewModel.trackName)"
//        cell.textLabel?.numberOfLines = 2
//        cell.imageView?.image = #imageLiteral(resourceName: "Image")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lable = UILabel()
        lable.text = "Please enter search term above..."
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return lable
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return searchViewModel.cells.count > 0 ? 0 : 250
    }
    
    
    
}
// MARK: - UISearchBarDelegate


extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] (_) in
            self?.interactor?.makeRequest(request: Search.Model.Request.RequestType.getTracks(searchText: searchText))
        })
        
    }
}
