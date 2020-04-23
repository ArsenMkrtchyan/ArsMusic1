//
//  FooterView.swift
//  ArsMusic
//
//  Created by Arsen Mkrtchyan on 4/23/20.
//  Copyright © 2020 smu117. All rights reserved.
//

import UIKit

class FooterView: UIView {
    private var myLabel: UILabel = {
        var lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textAlignment = .center
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.textColor = #colorLiteral(red: 0.631372549, green: 0.6470588235, blue: 0.662745098, alpha: 1)
        return lable
    }()
    private var loder: UIActivityIndicatorView = {
        let loder = UIActivityIndicatorView()
        loder.translatesAutoresizingMaskIntoConstraints = false
        loder.hidesWhenStopped = true
        
        return loder
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupElements()
    }
    
    
    private func setupElements() {
        addSubview(myLabel)
        addSubview(loder)
        
        loder.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        loder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        loder.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        myLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        myLabel.topAnchor.constraint(equalTo: loder.bottomAnchor, constant: 8).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showLoder() {
        loder.startAnimating()
        myLabel.text = "Loding"
    }
    func hideLoder() {
        loder.stopAnimating()
        myLabel.text = ""
    }
}
