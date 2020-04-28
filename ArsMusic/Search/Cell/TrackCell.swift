//
//  TrackCell.swift
//  ArsMusic
//
//  Created by Arsen Mkrtchyan on 4/22/20.
//  Copyright © 2020 smu117. All rights reserved.
//

import UIKit
import SDWebImage

protocol TrackCellViewModel {
    var iconUrlString: String? {get}
    var trackName: String {get}
    var collectinName: String {get}
    var artistName: String {get}
}

class TrackCell: UITableViewCell {
    
    static let reusleId = "TrackCell"
    var cell: SearchViewModel.Cell?

    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var collectinName: UILabel!
    
    @IBOutlet weak var treckImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func prepareForReuse() {
        treckImageView.image = nil
    }
    
    func set(viewModel: SearchViewModel.Cell) {
        self.cell = viewModel
        artistName.text = viewModel.trackName
        trackName.text = viewModel.artistName
        collectinName.text = viewModel.collectinName
        
        guard let url = URL(string: viewModel.iconUrlString ?? "") else { return }
        treckImageView.sd_setImage(with: url, completed: nil)
    }
    
    @IBAction func addtTrackAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        if let saveData = try? NSKeyedArchiver.archivedData(withRootObject: cell!, requiringSecureCoding: false) {
            defaults.set(saveData, forKey: "tracks")
            print("saved corect")
        }
        
        
        
    }
    @IBAction func lookWhatWeWhontAdd(_ sender: Any) {
        let defaults = UserDefaults.standard
        if let saveData = defaults.object(forKey: "tracks") as? Data {
            if let decodedTrack = try? NSKeyedUnarchiver
                .unarchiveTopLevelObjectWithData(saveData)
                as? SearchViewModel.Cell {
                print(decodedTrack.artistName)
            }
            
    }
    }
}
