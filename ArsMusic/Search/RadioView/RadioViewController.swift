//
//  RadioViewController.swift
//  ArsMusic
//
//  Created by Arsen Mkrtchyan on 5/2/20.
//  Copyright (c) 2020 smu117. All rights reserved.
//

import UIKit
import Alamofire
import MediaPlayer
import AVFoundation

protocol RadioDisplayLogic: class {
    func displayData(viewModel: Radio.Model.ViewModel.ViewModelData)
}

class RadioViewController: UIViewController, RadioDisplayLogic{
    private lazy var footerView = FooterView()
    @IBOutlet weak var tableView: UITableView!
    var interactor: RadioBusinessLogic?
    var router: (NSObjectProtocol & RadioRoutingLogic)?
    var stations = [RadioStation]()
    weak var tabBarDelagate: MainTabBarControllerDeledate?
  
    
    var previousStation: RadioStation?
    
    // MARK: - UI
    
    var searchController: UISearchController = {
        return UISearchController(searchResultsController: nil)
    }()
    
    var refreshControl: UIRefreshControl = {
        return UIRefreshControl()
    }()
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = RadioInteractor()
        let presenter             = RadioPresenter()
        let router                = RadioRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: Routing
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
        let nib = UINib(nibName: "TrackCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: TrackCell.reusleId)
        tableView.tableFooterView = footerView
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadStationsFromJSON()
        navigationItem.title = "Radio Stetion"
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    
    func displayData(viewModel: Radio.Model.ViewModel.ViewModelData) {
        
    }
 
    func loadStationsFromJSON() {
        
        DataManager.getStationDataWithSuccess() { (data) in
            
            if kDebugLog { print("Stations JSON Found") }
            
            guard let data = data, let jsonDictionary = try? JSONDecoder().decode([String: [RadioStation]].self, from: data), let stationsArray = jsonDictionary["station"] else {
                if kDebugLog { print("JSON Station Loading Error") }
                return
            }
            self.stations = stationsArray
        }
    }
    
}
extension RadioViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.reusleId, for: indexPath) as! TrackCell
        let cellViewModel = stations[indexPath.row]
        cell.setRadio(viewModel: cellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = stations[indexPath.row]
        self.tabBarDelagate?.maximizeRadioTrackDetailController(viewModel: cellViewModel)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return stations.count > 0 ? 0 : 250
    }
    
    
    
}
