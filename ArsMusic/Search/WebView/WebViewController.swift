//
//  WebViewController.swift
//  ArsMusic
//
//  Created by Arsen Mkrtchyan on 5/1/20.
//  Copyright (c) 2020 smu117. All rights reserved.
//

import UIKit

protocol WebDisplayLogic: class {
  func displayData(viewModel: Web.Model.ViewModel.ViewModelData)
}

class WebViewController: UIViewController, WebDisplayLogic {

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
  }
  
  func displayData(viewModel: Web.Model.ViewModel.ViewModelData) {

  }
  
}
