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

    @IBOutlet weak var sport: UILabel!
    @IBOutlet weak var age: UILabel!
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
            

            //func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
             //   URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
            //}
            self.uploadImg() {
                (imgg, error) in
                self.postImg.image = imgg
            }
            print(post.postImage)
        }
    }
    @IBAction func liked(_ sender: AnyObject) {
        let likeRef = Database.database().reference().child("User").child(self.userKey).child("Matches").child(self.post.postKey).child("Match Object").child("liked")
        self.likebutton.setTitleColor(UIColor.red, for: .normal)
        likeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let val = snapshot.value as? NSObject {
                if (val.isEqual(false)) {
                    self.post.adjustLike(ifLike: true)
                    likeRef.setValue(true)
                }
                else {
                    self.post.adjustLike(ifLike: false)
                    likeRef.setValue(false)
                    self.likebutton.setTitleColor(UIColor.black, for: .normal)
                }
            }
        })
    }
}
