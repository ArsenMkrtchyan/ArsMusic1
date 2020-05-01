//
//  WebPresenter.swift
//  ArsMusic
//
//  Created by Arsen Mkrtchyan on 5/1/20.
//  Copyright (c) 2020 smu117. All rights reserved.
//

import UIKit

protocol WebPresentationLogic {
  func presentData(response: Web.Model.Response.ResponseType)
}

class WebPresenter: WebPresentationLogic {
  weak var viewController: WebDisplayLogic?
  
  func presentData(response: Web.Model.Response.ResponseType) {
  
  }
  
}
