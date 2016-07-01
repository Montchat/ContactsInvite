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
    typealias TableViewData = ([DetectedUser], [ContactToInvite])
    
    var currentUser:OurPhoneUser!
    var allUsersOnService:[User] = [ ]
    var tableViewData:TableViewData! { didSet {
        tableView.reloadData()
        
        }
        
    }
    
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
        
        let tableViewData = checkUserContactsAndService(ourUser: currentUser, allUsers: allUsersOnService)
        self.tableViewData = tableViewData
        
    }

}

extension ViewController : UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
}

extension ViewController : UITableViewDataSource {
    
    typealias ContactToInvite = Contact
    
    func checkUserContactsAndService(ourUser currentUser:OurPhoneUser, allUsers:[User]) -> TableViewData {
        
        /*
         im going to have to write this one out. theres a lot that we have to cover here because of the way that you would normally query for a data base.
         
         there are a few things that we need to get here: 
         1) who the user is following
         2) the users contacts and all associated emails
         3) use this to query all of the emails associated with the user --> we will have to simulate this with logic
         a. get the detected users on the service that the user needs to follow
         b. discover who the contacts of the users are that have not donwloaded the application and figure out who we need to invite
  
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
        let userEmails = emailQuery(users: allUsers) //returns all the users on our database
        
        var suggestedUsersToFollow:[DetectedUser] = [ ]
        var contactsToInvite:[ContactToInvite] = [ ]
        
        //for finding users we have not followed yet
        
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
        
        
        for contact in userContacts {
            let emails = contact.emails
            let contactCheck = check(contactEmails: emails, toSeeIfPartOfUserEmails: userEmails)
            if contactCheck == false {
                contactsToInvite.append(contact)
                
            }
            
        }
        
        let tableViewData:TableViewData = (suggestedUsersToFollow, contactsToInvite)
        
        return tableViewData
        
    }

    private func emailQuery(users users: [User]) -> [Email] {
        var userEmails:[Email]! = [ ]
        for user in users {
            userEmails.append(user.email)
            
        }
        
        return userEmails
        
    }
    
    private func check(contactEmails emails:[Email], toSeeIfPartOfUserEmails userEmails: [Email]) -> Bool? {
        
        var bool:Bool! = false
        
        for email in emails {
            if userEmails.contains(email) {
                bool = true
            }
            
        }
        
        return bool

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
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let detectedUsers = tableViewData.0
        let contactsToInvite = tableViewData.1
        
        switch section {
        case 0:
            return detectedUsers.count
        case 1:
            return contactsToInvite.count
        default:
            return 1
        }
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Users in your contacts"
        case 1:
            return "Invite your friends!"
        default:
            return nil
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let detectedUsers = tableViewData.0
        let contactsToInvite = tableViewData.1
        
        let section = indexPath.section
        
        switch section {
        case 0:
            let cell = DetectedUserCell(user: detectedUsers[indexPath.row])
            return cell
        case 1:
            let cell = ContactsCell(contact: contactsToInvite[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
        
        
    }
    
}
extension ViewController : UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
}

class DetectedUserCell : UITableViewCell {
    
    typealias Name = String
    typealias Username = String
    
    let user:DetectedUser!
    
    init(user:DetectedUser) {
        self.user = user
        super.init(style: .Subtitle, reuseIdentifier: "cell")
        
        let followButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        
        followButton.center.y = center.y
        followButton.setTitle("Follow", forState: .Normal)
        followButton.titleLabel?.font = UIFont.systemFontOfSize(13)
        followButton.titleLabel?.adjustsFontSizeToFitWidth = true
        followButton.imageEdgeInsets.left = 50
        followButton.imageEdgeInsets.right = -50
        followButton.titleEdgeInsets.right = 25
        followButton.titleEdgeInsets.left = -25
        followButton.setTitleColor(self.textLabel?.textColor, forState: .Normal)
        if let img = UIImage(named: "FakeAdd") {
            followButton.setImage(img, forState: .Normal)
        }
        
        followButton.frame.origin.x = bounds.maxX - 58
        
        addSubview(followButton)
        
        var name:Name = Name()
        let username:Username = user.username
        
        if let firstName = user.firstName {
            name = firstName
        }
        
        textLabel?.text = name
        detailTextLabel?.text = username

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        let inviteButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        
        inviteButton.center.y = center.y
        inviteButton.setTitle("Invite", forState: .Normal)
        inviteButton.titleLabel?.font = UIFont.systemFontOfSize(13)
        inviteButton.titleLabel?.adjustsFontSizeToFitWidth = true
        inviteButton.imageEdgeInsets.left = 50
        inviteButton.imageEdgeInsets.right = -50
        inviteButton.titleEdgeInsets.right = 25
        inviteButton.titleEdgeInsets.left = -25
        inviteButton.setTitleColor(self.textLabel?.textColor, forState: .Normal)

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

