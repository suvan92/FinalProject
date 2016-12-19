//
//  MakeChannelTestVC.swift
//  FinalProject
//
//  Created by Tim Beals on 2016-12-19.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit

class MakeChannelTestVC: UIViewController {

    @IBAction func makeNewChannel(_ sender: Any) {
        let channel = Channel()
        channel.savetoDatabase()
        User.sharedInstance.channels?.append(channel.id!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

}
