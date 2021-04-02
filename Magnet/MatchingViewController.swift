
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import SwiftKeychainWrapper
class MatchingViewController: UIViewController, UINavigationControllerDelegate,  UIImagePickerControllerDelegate {

    @IBOutlet weak var logOutBttn: UIButton!
    @IBOutlet weak var messageBttn: UIButton!
    @IBOutlet weak var profileBttn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    // @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var postbutton: UIButton!
    var ref: DatabaseReference!
 //USER key from registration or signin
    var listCount: Int = 0
    var imagePicker: UIImagePickerController!
    var currListIndex: Int = 0
    var interest: String = ""
    var posts = [Post]()
    var post: Post!
    var imageSelected = false
    var signIn = Bool()
    var selectedImage: UIImage!
    var userUid = String()
    var name: String!
    var profileURL: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        //signIn = Bool()
        ref = Database.database().reference()
        if (!signIn) {
            makeMatches() //working!
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
        print(self.userUid)
        ref.child("User").child(self.userUid).observe(.value, with: { snapshot in
            let value = snapshot.value as? Dictionary<String, AnyObject>
           //for users in snapshot.children.allObjects as! [DataSnapshot] {
            if let fname = value?["FirstName"] as? String {
                self.name = fname
            }
            if let lname = value?["LastName"] as? String {
                self.name = self.name + " " + lname
            }
            self.name = self.name as! String
                print("NAME")
                print(self.name!)
            if let pic = value?["UserImage"] as? String {
                self.profileURL = pic
                self.profileURL = self.profileURL as! String
            }
        })
        ref.child("User").child(self.userUid).child("Matches").observe(.value, with: { snapshot in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                self.posts.removeAll()
                for data in snapshot {
                    if let postDict = data.childSnapshot(forPath:"Match Object").value as? Dictionary<String, AnyObject> {
                        print(postDict)
                        let datakey = data.key
                        //var liked = "false"
                        var appendPost = true
                        if (self.signIn) {
                            if let like = postDict["liked"] as? Bool {
                                if (!like) {
                                    print("not liked")
                                    self.ref.child("User").child(self.userUid).child("Matches").child(datakey).removeValue()
                                    appendPost = false
                                }
                            }
                        }
                        if (appendPost) {
                            let post = Post(postkey: datakey, postData: postDict, key: self.userUid) //create a post and append it
                            //self.posts.removeAll()
                            self.posts.append(post)
                        }
                        
                    }
                }
            }
            self.tableView.reloadData()
        })
       // super.viewDidLoad()
    }
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

    
    func makeMatches() {
        //var interest = ref.child("User").child(key).child("Interests"). as! String
        let userID = Auth.auth().currentUser?.uid
        print(userID!)
        ref.child("User").child(userID!).child("Interests").getData {(error, snapshot) in
            if let error = error {
                //something for error
            }
            else if snapshot.exists() {
                self.interest = snapshot.value as! String
                print(self.interest)
            }
        }
        ref.child("User").observeSingleEvent(of: .value, with: { snapshot in
            for users in snapshot.children.allObjects as! [DataSnapshot] {
                var userinterest = users.childSnapshot(forPath: "Interests").value as! String
                if (userinterest.elementsEqual(self.interest) && (users.key.elementsEqual(userID!) == false)) {
                    guard let matchkey = self.ref.child("User").child(userID!).child("Matches").childByAutoId().key
                    else {
                        print("couldn't make matchkey")
                        return
                    }
  
                    var fname = users.childSnapshot(forPath: "FirstName").value as! String
                    print(fname)
                    var lname = users.childSnapshot(forPath: "LastName").value as! String
                    var age = users.childSnapshot(forPath: "Age").value as! String
                    var pic = users.childSnapshot(forPath: "UserImage").value as! String
                    let f = Storage.storage().reference(forURL: pic)
                    self.ref.child("User").child(userID!).child("Matches").child(matchkey).child("Match Object").setValue(["FirstName": fname, "LastName": lname, "Age": age, "imageURL": pic, "Interests": userinterest, "liked": false])
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue , sender: Any?) {
        if (segue.identifier == "logOutSegue") {
            var vc = segue.destination as! ViewController
        }
        if (segue.identifier == "personalPageSegue") {
            var vc = segue.destination as! PersonalPageViewController
            vc.userUid = self.userUid
            if (self.signIn) {
                vc.signIn = true
            }
            else {
                vc.signIn = false
            }
           vc.name = self.name!
           vc.profileLink = self.profileURL!
        }
        //create out for messaging
    }
    //no need to implement this yet
    @IBAction func postImageTapped(_ sender: AnyObject) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func homeVC() {
        performSegue(withIdentifier: "logOutSegue", sender: self)
    }
    
    @IBAction func signOut (_sender: AnyObject) {
        try! Auth.auth().signOut()
        KeychainWrapper.standard.removeObject(forKey: "uid")
        homeVC()
    }
}

extension MatchingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
   }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            cell.configCell(post: post, img: nil)
            return cell
        }
        else {
            return PostCell()
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
   
}
