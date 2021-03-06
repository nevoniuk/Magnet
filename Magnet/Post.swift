//
//  Post.swift
//  Magnet
//
//  Created by Natalie Evoniuk on 3/12/21.
//

import Foundation
import Firebase
import FirebaseDatabase
class Post {
    private var _key: String!
    private var _postImage: String!
    private var _firstName: String!
    private var _lastName: String!
    private var _age: String!
    private var _interest: String!
    private var _liked: Bool!
    private var _postkey: String!
    private var _postUID: String!
    private var _ref1 = Database.database().reference()//usermatch has name, last name, age, sport, and like optin
    private var _ref2: DatabaseReference!
    //this file is basically the template for information on the post
    var key: String { //this will be the user key
        return _key
    }
    var firstName: String {
        return _firstName
    }
    var lastName: String {
        return _lastName
    }
    var postImage: String {
        get {
            return _postImage
        }
        set {
            _postImage = newValue
        }
    }
    var age: String {
        return _age
    }
    var interest: String {
        return _interest
    }
    var liked: Bool { //unless told otherwise
        return _liked
    }
    var postKey: String {
        return _postkey
    }
    var postUID: String {
        return _postUID
    }
    init(firstname: String, lastname: String, age: String, Interest: String, liked: Bool, imgUrl: String, postUID: String) {
        //_key = key
        _firstName = firstname
        _lastName = lastname
        _liked = liked
        _interest = Interest
        _age = age
        _postImage = imgUrl
        _postUID = postUID
    }
    init (postkey: String, postData: Dictionary<String, AnyObject>, key: String) {
        _postkey = postkey //this will be the match key
        if let firstname = postData["FirstName"] as? String {
            _firstName = firstname
        }
        if let postUID = postData["UserId"] as? String {
            _postUID = postUID
            print("Post UID is \(_postUID)")
        }
        if let lastname = postData["LastName"] as? String {
            _lastName = lastname
        }
        if let age = postData["Age"] as? String {
            _age = age
        }
        if let interest = postData["Interests"] as? String {
            _interest = interest
        }
        if let postImage = postData["imageURL"] as? String {
            _postImage = postImage
        }
        _key = key //user key
        _ref1 = Database.database().reference().child("User").child(_key).child("Matches").child(_postkey).child("Match Object") //reference to post! also Match Object
        //_ref2 = Database.database().reference().child("User").child(_key).child("MatchList").child("Disliked List")
    }
    func adjustLike(ifLike: Bool) {
        if (ifLike) {
            _liked = true
        }
        else {
            _liked = false
        }
        _ref1.child("liked").setValue(_liked)
    }
}
