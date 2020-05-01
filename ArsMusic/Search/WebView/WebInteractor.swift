//
//  WebInteractor.swift
//  ArsMusic
//
//  Created by Arsen Mkrtchyan on 5/1/20.
//  Copyright (c) 2020 smu117. All rights reserved.
//

import UIKit

protocol WebBusinessLogic {
  func makeRequest(request: Web.Model.Request.RequestType)
}

class WebInteractor: WebBusinessLogic {

  var presenter: WebPresentationLogic?
  var service: WebService?
  
  func makeRequest(request: Web.Model.Request.RequestType) {
    if service == nil {
      service = WebService()
    }
  }
  
}
