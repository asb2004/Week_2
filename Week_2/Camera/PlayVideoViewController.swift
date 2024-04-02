//
//  PlayVideoViewController.swift
//  iOS_010
//
//  Created by DREAMWORLD on 27/02/24.
//

import UIKit
import AVFoundation

class PlayVideoViewController: UIViewController {

    @IBOutlet var videoView: UIView!
    
    var playButton: UIBarButtonItem!
    var pauseButton: UIBarButtonItem!
    
    var player: AVPlayer?
    var urlIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.hidesBarsOnTap = true
        
        let space0 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        playButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(playButtonTapped))
        let space1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        pauseButton = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(pauseButtonTapped))
        let space2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        navigationController?.setToolbarHidden(false, animated: false)
        navigationController?.toolbar.isUserInteractionEnabled = true
        navigationController?.toolbar.backgroundColor = .white
        navigationController?.hidesBarsOnTap = true
        self.setToolbarItems([space0, playButton, space1, pauseButton, space2], animated: false)
        
        playVideo()
        
        playButton.isEnabled = true
        pauseButton.isEnabled = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        player?.pause()
    }
    
    @objc func playButtonTapped() {
        player?.play()
        playButton.isEnabled = false
        pauseButton.isEnabled = true
    }
    
    @objc func pauseButtonTapped() {
        player?.pause()
        playButton.isEnabled = true
        pauseButton.isEnabled = false
    }
    
    func playVideo() {
        player = AVPlayer(url: videoURLs[urlIndex])
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.videoView.bounds
        playerLayer.videoGravity = .resizeAspect
        videoView.layer.addSublayer(playerLayer)
        //self.view.layer.addSublayer(playerLayer)
        
        let reset = {
            self.player?.seek(to: .zero)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: nil) { notification in
            self.playButton.isEnabled = true
            self.pauseButton.isEnabled = false
            reset()
        }
//        player?.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
    }
    
//    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
//            let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
//            let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
//            if newStatus != oldStatus {
//                DispatchQueue.main.async {[weak self] in
//                    if newStatus == .playing || newStatus == .paused {
//                        self?.activityIndicator.isHidden = true
//                    } else {
//                        self?.activityIndicator.isHidden = false
//                    }
//                }
//            }
//        }
//    }
    
    
}
