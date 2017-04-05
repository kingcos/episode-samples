//
//  ViewController.swift
//  UITableViewDemo
//
//  Created by Mars on 4/2/16.
//  Copyright © 2016 Boxue. All rights reserved.
//

import UIKit

class EpisodeListViewController: UITableViewController {
    var episodeListItems: [EpisodeListItem] = []
    
    func getEpisodeListItemData() {
        for i in 0..<10 {
            let e = EpisodeListItem()
            e.title = "Episode \(i)"
            e.finished = i % 2 == 0 ? true : false
            
            episodeListItems.append(e)
        }
    }
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "EpisodeItem", for: indexPath)
        
        let label = cell.viewWithTag(1024) as! UILabel
        
        let title = self.episodeListItems[indexPath.row].title
        label.text = title
        
        cell.accessoryType = self.episodeListItems[indexPath.row].finished ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        getEpisodeListItemData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

