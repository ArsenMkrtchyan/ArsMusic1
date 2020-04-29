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
    weak var tabBarDelagate: MainTabBarControllerDeledate?
    
  
  
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
    searchBar(searchController.searchBar, textDidChange: "sia")
    
  }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let kayWindow = UIApplication.shared.connectedScenes.filter({
            $0.activationState == .foregroundActive
        }).map({
            $0 as? UIWindowScene
        }).compactMap({$0}).first?.windows.filter({
            $0.isKeyWindow
        }).first
        
        let tapBarVC = kayWindow?.rootViewController as? MainTabBarController
        tapBarVC?.trackDetailView.delagate = self
    }
    private func setupSearchBar(){
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cellViewModel = searchViewModel.cells[indexPath.row]
        self.tabBarDelagate?.maximizeTrackDetailController(viewModel: cellViewModel)
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
// MARK: - Track Movies Delegate
extension SearchViewController: TrackMoviesDelegate {
    
    private func getTrack(isForwordTreack: Bool) -> SearchViewModel.Cell? {
        guard let indexPath = table.indexPathForSelectedRow else { return nil }
        table.deselectRow(at: indexPath, animated: true)
        var nextIndexPath: IndexPath!
        if isForwordTreack {
            nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            if nextIndexPath.row == searchViewModel.cells.count {
                nextIndexPath.row = 0
            }
        }else {
               nextIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
               if  nextIndexPath.row == -1 {
                nextIndexPath.row = searchViewModel.cells.count - 1
                
                }
        }
        
        table.selectRow(at: nextIndexPath, animated: true, scrollPosition: .none)
        let cellModelView = searchViewModel.cells[nextIndexPath.row]
        return cellModelView
        }
        
    
    func moveBackForPreviusTrack() -> SearchViewModel.Cell? {
        return getTrack(isForwordTreack: false)
    }
    
    func moveForwordForPreviusTrack() -> SearchViewModel.Cell? {
        return getTrack(isForwordTreack: true)
    }
    
    
}
