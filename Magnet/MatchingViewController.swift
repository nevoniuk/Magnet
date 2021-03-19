//
//  MatchingViewController.swift
//  Magnet
//
//  Created by Natalie Evoniuk on 3/11/21.
//

import UIKit
import Firebase
import FirebaseDatabase
class MatchingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //this vc handles creating the matchlist for the user and managing posts as objects within the table view
    //also initializes posts
    
    @IBOutlet weak var tableView: UITableView!
    // @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var postbutton: UIButton!
    var ref: DatabaseReference!
    var key = String() //USER key from registration or signin
    var listCount: Int = 0
    var imagePicker: UIImagePickerController!
    var currListIndex: Int = 0
    var interest: String = ""
    var posts = [Post]()//array of posts
    var post: Post!
    var imageSelected = false
    var selectedImage: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        //ref = Database.database().reference()
        tableView.delegate = self
        tableView.dataSource = self
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        ref = Database.database().reference()
        makeMatches() //working!
        ref.child("User").child(key).child("Matches").observe(.value, with: { snapshot in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for data in snapshot {
                    print(data)
                    if let postDict = data.value as? Dictionary<String, AnyObject> { //let data be a string or object
                        let datakey = data.key //this is postkey
                        let post = Post(postkey: datakey, postData: postDict, key: self.key) //create a post and append it
                        self.posts.removeAll()
                        self.posts.append(post)
                        
                    }
                }
            }
            self.tableView.reloadData()
        })
       // super.viewDidLoad()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("table view function")
        let post = posts[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            let image = UIImage(contentsOfFile: "background")
            cell.configCell(post: post, img: image) //basically gets the cell were currently looking at in the table cell view
            return cell
        }
        return PostCell()
    }
    /**
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImage = image
            imageSelected = true
        } else {
            print("a valid image was not selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
        guard imageSelected == true else {
            print("an image needs to be selected")
            return
        }
        if let imgData = UIImageJPEGRepresentation(selectedImage, 0.2) {
            let imgUid = NSUUID().uuidString
            //metadata??
        }
    }
    */
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    func makeMatches() {
        //var interest = ref.child("User").child(key).child("Interests"). as! String
        ref.child("User").child(key).child("Interests").getData {(error, snapshot) in
            if let error = error {
                //something for error
            }
            else if snapshot.exists() {
                self.interest = snapshot.value as! String
            }
        }
        ref.child("User").observeSingleEvent(of: .value, with: { snapshot in
            for users in snapshot.children.allObjects as! [DataSnapshot] {
                var userinterest = users.childSnapshot(forPath: "Interests").value as! String
                if (userinterest.elementsEqual(self.interest)) {
                    //add this user to key users list
                    //add this user by generating a random key for that user
                    guard let matchkey = self.ref.child("User").child(self.key).child("Matches").childByAutoId().key
                    else {return}
                    //make sure were not adding the user to his/her own matches
                    if (!users.key.elementsEqual(self.key)) {
                    //need to get key for this user
                    let postuserkey = users.key
                    self.ref.child("User").child(postuserkey).child("FirstName").getData { (error, snapshot1) in
                        let fname = snapshot1.value as! String
                            self.ref.child("User").child(postuserkey).child("LastName").getData { (error, snapshot2) in
                             //   else if snapshot.exists() {
                                     let lname = snapshot2.value as! String
                                    self.ref.child("User").child(postuserkey).child("Age").getData { (error, snapshot3) in
                                        //else if snapshot.exists() {
                                            let age = snapshot3.value as! String
                                        self.ref.child("User").child(self.key).child("Matches").child(matchkey).child("Match Object").setValue(["FistName": fname, "LastName": lname, "Age": age, "imageURL": "background", "Interests": userinterest])
                                    }
                            }
                    }
                    }
                }
 
            } //end snapshot loop
        })
    }
    //no need to implement this yet
    @IBAction func postImageTapped(_ sender: AnyObject) {
        present(imagePicker, animated: true, completion: nil)
    }
    //not sure about sign out
    //@IBAction func signOut (_sender: AnyObject) {
    //    try! Firebase.auth
   // }

    //logic for Matching algorithm:
    //1. Retrieve User key from Login/Registration
    //2. generate a list of users for the user with the same interests
    //3. append the list to the feed view
    

}
