
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
    var genderpref: String = ""
    var agepref: Int = 0
    var posts = [Post]()
    var post: Post!
    var imageSelected = false
    var signIn = Bool()
    var userforPhotoPage = ""
    var selectedImage: UIImage!
    var userUid = String()
    var name: String!
    var profileURL: String!
    var beginAge = ""
    var endAge = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        ref = Database.database().reference()
        makeMatches()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false

        ref.child("User").child(self.userUid).observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? Dictionary<String, AnyObject>
           //for users in snapshot.children.allObjects as! [DataSnapshot] {
            if let fname = value?["FirstName"] as? String {
                self.name = fname
            }
            if let lname = value?["LastName"] as? String {
                self.name = self.name + " " + lname
            }
            self.name = self.name as! String

            if let pic = value?["UserImage"] as? String {
                self.profileURL = pic
                self.profileURL = self.profileURL as! String
            }
        })
        
        //display all matches
        ref.child("User").child(self.userUid).child("Matches").observeSingleEvent(of: .value, with: { snapshot in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                self.posts.removeAll()
                for data in snapshot {
                    if let postDict = data.childSnapshot(forPath:"Match Object").value as? Dictionary<String, AnyObject> {
                        print("in posts loop")
                        print(postDict)
                        let datakey = data.key
                        let post = Post(postkey: datakey, postData: postDict, key: self.userUid) //create a post and append it
                        //self.posts.removeAll()
                        self.posts.append(post)
                        
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

    func inDeleteMatches(key: String) -> Bool {
        //key = unknown users key
        var found = false
        ref.child("User").child(self.userUid).child("MatchList").child("Disliked List").observeSingleEvent(of: .value, with: { snapshot in
            if let val = snapshot.value(forKey: "key") as? String {
                if (key.elementsEqual(val)) {
                    found = true
                }
            }
        })
        return found
    }
    
    func deleteMatches() {
        print("deleting matches")
        let userID = Auth.auth().currentUser?.uid
        ref.child("User").child(userID!).child("Matches").observeSingleEvent(of: .value, with: { snapshot in
            for users in snapshot.children.allObjects as! [DataSnapshot] {
                self.ref.child("User").child(userID!).child("Matches").child(users.key).removeValue()
            }
        })
    }
    
    func makeMatches() {
        print("in make matches")
        let userID = Auth.auth().currentUser?.uid
        deleteMatches()
        ref.child("User").child(userID!).child("Interests").getData {(error, snapshot) in
            if let error = error {
                print(error)
                //something for error
            }
            else if snapshot.exists() {
                self.interest = snapshot.value as! String
            }
        }
        //get gender pref
        ref.child("User").child(userID!).child("Gender Preference").observeSingleEvent(of: .value, with: {
            (snapshot) in
                let value = snapshot.value as? Dictionary<String, AnyObject>
                if let gender = value?["gender"] as? String {
                    self.genderpref = gender
                }
        })
        

        ref.child("User").child(userID!).child("Age Preference").observeSingleEvent(of: .value, with: {
            (snapshot) in
                let value = snapshot.value as? Dictionary<String, AnyObject>
                if let beginAge = value?["begin"] as? String {
                    self.beginAge = beginAge
                }
                if let endAge = value?["end"] as? String {
                    self.endAge = endAge
                }
        })
        
        
        
        
        ref.child("User").observeSingleEvent(of: .value, with: { snapshot in
            for users in snapshot.children.allObjects as! [DataSnapshot] {
                if (self.inDeleteMatches(key: users.key) == false) {
                    
                
                    var userinterest = users.childSnapshot(forPath: "Interests").value as! String
                    var gender = users.childSnapshot(forPath: "Gender").value as! String
                    var age1 = users.childSnapshot(forPath: "Age").value as! String
                    var age = Int(age1)
                    var meetsConditions = false
                    let int1 = Int(self.beginAge)
                    var noPref = false
                    if (self.genderpref.elementsEqual("none")) {
                        noPref = true
                    }
                    let int2 = Int(self.endAge)
                    if ((self.genderpref.elementsEqual(gender) || noPref == true) && (age! >= int1!) && (age! <= int2!)) {
                        meetsConditions = true
                        print("met conditions")
                    }
                    if (userinterest.elementsEqual(self.interest) && (users.key.elementsEqual(userID!) == false) && meetsConditions) {
                        guard let matchkey = self.ref.child("User").child(userID!).child("Matches").childByAutoId().key
                        else {
                            print("couldn't make matchkey")
                            return
                        }
  
                        var fname = users.childSnapshot(forPath: "FirstName").value as! String

                        var lname = users.childSnapshot(forPath: "LastName").value as! String
                        var age = users.childSnapshot(forPath: "Age").value as! String
                        var pic = users.childSnapshot(forPath: "UserImage").value as! String
                        let f = Storage.storage().reference(forURL: pic)
                        self.ref.child("User").child(userID!).child("Matches").child(matchkey).child("Match Object").setValue(["FirstName": fname, "LastName": lname, "Age": age, "imageURL": pic, "Interests": userinterest, "liked": false, "UserId": users.key])
                    }
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
            if (self.signIn == true) {
                vc.signIn = true
            }
            else {
                vc.signIn = false
            }
           vc.name = self.name!
           vc.profileLink = self.profileURL!
        }
        if (segue.identifier == "photoPageSegue") {
            var vc = segue.destination as! PhotoLinkPageViewController
            
            vc.userUid = self.userforPhotoPage
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
    func photoVC() {
        performSegue(withIdentifier: "photoPageSegue", sender: self)
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
            cell.buttontap = {
                () in
                self.userforPhotoPage = post.postUID
                print("\(self.userforPhotoPage)")
                self.photoVC()
            }
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
