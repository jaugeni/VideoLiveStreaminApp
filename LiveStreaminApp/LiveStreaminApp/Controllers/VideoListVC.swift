//
//  ViewController.swift
//  LiveStreaminApp
//
//  Created by YAUHENI IVANIUK on 11/28/18.
//  Copyright © 2018 Yauheni Ivaniuk. All rights reserved.
//

import UIKit

class VideoListVC: UITableViewController {
  
  private enum Constants {
    static let cellId = "Cell"
    static let toPlayer = "toPlayer"
  }
  
  @IBOutlet var videoCollection: UITableView!
  
  var dataSource = DataSource()
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let playrVC = segue.destination as? PlayerVC,
      let urlString = sender as? URL
      else { return }
    playrVC.videoUrl = urlString
  }
}

extension VideoListVC {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.numberOfCell()
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath)
    cell.textLabel?.text = dataSource.celTitleFor(indexPath.row)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: Constants.toPlayer, sender: dataSource.urlFor(indexPath.row))
  }
}

