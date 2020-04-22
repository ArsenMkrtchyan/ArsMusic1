//
//  UIViewController + Storybord.swift
//  ArsMusic
//
//  Created by Arsen Mkrtchyan on 4/22/20.
//  Copyright © 2020 smu117. All rights reserved.
//

import UIKit

extension UIViewController {
    
    class func loadFromStorybord<T: UIViewController>() -> T {
        let name = String(describing: T.self)
        let strorybord = UIStoryboard(name: name, bundle: nil)
        if let viewController = strorybord.instantiateInitialViewController() as? T {
            return viewController
        }else {
            fatalError("error no inital view controoler  in \(name) storybord" )
        }
    }
}
