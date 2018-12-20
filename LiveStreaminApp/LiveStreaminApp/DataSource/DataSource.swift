//
//  DataSource.swift
//  LiveStreaminApp
//
//  Created by YAUHENI IVANIUK on 11/29/18.
//  Copyright © 2018 Yauheni Ivaniuk. All rights reserved.
//

import Foundation

class DataSource {
  
  private var videos = [Video]()
  
  init() {
    videos = createDemoData()
  }
  
  func numberOfCell() -> Int {
    return videos.count
  }
  
  func urlFor(_ index: Int) -> URL? {
    guard let videoUrl = URL(string: videos[index].url) else { return nil}
    return videoUrl
  }
  
  func celTitleFor(_ index: Int) -> String {
    return videos[index].name
  }
  
  private func createDemoData() -> [Video] {
    var videos = [Video]()
    let franchVideo = Video(name: "French Video", url: "https://video-dev.github.io/streams/test_001/stream.m3u8")
    let bigBuckBunny = Video(name: "Big Buck Bunny", url: "https://video-dev.github.io/streams/x36xhzz/x36xhzz.m3u8")
    videos.append(franchVideo)
    videos.append(bigBuckBunny)
    return videos
  }
}
