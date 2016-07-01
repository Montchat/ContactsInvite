//
//  ViewController.swift
//  ContactsInvite
//
//  Created by Joe E. on 6/30/16.
//  Copyright © 2016 Montchat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    typealias Name = String
    typealias Email = String
    typealias PhoneNumber = String
    
    var currentUser:OurPhoneUser!

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstNames:[Name] = ["Allen", "Bennett", "Chloe", "Daniel" , "Evan", "Farah" , "George" , "Heidi", "Ian", "Jon", "Katherine", "Louis" , "Margaret", "Nathan" , "Ozzie", "Peter" , "Quinton", "Rachel", "Stephen" , "Travis", "Ursula", "Vick" , "William", "Xultan", "Zorro" ]
        
        
        let lastName:Name = "Johnson"
        
        var contacts:[Contact] = [ ]
        
        var following:[User] = [ ]
        
        var followers:[User] = [ ]
        
        for i in 0..<firstNames.count {
            
            let firstName = firstNames[i]
            let phoneNumber:PhoneNumber = "(555) 555-55" + "\(i)"
            let email1:Email = "\(firstName)" + "@mail.com"
            let email2:Email = "\(firstName)" + "@milkmail.com"
            
            let contact = Contact(firstName: firstName, lastName: lastName, emails: [email1, email2], phoneNumbers: [phoneNumber])
            
            contacts.append(contact)
            
            switch firstName {
                
            case "Allen", "Travis" , "Ursula", "Vick":
                let user = User(name: firstName, email: email1, phoneNumber: phoneNumber)
                
                following.append(user)
                followers.append(user)
                
            default:
                continue
                
            }
            
        }
        
        currentUser = OurPhoneUser(name: "Karl", email: "Karl@mail.com", phoneNumber: "(555) - 555 - 5555", contacts: contacts, following: following, followers: followers)
        
        print(currentUser) 
        
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

class OurPhoneUser: User {
    
    var contacts: [Contact]!
    
    init(name: Name, email: Email, phoneNumber: PhoneNumber?, contacts:[Contact], following:[User], followers:[User]) {
        self.contacts = contacts
        
        super.init(name: name, email: email, phoneNumber: phoneNumber)
        
        self.following = following
        self.followers = followers
        
    }
    
}

class Contact  {
    
    typealias Name = String
    typealias Email = String
    typealias PhoneNumber = String
    
    let firstName:Name!
    let lastName:Name!
    var emails:[Email]!
    var phoneNumbers:[PhoneNumber]!
    
    init(firstName:Name, lastName:Name, emails: [Email], phoneNumbers: [PhoneNumber]) {
        self.firstName = firstName
        self.lastName = lastName
        self.emails = emails
        self.phoneNumbers = [ ]
        
    }
    
}

class ContactsCell : UITableViewCell {
    
    let contact:Contact!
    
    init(contact:Contact) {
        self.contact = contact
        super.init(style: .Subtitle, reuseIdentifier: "cell")
        
        textLabel?.text = contact.firstName + " " + contact.lastName
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

