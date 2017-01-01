//
//  TagTextFieldTableViewCell.swift
//  FinalProject
//
//  Created by Tim Beals on 2016-12-20.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit
import WSTagsField

class TagTextFieldTableViewCell: UITableViewCell {
    
    var tags = [String]()

    let tagTextField: WSTagsField = {
        let tagsField = WSTagsField()
        tagsField.tag = 1
        tagsField.placeholder = "Enter tags..."
        tagsField.backgroundColor = .white
        tagsField.spaceBetweenTags = 10.0
        tagsField.font = .systemFont(ofSize: 17.0)
        tagsField.translatesAutoresizingMaskIntoConstraints = false
        return tagsField
    }()
    
    func setup() {
        self.contentView.addSubview(tagTextField)
        tagTextField.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        tagTextField.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        tagTextField.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        
        // Events
        tagTextField.onDidAddTag = { field, tag in
            let tag = tag.text as String
            self.tags.append(tag)
        }
        
        tagTextField.onDidRemoveTag = { _ in
            self.tags.removeLast()
        }
    }
}
