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
    var allUsersOnService:[User] = [ ]

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
                
            case "Allen", "Travis" , "Ursula", "Vick": //users that our user is following
                
                let user = User(username: firstName + "1990", email: email1, phoneNumber: phoneNumber)
                
                following.append(user)
                followers.append(user)
                
                allUsersOnService.append(user)
                
            case "Bennett", "Evan", "Ian", "Farah" : //users that our user is not following but are on the service
                
            let user = User(username: firstName + "1990", email: email1, phoneNumber: phoneNumber)
            
                allUsersOnService.append(user)
                
            default:
                continue
                
            }
            
        }
        
        currentUser = OurPhoneUser(username: "Karl", email: "Karl@mail.com", phoneNumber: "(555) - 555 - 5555", contacts: contacts, following: following, followers: followers)
        
        allUsersOnService.append(currentUser)
        
        tableView.delegate = self ; tableView.dataSource = self
        searchBar.delegate = self
        
    }

}

extension ViewController : UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
}

extension ViewController : UITableViewDataSource {
    
    typealias ContactToInvite = Contact
    typealias TableViewData = (DetectedUser, ContactToInvite)
    
    func checkUserContactsAndService(ourUser currentUser:OurPhoneUser, allUsers:[User]) -> TableViewData  {
        
        let currentUser = currentUser.contacts
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count:Int!
        
        let usersInContactsOnServiceButDontKnowAbout = currentUser.contacts
        
        switch section {
        case 0:
            <#code#>
        default:
            <#code#>
        }
        
        
        return currentUser.followers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = ContactsCell(contact:currentUser.contacts[indexPath.row])
        
        return cell
        
    }
    
}
extension ViewController : UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
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

