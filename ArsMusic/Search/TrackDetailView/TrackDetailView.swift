//
//  TrackDetailView.swift
//  ArsMusic
//
//  Created by Arsen Mkrtchyan on 4/23/20.
//  Copyright © 2020 smu117. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit

class TrackDetailView: UIView {
    
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLable: UILabel!
    @IBOutlet weak var durationLable: UILabel!
    @IBOutlet weak var trackNameLable: UILabel!
    @IBOutlet weak var artistNameLable: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        let scale: CGFloat = 0.8
        trackImage.transform = CGAffineTransform(scaleX: scale, y: scale)
        trackImage.layer.cornerRadius = 10
    }
    // MARK: - Setup
    func set(viewModel: SearchViewModel.Cell) {
        trackNameLable.text = viewModel.trackName
        trackNameLable.numberOfLines = 2
        artistNameLable.text = viewModel.artistName
        playTrack(previewUrl: viewModel.previewUrl)
        monitorStartTime()
        let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        guard let url = URL(string: string600 ?? "")  else { return }
        trackImage.sd_setImage(with: url, completed: nil)
        
        
    }
    
    private func playTrack(previewUrl: String?) {
        guard let url = URL(string: previewUrl ?? "") else { return }
        print(url)
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    // MARK: - time setup
    private func monitorStartTime() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlargeTrackImageView()
        }
    }
    
     // MARK: - Animations
    private func enlargeTrackImageView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.trackImage.transform = .identity
        }, completion: nil)
        
    }
    private func rediceTrackImageView() {
           UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            let scale: CGFloat = 0.8
            self.trackImage.transform = CGAffineTransform(scaleX: scale, y: scale)
                  }, completion: nil)
    }

    
    // MARK: -@IBAction
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
        if player.timeControlStatus == .paused {
            player.play()
            playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            enlargeTrackImageView()
        }else {
            player.pause()
            playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            rediceTrackImageView()
        }
    }
}
