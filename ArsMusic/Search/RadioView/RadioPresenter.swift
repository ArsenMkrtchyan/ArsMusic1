//
//  RadioPresenter.swift
//  ArsMusic
//
//  Created by Arsen Mkrtchyan on 5/2/20.
//  Copyright (c) 2020 smu117. All rights reserved.
//

import UIKit

protocol RadioPresentationLogic {
  func presentData(response: Radio.Model.Response.ResponseType)
}

class RadioPresenter: RadioPresentationLogic {
  weak var viewController: RadioDisplayLogic?
  
  func presentData(response: Radio.Model.Response.ResponseType) {
  
  }
  
}
