//
//  TrackCell.swift
//  ArsMusic
//
//  Created by Arsen Mkrtchyan on 4/22/20.
//  Copyright © 2020 smu117. All rights reserved.
//

import UIKit

protocol TrackCellViewModel {
    var iconUrlString: String {get}
    var trackName: String {get}
    var collectinName: String {get}
    var artistName: String {get}
}

class TrackCell: UITableViewCell {
    static let reusleId = "TrackCell"
    
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var collectinName: UILabel!
    
    @IBOutlet weak var treckImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(viewModel: TrackCellViewModel) {
        artistName.text = viewModel.artistName
        trackName.text = viewModel.trackName
        collectinName.text = viewModel.collectinName
    }
}
