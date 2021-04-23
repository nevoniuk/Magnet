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
import SwiftKeychainWrapper
class PostCell: UITableViewCell {

    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var postImg: UIImageView!

    @IBOutlet weak var dislikebutton: UIButton!
    @IBOutlet weak var photoPage: UIButton!
    @IBOutlet weak var sport: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var likebutton: UIButton!
    var alreadyDisliked = false
    var post: Post!
    var buttontap : (()->())?
    var photosEnabled = false
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
    @IBAction func clickedPhotos(_ sender: Any) {
        self.photoPage.isSelected = true
        buttontap?()
    }
   
    func uploadImg(completion: @escaping (UIImage?, Error?) -> ()) {
        
        let storageRef = Storage.storage().reference(forURL: self.post.postImage)
        storageRef.getData(maxSize: 100 * 1024) { (data, error) -> Void in
          // Create a UIImage, add it to the array
            if let error = error {
                print(error)
                return
            }
            if let imgData = data {
                if let imgg = UIImage(data: imgData) {
                    completion(imgg, error)
                    print(self.post.postImage)
                    self.postImg.image = imgg
                }
            }
        }
    }
    func configCell(post: Post, img: UIImage? = nil) {
        self.post = post
        self.age.text = post.age
        self.Name.text = post.firstName + " " + post.lastName
        self.sport.text = post.interest
        self.userKey = post.key
        if img != nil {
            self.postImg.image = img
        } else {
            
            self.uploadImg() {
                (imgg, error) in
                self.postImg.image = imgg
            }
        }
        self.photoPage.isEnabled = false
        self.ifPhotosEnabled()
    }
    @IBAction func liked(_ sender: AnyObject) {
        print("like")
        let likeRef = Database.database().reference().child("User").child(self.userKey).child("Matches").child(self.post.postKey).child("Match Object").child("liked")
        self.post.adjustLike(ifLike: true)
        self.likebutton.setTitleColor(UIColor.red, for: .normal)
        self.dislikebutton.setTitleColor(UIColor.black, for: .normal)
        likeRef.setValue(true)
        /**
        likeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let val = snapshot.value as? NSObject {
                print(val)
                if (val.isEqual(false)) {
                    self.post.adjustLike(ifLike: true)
                    self.likebutton.setTitleColor(UIColor.red, for: .normal)
                    self.dislikebutton.setTitleColor(UIColor.black, for: .normal)
                    likeRef.setValue(true)
                }
                else {
                    self.likebutton.setTitleColor(UIColor.black, for: .normal)
                }
            }
        })
 */
        //if the post is in the dislike list, take it out
        Database.database().reference().child("User").child(self.userKey).child("MatchList").child("Disliked List").observeSingleEvent(of: .value, with: { (snapshot) in
            for users in snapshot.children.allObjects as! [DataSnapshot] {
                let value = users.childSnapshot(forPath: "key").value as! String
                if (value.elementsEqual(self.post.postUID) && value != nil && self.post.postUID != nil) {
                    Database.database().reference().child("User").child(self.userKey).child("MatchList").child("Disliked List").child(users.key).removeValue()
                }
            }
        })
    }
    
    @IBAction func disliked(_ sender: Any) {
        //if clicked and already disliked, then just set the button to black
        print("dislike")
        let likeRef = Database.database().reference().child("User").child(self.userKey).child("Matches").child(self.post.postKey).child("Match Object").child("liked")
        likeRef.observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let val = snapshot.value as? NSObject {
                print(val)
                if (val.isEqual(true)) { //if already not liked change to true
                    self.post.adjustLike(ifLike: false)
                    self.dislikebutton.setTitleColor(UIColor.red, for: .normal)
                    likeRef.setValue(false)
                    self.likebutton.setTitleColor(UIColor.black, for: .normal)
                }
            }
        })
       check()
        if (self.alreadyDisliked == false) {
            Database.database().reference().child("User").child(self.userKey).child("MatchList").child("Disliked List").childByAutoId().setValue(["key": self.post.postUID])
        }
    }
    
    func ifPhotosEnabled() {
        Database.database().reference().child("User").child(self.post.postUID).child("PhotoSharing").observeSingleEvent(of: .value, with: {
            snapshot in
                let value = snapshot.value as? Dictionary<String, AnyObject>
            if let val = value?["val"] as? String {
                if (val.elementsEqual("true")) {
                    self.photosEnabled = true
                    self.photoPage.isEnabled = true
                }
            }
        })
    }
    
    func check() {
        
        Database.database().reference().child("User").child(self.userKey).child("MatchList").child("Disliked List").observeSingleEvent(of: .value, with: { (snapshot) in
            for users in snapshot.children.allObjects as! [DataSnapshot] {
                let value = users.childSnapshot(forPath: "key").value as! String
                print("val")
                print(value)
                if (value.elementsEqual(self.post.postUID)) {
                    self.alreadyDisliked = true //not updating
                    print("already")
                }
            }
          
        })
    }
}

