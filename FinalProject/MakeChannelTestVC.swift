//
//  MakeChannelTestVC.swift
//  FinalProject
//
//  Created by Tim Beals on 2016-12-19.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit
import Firebase

class MakeChannelTestVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let userRef = FIRDatabase.database().reference(withPath: "users")
    
    @IBOutlet weak var tableView: UITableView!
    var datasource: [String]?
    
    @IBAction func makeNewChannel(_ sender: Any) {
        let user = User.sharedInstance
        let channel = Channel()
        channel.savetoDatabase() {
            user.addChannel(withID: channel.id!, completion: {
                self.tableView.reloadData()
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupObservers()
    }
    
    
    //MARK: tableview datasource methods
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
    
    //MARK: tableview delegate methods
    //override??
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let channelId = datasource?[indexPath.row]
            self.performSegue(withIdentifier: "ShowChannel", sender: channelId)
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let channelId = sender as? String {
            let chatVc = segue.destination as! ChatViewController
            let channel = Channel()
            channel.id = channelId
            chatVc.channel = channel
            chatVc.channelRef = channel.databaseRef
            chatVc.senderDisplayName = User.sharedInstance.email
        }
    }

    //MARK: VC observe for channels added or removed to update tableView
    func setupObservers() {
        let user = User.sharedInstance
        
        userRef.child(user.uid!).child("channels").observe(.childAdded, with: { snapshot in
            guard let channel = snapshot.value as? String else { return }
            if self.datasource == nil {
                self.datasource = [channel]
            } else {
                self.datasource?.append(channel)
            }
            let row = (self.datasource?.count)! - 1
            let indexPath = IndexPath(row: row, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .top)
        })
        
        userRef.child(user.uid!).child("channels").observe(.childRemoved, with: { snapshot in
            guard let channelToFind = snapshot.value as? String else { return }
            for (index, channel) in (self.datasource?.enumerated())! {
                if channel == channelToFind {
                    let indexPath = IndexPath(row: index, section: 0)
                    self.datasource?.remove(at: index)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        })
    }
    
    

}
