//
//  RadioInteractor.swift
//  ArsMusic
//
//  Created by Arsen Mkrtchyan on 5/2/20.
//  Copyright (c) 2020 smu117. All rights reserved.
//

import UIKit

protocol RadioBusinessLogic {
  func makeRequest(request: Radio.Model.Request.RequestType)
}

class RadioInteractor: RadioBusinessLogic {

  var presenter: RadioPresentationLogic?
  var service: RadioService?
  
  func makeRequest(request: Radio.Model.Request.RequestType) {
    if service == nil {
      service = RadioService()
    }
  }
  
}
