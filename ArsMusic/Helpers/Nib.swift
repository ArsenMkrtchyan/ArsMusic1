//
//  Nib.swift
//  ArsMusic
//
//  Created by Arsen Mkrtchyan on 4/26/20.
//  Copyright © 2020 smu117. All rights reserved.
//

import UIKit


extension UIView {
    
    class func loadFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?[0] as! T
    }
}
