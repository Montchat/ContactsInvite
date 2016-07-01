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
    typealias Username = String
    
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
        
        checkUserContactsAndService(ourUser: currentUser, allUsers: allUsersOnService)
        
    }

}

extension ViewController : UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
}

extension ViewController : UITableViewDataSource {
    
    typealias ContactToInvite = Contact
    typealias TableViewData = ([DetectedUser], [ContactToInvite])
    
    func checkUserContactsAndService(ourUser currentUser:OurPhoneUser, allUsers:[User]) -> TableViewData {
        
        /*
         im going to have to write this one out. theres a lot that we have to cover here because of the way that you would normally query for a data base.
         
         there are a few things that we need to get here: 
         1) who the user is following
         2) the users contacts and all associated emails
         3) use this to query all of the emails associated with the user --> we will have to simulate this with logic
  
        */
        
        
        // 1. who the user is following
        let userFollowing:[User] = currentUser.following
        var userFollowingEmails:[Email] = [ ]
        
        for user in userFollowing {
            let email = user.email
            userFollowingEmails.append(email)
            
        }
    
        // 2. the users contacts and all associated emails
        let userContacts:[Contact] = currentUser.contacts
        var contactEmails:[Email] = [ ]
        
        for contact in userContacts {
            let emails = contact.emails
            for email in emails {
                contactEmails.append(email)
                
            }
            
        }
        
        // 3. Simulated query
        let userEmails = emailQuery(users: allUsers)
        
        var suggestedUsersToFollow:[DetectedUser] = [ ]
        for email in contactEmails {
            if userEmails.contains(email) && !userFollowingEmails.contains(email) {
                for contact in userContacts {
                    if contact.emails.contains(email) {
                        
                        let firstName = contact.firstName
                        let lastName = contact.lastName
                        
                        let username = queryForUserNameFromUsers(users: allUsers, withEmail: email) // problem here... do we really want to query for a username every time in the loop? no.
                        
                        let userSuggestedToFollow:DetectedUser = DetectedUser(firstName: firstName, lastName: lastName, username: username, email: email)
                        suggestedUsersToFollow.append(userSuggestedToFollow)
                        
                    }
                    
                }
                
            }
                
        }
        
        for user in suggestedUsersToFollow {
            let name = user.firstName
            let username = user.username
            let email = user.email
            
            print("name \(name), email \(email), username \(username)")
        }
        
        let tableViewData:TableViewData = (suggestedUsersToFollow, userContacts)
        
        return tableViewData
        
    }

    private func emailQuery(users users: [User]) -> [Email] {
        var userEmails:[Email]! = [ ]
        for user in users {
            userEmails.append(user.email)
            
        }
        
        return userEmails
        
    }
    
    private func queryForUserNameFromUsers(users users:[User], withEmail email: Email) -> Username {
        
        var username:Username!
        
        for user in users {
            if user.email == email {
                username = user.username
                
            }
            
        }
        
        return username
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
        
        if let firstName = contact.firstName {
            textLabel?.text = firstName
            
        }
        
        // need to add last name
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

