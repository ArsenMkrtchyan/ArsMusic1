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

protocol TrackMoviesDelegate {
    func moveBackForPreviusTrack() -> SearchViewModel.Cell?
    func moveForwordForPreviusTrack() -> SearchViewModel.Cell?
}

class TrackDetailView: UIView{
    
    @IBOutlet weak var miniTrackView: UIView!
    @IBOutlet weak var miniTrackTitleLable: UILabel!
    @IBOutlet weak var miniTrackImageview: UIImageView!
    @IBOutlet weak var miniPlayPauseButtonb: UIButton!
    @IBOutlet weak var maximizeStackView: UIStackView!
    @IBOutlet weak var miniGoForwordButton: UIButton!
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLable: UILabel!
    @IBOutlet weak var durationLable: UILabel!
    @IBOutlet weak var trackNameLable: UILabel!
    @IBOutlet weak var artistNameLable: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    var delagate: TrackMoviesDelegate?
    weak var tabBarDelegate: MainTabBarControllerDeledate?
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
        setupGesture()
        miniPlayPauseButtonb.imageEdgeInsets = .init(top: 11, left: 11, bottom: 11, right: 11)
        
    }
    // MARK: - Setup viewModel
    
    func set(viewModel: SearchViewModel.Cell) {
        trackNameLable.text = viewModel.trackName
        trackNameLable.numberOfLines = 2
        miniTrackTitleLable.text = viewModel.trackName
        artistNameLable.text = viewModel.artistName
        playTrack(previewUrl: viewModel.previewUrl)
        monitorStartTime()
        observeLayerCurrentTime()
        playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        miniPlayPauseButtonb.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        guard let url = URL(string: string600 ?? "")  else { return }
        trackImage.sd_setImage(with: url, completed: nil)
        miniTrackImageview.sd_setImage(with: url, completed: nil)
        
        
    }
    
    private func setupGesture() {
        miniTrackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximized)))
        miniTrackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlDismissPan)))
    }
    
    private func playTrack(previewUrl: String?) {
        guard let url = URL(string: previewUrl ?? "") else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    //MARK: -Maximasing an d minimazing gestures
    
    @objc private func handleTapMaximized() {
        self.tabBarDelegate?.maximizeTrackDetailController(viewModel: nil)
            
    }
    @objc private func handlePan(gestures:UIPanGestureRecognizer) {
        
        switch gestures.state { 
        case .changed:
            handlePanChanged(gesture: gestures)
        case .ended:
            handlePanEnded(gesture: gestures)
        
        default:
            print("gestures error")
        }
    }
    @objc private func handlDismissPan(gestures:UIPanGestureRecognizer) {
        switch gestures.state {
        case .changed:
            let translation = gestures.translation(in: self.superview)
            maximizeStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        case .ended:
            let translation = gestures.translation(in: self.superview)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.maximizeStackView.transform = .identity
                if translation.y > 50  {
                    self.tabBarDelegate?.minimizeTrackDetailController()
                }
            }, completion: nil)
        default:
            print("handlDismissPan switch")
        }
    }
    
    private func handlePanChanged(gesture: UIPanGestureRecognizer) {
           let translation = gesture.translation(in: self.superview)
           self.transform = CGAffineTransform(translationX: 0, y: translation.y)
           
           let newAlpha = 1 + translation.y / 200
           self.miniTrackView.alpha = newAlpha < 0 ? 0 : newAlpha
           self.maximizeStackView.alpha = -translation.y / 200
       }
    
     private func handlePanEnded(gesture: UIPanGestureRecognizer) {
           let translation = gesture.translation(in: self.superview)
           let velocity = gesture.velocity(in: self.superview)
           
           UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
               self.transform = .identity
               if translation.y < -200 || velocity.y < -500 {
                   self.tabBarDelegate?.maximizeTrackDetailController(viewModel: nil)
               } else {
                   self.miniTrackView.alpha = 1
                   self.maximizeStackView.alpha = 0
               }
           }, completion: nil)
       }
    // MARK: - Time setup
    private func monitorStartTime() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlargeTrackImageView()
        }
    }
    
    private func updateCurrentTimeSlider() {
        let currentTimeSecend = CMTimeGetSeconds(player.currentTime())
        let durationSecends = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSecend / durationSecends
        self.currentTimeSlider.value = Float(percentage)
        
        
        
    }
    
    // MARK: -Current Time Lable text
    private func observeLayerCurrentTime() {
        let time = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] (time) in
            self?.currentTimeLable.text = time.toDisplayString()
            
            let durationTime = self?.player.currentItem?.duration
            let currentDurationText = ((durationTime ?? CMTimeMake(value: 1, timescale: 2)) - time ).toDisplayString()
            self?.durationLable.text = "-\(currentDurationText)"
            self?.updateCurrentTimeSlider()
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
    @IBAction func dragDownButtonTapped(_ sender: UIButton) {
        //self.removeFromSuperview()
        self.tabBarDelegate?.minimizeTrackDetailController()
    }
    
    @IBAction func handleCurrentTime(_ sender: UISlider) {
        let persenteg = currentTimeSlider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationInSecend = CMTimeGetSeconds(duration)
        let seekTimeUnSecund = Float64(persenteg) * durationInSecend
        let seekTime = CMTimeMakeWithSeconds(seekTimeUnSecund, preferredTimescale: 1)
        player.seek(to: seekTime)
        
        
    }
    @IBAction func handelVolumeSlider(_ sender: Any) {
        player.volume = volumeSlider.value
    }
    @IBAction func previousTrack(_ sender: Any) {
        guard let cellViewModel = delagate?.moveBackForPreviusTrack() else { return }
        self.set(viewModel: cellViewModel)
    }
    
    @IBAction func nextTrack(_ sender: Any) {
        guard let cellViewModel = delagate?.moveForwordForPreviusTrack() else { return }
        self.set(viewModel: cellViewModel)
    }
    
    @IBAction func playPauseAction(_ sender: Any) {
        if player.timeControlStatus == .paused {
            player.play()
            playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            miniPlayPauseButtonb.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            enlargeTrackImageView()
        }else {
            player.pause()
            miniPlayPauseButtonb.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            rediceTrackImageView()
        }
    }
}
