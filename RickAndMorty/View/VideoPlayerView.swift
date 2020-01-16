//
//  VideoPlayerView.swift
//  VideoPlayer
//
//  Created by Eri on 10/22/19.
//  Copyright © 2019 Eri. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView
{
    private let requiredAssetKeys = [
        "playable",
        "hasProtectedContent"
    ]
    private var asset: AVAsset!
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem!
    private var playbackRate: Float = 0.50
    // Key-value observing context
    private var playerItemContext = 0
    private var isPlaying = false
    private var isFullScreen = false
    
    lazy var pausePlayButton: UIButton = {
        let button = UIButton(type: .custom)
        button.isHidden = true
        let image = UIImage(named: "simple_play_button")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.addTarget(self, action: #selector(pausePlayButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override public class var layerClass: Swift.AnyClass {
        return AVPlayerLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(pausePlayButton)
        setupPausePlayButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        if playerItem != nil {
            playerItem.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
            print("remove player status observer")
        }
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupPlayerView(url: URL, with videoGravity: AVLayerVideoGravity) {
        print("setup player for url: \(url.path)")
        
        // Create the asset to play
        asset = AVAsset(url: url)
        
        
        // Create a new AVPlayerItem with the asset and an
        // array of asset keys to be automatically loaded
        playerItem = AVPlayerItem(asset: asset,
                                  automaticallyLoadedAssetKeys: requiredAssetKeys)
        
        
        // Register as an observer of the player item's status property
        playerItem.addObserver(self,
                               forKeyPath: #keyPath(AVPlayerItem.status),
                               options: [.old, .new],
                               context: &playerItemContext)
        
        // Associate the player item with the player
        player = AVPlayer(playerItem: playerItem)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(note:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        
        guard let avPlayerLayer = layer as? AVPlayerLayer else { return }
        avPlayerLayer.videoGravity = videoGravity
        avPlayerLayer.player = player
    }
    
    func removeVideoPlayer() {
        guard let avPlayerLayer = self.layer as? AVPlayerLayer else { return }
        avPlayerLayer.player = nil
        avPlayerLayer.removeFromSuperlayer()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // Only handle observations for the playerItemContext
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
            return
        }
        
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            // Switch over status value
            switch status {
            case .readyToPlay:
                print("av player item is ready to play")
                
            // Player item is ready to play.
            case .failed:
                // Player item failed. See error.
                print("player item failed state")
            case .unknown:
                // Player item is not yet ready.
                print("unknown state")
            @unknown default:
                fatalError()
            }
        }
    }
    
    func play() {
        player?.play()
        player?.rate = playbackRate
        isPlaying = true
    }
    
    func pause() {
        player?.pause()
        isPlaying = false
    }
    
    func seek(to timeInSecs: Double) {
        let playerTimescale = player?.currentItem?.asset.duration.timescale ?? 1
        let time =  CMTime(seconds: timeInSecs + ((timeInSecs < 0.001) ? 0.05 : 0.0), preferredTimescale: playerTimescale)
        player?.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero) { (finished) in
        }
    }
    
    func updateTime(offset: Double) {
        let playerTimescale = player?.currentItem?.asset.duration.timescale ?? 1
        let currTime: Double = player?.currentItem?.currentTime().seconds ?? 0
        let time =  CMTime(seconds: currTime + offset, preferredTimescale: playerTimescale)
        
        player?.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero) { (finished) in
        }
    }
    
    private func setupPausePlayButton() {
        NSLayoutConstraint.activate([
            pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            pausePlayButton.widthAnchor.constraint(equalToConstant: 50.0),
            pausePlayButton.heightAnchor.constraint(equalToConstant: 50.0)
            ])
    }
    
    @objc private func pausePlayButtonTapped() {
        if isPlaying {
            pause()
            pausePlayButton.setImage(UIImage(named: "simple_play_button")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        else {
            play()
            pausePlayButton.setImage(UIImage(named: "pause icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    @objc private func playerDidFinishPlaying(note: NSNotification) {
        pausePlayButton.setImage(UIImage(named: "simple_play_button")?.withRenderingMode(.alwaysTemplate), for: .normal)
        seek(to: 0.0)
        isPlaying = false
    }
}
