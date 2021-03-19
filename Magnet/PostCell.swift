///
//  PostCell.swift
//  Magnet
//
//  Created by Natalie Evoniuk on 3/12/21.
//
import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
//import SwiftKeychainWrapper
class PostCell: UITableViewCell {
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var sport: UILabel!
    @IBOutlet weak var likebutton: UIButton!
    
    var post: Post!
    //var userPostKey = Database.database().reference()
    var userKey: String = ""
    //have to get key from another file
    
    //let currentUser = String()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configCell(post: Post, img: UIImage?) {
        self.post = post
        self.age.text = post.age
        self.lastName.text = post.lastName
        self.firstName.text = post.firstName
        self.sport.text = post.interest
        self.userKey = post.key
        if img != nil {
            self.postImg.image = img
        }
        //storage?
        //let ref = FirebaseStorage.storage().reference
    }
    @IBAction func liked(_ sender: AnyObject) {
        let likeRef = Database.database().reference().child("User").child(self.userKey).child("Matches").child(self.post.postKey).child("Liked")
        likeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull
            {
                self.post.adjustLike(ifLike: true)
                likeRef.setValue("true")
            }
            else {
                self.post.adjustLike(ifLike: false)
                likeRef.setValue("false")
            }
        })
    }
}
