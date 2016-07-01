//
//  User.swift
//  ContactsInvite
//
//  Created by Joe E. on 6/30/16.
//  Copyright © 2016 Montchat. All rights reserved.
//

import Foundation

class User {
    
    typealias Username = String
    typealias Email = String
    typealias PhoneNumber = String
    
    let username:Username
    let email:Email!
    let phoneNumber:PhoneNumber?
    
    var following:[User]!
    var followers:[User]!
    
    init(username:Username, email:Email, phoneNumber: PhoneNumber?) {
        self.username = username
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
    
    init(username: Username, email: Email, phoneNumber: PhoneNumber?, contacts:[Contact], following:[User], followers:[User]) {
        self.contacts = contacts
        
        super.init(username: username , email: email, phoneNumber: phoneNumber)
        
        self.following = following
        self.followers = followers
        
    }
    
}

class DetectedUser: User {
    
    typealias Name = String
    
    let firstName:Name?
    let lastName:Name?
    
    init(firstName:Name?, lastName:Name, username: Username, email: Email, phoneNumber: PhoneNumber?) {
        self.firstName = firstName ; self.lastName = lastName
        super.init(username: username, email: email, phoneNumber: phoneNumber)
        
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