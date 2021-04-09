//
//  File.swift
//  Magnet
//
//  Created by user194416 on 4/2/21.
//

import Foundation
import Firebase
struct Constants
{
    struct refs
    {
    
        var first = ""
        var second = ""
        
        static let databaseRoot = Database.database().reference()
        
        
        static let databaseChats = databaseRoot.child("chats").child("Jack").child("Smith")
        
    }
    
    
    
}
