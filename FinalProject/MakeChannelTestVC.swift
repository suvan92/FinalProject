//
//  MakeChannelTestVC.swift
//  FinalProject
//
//  Created by Tim Beals on 2016-12-19.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit

class MakeChannelTestVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var datasource: [String]?
    
    @IBAction func makeNewChannel(_ sender: Any) {
        let channel = Channel()
        channel.savetoDatabase()
        User.sharedInstance.channels?.append(channel.id!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datasource = User.sharedInstance.channels as [String]?
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let source = datasource {
            return source.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentChannels", for: indexPath)
        cell.textLabel?.text = User.sharedInstance.channels?[indexPath.row]
        return cell
    }
    
    

}
