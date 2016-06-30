//
//  ViewController.swift
//  ContactsInvite
//
//  Created by Joe E. on 6/30/16.
//  Copyright © 2016 Montchat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

}

class User {
    
    typealias Name = String
    typealias Email = String
    typealias PhoneNumber = String
    
    let name:Name!
    let email:Email!
    let phoneNumber:PhoneNumber?
    
    var following:[User]!
    var followers:[User]!
    
    init(name:Name, email:Email, phoneNumber: PhoneNumber?) {
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        
        following = []
        followers = []
        
    }
    
    func follow(user:User) {
        following.append(user)
        
    }
    
}

class ContactsCell : UITableViewCell {
    
    
    
}

