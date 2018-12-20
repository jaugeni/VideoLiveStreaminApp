//
//  PlayerVC.swift
//  LiveStreaminApp
//
//  Created by YAUHENI IVANIUK on 11/29/18.
//  Copyright © 2018 Yauheni Ivaniuk. All rights reserved.
//

import UIKit
import AVKit

class PlayerVC: UIViewController {
  
  private enum Constant {
    static let playImage = UIImage(named: "Play")
    static let pauseImage = UIImage(named: "Pause")
    static let keyPathStatic = "status"
  }
  
  @IBOutlet weak var closeButton: RoundedButton!
  @IBOutlet weak var controlView: UIView!
  @IBOutlet weak var playPouseBtn: UIButton!
  @IBOutlet weak var currentDuration: UILabel!
  @IBOutlet weak var overallduration: UILabel!
  @IBOutlet weak var playBackSlider: UISlider!
  
  var videoUrl: URL?
  var player: AVPlayer?
  var isPlaying = false
  var isHidden = true
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    startVideo()
    addTapGesture()
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
    return .landscapeLeft
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == Constant.keyPathStatic {
      if player?.status == .readyToPlay {
        player?.play()
        setPlayButtonImage(isPlay: isPlaying)
        videoController(isHidden)
        isPlaying = true
      }
    }
  }
  
  private func startVideo() {
    guard let videoUrl = videoUrl else { return }
    player = AVPlayer(url: videoUrl)
    
    player?.addObserver(self, forKeyPath: Constant.keyPathStatic, options: NSKeyValueObservingOptions.new, context: nil)
    let playerLayer = AVPlayerLayer(player: player)
    view.layer.addSublayer(playerLayer)
    playerLayer.frame = view.frame
    
    guard let duration = player?.currentItem?.asset.duration else { return }
    let seconds = CMTimeGetSeconds(duration)
    playBackSlider.maximumValue = Float(seconds)
    overallduration.text = stringFromTimeInterval(interval: seconds)
    player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main, using: { [weak self] (currentTime) in
      guard let self = self else { return }
      let time = CMTimeGetSeconds(currentTime)
      self.currentDuration.text = self.stringFromTimeInterval(interval: time)
      print(time)
      self.playBackSlider.setValue(Float(time), animated: true)
    })
    
    playBackSlider.addTarget(self, action: #selector(playBackSliderAction(_:)), for: .valueChanged)
    
    view.bringSubviewToFront(closeButton)
    view.bringSubviewToFront(controlView)
  }
  
  private func addTapGesture() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(taggleGesture(_:)))
    view.addGestureRecognizer(tapGesture)
  }
  
  private func videoController(_ status: Bool) {
    closeButton.isHidden = status
    controlView.isHidden = status
    isHidden = !isHidden
  }
  
  private func setPlayButtonImage(isPlay: Bool) {
    guard let image = isPlay ? Constant.playImage : Constant.pauseImage else { return }
    playPouseBtn.setImage(image, for: .normal)
  }
  
  @IBAction private func taggleGesture(_ sender: UITapGestureRecognizer) {
    videoController(isHidden)
  }
  
  @IBAction func playBackSliderAction(_ sender: UISlider) {
    player?.pause()
    let seekTime = CMTime(value: CMTimeValue(sender.value), timescale: 1)
    self.currentDuration.text = self.stringFromTimeInterval(interval: Double(sender.value))
    player?.seek(to: seekTime, completionHandler: { (compleated) in
      if self.isPlaying {
        self.player?.play()
      } else {
        self.player?.pause()
      }
    })
  }
  
  @IBAction func closeButtonPressed(_ sender: Any) {
    player = nil
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func playPousePressed(_ sender: Any) {
    setPlayButtonImage(isPlay: isPlaying)
    if isPlaying {
      player?.pause()
    } else {
      player?.play()
    }
    isPlaying = !isPlaying
  }
  
  //MARK: Helpers
  func stringFromTimeInterval(interval: TimeInterval) -> String {
    let interval = Int(interval)
    let seconds = interval % 60
    let minutes = (interval / 60) % 60
    let hours = (interval / 3600)
    return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
  }
}
