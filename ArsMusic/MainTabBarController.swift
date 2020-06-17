//
//  MainTabBarController.swift
//  ArsMusic
//
//  Created by Arsen Mkrtchyan on 4/20/20.
//  Copyright © 2020 smu117. All rights reserved.
//

import UIKit
import SwiftUI
protocol MainTabBarControllerDeledate: class {
    func minimizeTrackDetailController()
    func maximizeTrackDetailController(viewModel:SearchViewModel.Cell?)
    func maximizeRadioTrackDetailController(viewModel:TrackCellViewModel?)
}


class MainTabBarController: UITabBarController {
    
    let searchVC: SearchViewController = SearchViewController.loadFromStorybord()
    let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()
    //let webVC: WebViewController = WebViewController.loadFromStorybord()
    private var minimaizedTopAnchorConstraint: NSLayoutConstraint!
    private var maximaizedTopAnchorConstraint: NSLayoutConstraint!
    private var bottomAnchorConstraint:NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tabBar.tintColor = #colorLiteral(red: 1, green: 0, blue: 0.3636507094, alpha: 1)
        setupTrackDetailView()
        searchVC.tabBarDelagate = self
        var library = Library()
        library.tapBarDelegate = self
        let hostVC = UIHostingController(rootView: library)
        hostVC.tabBarItem.image = #imageLiteral(resourceName: "ios10-apple-music-library-5nav-icon")
        hostVC.tabBarItem.title = "Library"
        let webVC = WebViewController()
        webVC.tabBarItem.title = "Web Search"
        webVC.tabBarItem.image = #imageLiteral(resourceName: "ios10-apple-music-search-5nav-icon")
        let radioVC = RadioViewController()
        radioVC.tabBarDelagate = self
       
        viewControllers = [
            hostVC,
            generateViewController(rootViewController: searchVC, image: #imageLiteral(resourceName: "Add"), title: "Apple Music"),
            webVC,
            generateViewController(rootViewController: radioVC, image: #imageLiteral(resourceName: "ios10-apple-music-search-5nav-icon"), title: "Radio Station")
            
        ]
    }
    
    private func generateViewController(rootViewController: UIViewController, image: UIImage, title: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        
        return navigationVC
    }
    
   
    
    private func setupTrackDetailView() {
        
        
        view.insertSubview(trackDetailView, belowSubview: tabBar)
        trackDetailView.tabBarDelegate = self
        trackDetailView.delagate = searchVC
        
        // use auto layout
        
       trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        maximaizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor,constant: view.frame.height)
        minimaizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        bottomAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
        maximaizedTopAnchorConstraint.isActive = true
        trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
    }
    
}
extension MainTabBarController: MainTabBarControllerDeledate {
    
    
    func maximizeTrackDetailController(viewModel: SearchViewModel.Cell?) {
        
        minimaizedTopAnchorConstraint.isActive = false
        maximaizedTopAnchorConstraint.isActive = true
        maximaizedTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0
        
        UIView.animate(withDuration: 0.5,
                              delay: 0,
                              usingSpringWithDamping: 0.7,
                              initialSpringVelocity: 1,
                              options: .curveEaseOut,
                              animations: {
                                
                                self.tabBar.alpha = 0
                                self.view.layoutIfNeeded()
                                self.trackDetailView.miniTrackView.alpha = 0
                                self.trackDetailView.maximizeStackView.alpha = 1
               }, completion: nil)
        
        guard let viewModel = viewModel else { return }
        self.trackDetailView.set(viewModel: viewModel,number: nil)
    }
    
    func minimizeTrackDetailController() {
        
        maximaizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimaizedTopAnchorConstraint.isActive = true
        
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        
                        self.view.layoutIfNeeded()
                        self.tabBar.alpha = 1
                        self.trackDetailView.maximizeStackView.alpha = 0
                        self.trackDetailView.miniTrackView.alpha = 1
        }, completion: nil)
    }
    
    func maximizeRadioTrackDetailController(viewModel: TrackCellViewModel?) {
        
        minimaizedTopAnchorConstraint.isActive = false
        maximaizedTopAnchorConstraint.isActive = true
        maximaizedTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0
        
        UIView.animate(withDuration: 0.5,
                              delay: 0,
                              usingSpringWithDamping: 0.7,
                              initialSpringVelocity: 1,
                              options: .curveEaseOut,
                              animations: {
                                
                                self.tabBar.alpha = 0
                                self.view.layoutIfNeeded()
                                self.trackDetailView.miniTrackView.alpha = 0
                                self.trackDetailView.maximizeStackView.alpha = 1
               }, completion: nil)
        
        guard let viewModel = viewModel else { return }
        self.trackDetailView.setRadio(viewModel: viewModel)
    }
    
    
    
}

