//
//  PublicRepositoriesTableViewCell.swift
//  GitHub
//
//  Created by Admin on 4/30/20.
//  Copyright © 2020 Vartan Shahjahanian. All rights reserved.
//

import UIKit

class PublicRepositoriesTableViewCell: UITableViewCell {
    
    let repoNameLablel: UILabel
    let numberOfForksLablel: UILabel
    let numberOfStrarsLablel: UILabel
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.repoNameLablel = UILabel(frame: .zero)
        self.repoNameLablel.numberOfLines = 1
        self.numberOfForksLablel = UILabel(frame: .zero)
        self.numberOfForksLablel.numberOfLines = 1
        self.numberOfStrarsLablel = UILabel(frame: .zero)
        self.numberOfStrarsLablel.numberOfLines = 1
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.repoNameLablel.translatesAutoresizingMaskIntoConstraints = false
        self.numberOfForksLablel.translatesAutoresizingMaskIntoConstraints = false
        self.numberOfStrarsLablel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.repoNameLablel)
        self.addSubview(self.numberOfForksLablel)
        self.addSubview(self.numberOfStrarsLablel)
        
        
        //repoNameLablel constraint
        self.repoNameLablel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5.0).isActive = true
        self.repoNameLablel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0).isActive = true
        self.repoNameLablel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5.0).isActive = true
       //numberOfForksLablel constraint
        self.numberOfForksLablel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0 ).isActive = true
        self.numberOfForksLablel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5.0 ).isActive = true
        //numberOfStrarsLablel constraint
        
        self.numberOfStrarsLablel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5.0).isActive = true
        self.numberOfStrarsLablel.topAnchor.constraint(equalTo: self.numberOfForksLablel.bottomAnchor, constant: 5.0).isActive = true
        self.numberOfStrarsLablel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5.0).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("initWithCoder: inaccessible")
    }
}


