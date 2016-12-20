//
//  ChatViewController.swift
//  FinalProject
//
//  Created by Tim Beals on 2016-12-19.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {
    
    //MARK: Properties
//    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
//    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    var channelRef: FIRDatabaseReference?
    var channel: Channel?
//    private lazy var messageRef: FIRDatabaseReference = self.channelRef!.child("messages")
//    private var newMessageRefHandle: FIRDatabaseHandle?
//    var messages = [JSQMessage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        senderId = FIRAuth.auth()?.currentUser?.uid
        print(channel?.id ?? "no channel passed")
    }
    

    
    


}
