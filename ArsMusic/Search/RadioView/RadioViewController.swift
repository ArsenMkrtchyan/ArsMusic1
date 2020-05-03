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
    var number: Int?
    var count: Int?
    var trackDetalView = TrackDetailView()
  
    
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
        delegateTrack()
        
    }
    
    
    func displayData(viewModel: Radio.Model.ViewModel.ViewModelData) {
        
    }
    private func delegateTrack(){
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
        count = stations.count
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
        number = indexPath.row + 1
        delegateTrack()
        let cellViewModel = stations[indexPath.row]
        self.tabBarDelagate?.maximizeRadioTrackDetailController(viewModel: cellViewModel)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return stations.count > 0 ? 0 : 250
    }
    
    
    
}
extension RadioViewController: TrackMoviesDelegate {
    
    private func getTrack(isForwordTreack: Bool) -> TrackCellViewModel? {
    guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
    tableView.deselectRow(at: indexPath, animated: true)
    var nextIndexPath: IndexPath!
    if isForwordTreack {
        nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
        if nextIndexPath.row == stations.count {
            nextIndexPath.row = 0
        }
    }else {
           nextIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
           if  nextIndexPath.row == -1 {
            nextIndexPath.row = stations.count - 1
            
            
            }
    }
    
    tableView.selectRow(at: nextIndexPath, animated: true, scrollPosition: .none)
    number = nextIndexPath.row + 1
    let cellModelView = stations[nextIndexPath.row]
    return cellModelView
        
    }
    func moveBackRadioForPreviusTrack() -> TrackCellViewModel? {
        
        return getTrack(isForwordTreack: false)
    }
    
    func moveForwordRadioForPreviusTrack() -> TrackCellViewModel? {
        
        return getTrack(isForwordTreack: true)
    }
    
    
    func moveBackForPreviusTrack() -> SearchViewModel.Cell? {
        return nil
    }
    
    func moveForwordForPreviusTrack() -> SearchViewModel.Cell? {
        return nil
    }
    
    var numberOfTracks: Int? {
        return count
    }
    
    var numberOfTrack: Int? {
        return number
    }
    
    
}
