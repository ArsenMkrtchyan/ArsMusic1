//
//  TrackDetailView.swift
//  ArsMusic
//
//  Created by Arsen Mkrtchyan on 4/23/20.
//  Copyright © 2020 smu117. All rights reserved.
//

import UIKit

class TrackDetailView: UIView {
    
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLable: UILabel!
    @IBOutlet weak var durationLable: UILabel!
    @IBOutlet weak var trackNameLable: UILabel!
    @IBOutlet weak var artistNameLable: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func dragDownButtontapped(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    @IBAction func handleCurrentTime(_ sender: UISlider) {
    }
    @IBAction func handelVolumeSlider(_ sender: Any) {
    }
    @IBAction func previousTrack(_ sender: Any) {
    }
    
    @IBAction func nextTrack(_ sender: Any) {
    }
    
    @IBAction func playPauseAction(_ sender: Any) {
    }
}
