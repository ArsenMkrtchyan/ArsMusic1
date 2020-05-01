//
//  WebViewController.swift
//  ArsMusic
//
//  Created by Arsen Mkrtchyan on 5/1/20.
//  Copyright (c) 2020 smu117. All rights reserved.
//

import UIKit
import WebKit

protocol WebDisplayLogic: class {
    func displayData(viewModel: Web.Model.ViewModel.ViewModelData)
}

class WebViewController: UIViewController, WebDisplayLogic {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var interactor: WebBusinessLogic?
    var router: (NSObjectProtocol & WebRoutingLogic)?
    
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
        let interactor            = WebInteractor()
        let presenter             = WebPresenter()
        let router                = WebRouter()
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
        setupSearchBar()
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.isHidden = true
        activityIndicator.hidesWhenStopped = true
    }
    
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.backgroundColor = .white
        searchBar.placeholder = "Select the web site"
        searchBar.setShowsCancelButton(true, animated: true)
        
    }
    
    private func request(url: String? ) {
        guard let text = url else { return }
        let myURL = URL(string:"https://"+text)
        guard let url = myURL else { return}
        let newRequest = URLRequest(url: url)
        webView.load(newRequest)
        searchBar.text = "https://"+text
        webView.isHidden = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    
    
    
    // MARK: Auctions
    
    @IBAction func googleButton(_ sender: Any) {
        request(url: "google.com")
        activityIndicator.startAnimating()
    }
    
    @IBAction func vkButton(_ sender: Any) {
        request(url: "vk.com")
        activityIndicator.startAnimating()
    }
    @IBAction func youtubeButton(_ sender: Any) {
        request(url: "youtube.com")
        activityIndicator.startAnimating()
    }
    @IBAction func instagramButton(_ sender: Any) {
        request(url: "instagram.com")
        activityIndicator.startAnimating()
        
    }
    @IBAction func goBack(_ sender: Any) {
        if webView.canGoBack {
            webView.goBack()
        }
        
    }    
    @IBAction func goForword(_ sender: Any) {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    @IBAction func refresh(_ sender: Any) {
        webView.reload()
        activityIndicator.startAnimating()
    }
    @IBAction func stop(_ sender: Any) {
        webView.stopLoading()
        activityIndicator.stopAnimating()
    }
    
    func displayData(viewModel: Web.Model.ViewModel.ViewModelData) {
        
    }
    
}
extension WebViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        webView.isHidden = false
        view.endEditing(true)
        request(url: searchBar.text)
        
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        webView.isHidden = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) { // 2
        webView.isHidden = false
        view.endEditing(true)
    }
    
}

extension WebViewController: WKUIDelegate,WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        searchBar.text = webView.title
        
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!,withError error: Error) {
        
        activityIndicator.stopAnimating()
    }
    func loadFileURL(URL allowingReadAccessTo: URL) -> WKNavigation? {
        print("lolo")
        return nil
    }
}
