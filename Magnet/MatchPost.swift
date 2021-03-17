//
//  MatchPost.swift
//  Magnet
//
//  Created by Esteban Richey on 3/17/21.
//

import Foundation
import Firebase
import FirebaseDatabase

class MatchPost {
    
    private var _name: String!
    private var _userImg: String!
    private var _distance: Int!
    private var _interests: String!
    
    private var _matchKey: String!
    private var _matchRef: DatabaseReference!
    
    var getName: String {
        return _name
    }
    
    var getUserImg: String {
        return _userImg
    }
    
    var getDistance: Int {
        return _distance
    }
    
    var getMatchKey: String {
        return _matchKey
    }
    
    
    init(imgURL: String, name: String, distance: Int, interests: String) {
        _userImg = imgURL
        _name = name
        _distance = distance
        _interests = interests
        _matchKey = nil
        _matchRef = nil
    }
    
    init(matchKey: String, matchData: Dictionary<String, AnyObject>) {
        _matchKey = matchKey
        
        if let getName = matchData["name"] as? String {
            _name = getName
        }
        if let getUserImg = matchData["userImg"] as? String {
            _userImg = getUserImg
        }
        
        _matchRef = Database.database().reference().child("matches")
    }
    
}
