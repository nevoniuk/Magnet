//
//  CaptionViewController.swift
//  Magnet
//
//  Created by Natalie Evoniuk on 4/23/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
class CaptionViewController: UIViewController {
    
    @IBOutlet weak var field: UITextView!
    @IBOutlet weak var caption: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var submitbutton: UIButton!
    var imagelink = String()
    var userUid = String()
    var cellNumber = Int()
    var name = String()
    var profileLink = String()
    var captionText = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CELL NUMBER \(cellNumber)")
        print("LINK: \(imagelink)")
        caption.text = "Caption for Image \(cellNumber)"
        Database.database().reference().child("User").child(self.userUid).child("Photos").child("\(cellNumber)").observeSingleEvent(of: .value, with: {
            snapshot in
                let value = snapshot.value as? Dictionary<String, AnyObject>
            if let text = value?["text"] as? String {
                self.field.text = text as! String
                
            }
            if let link = value?["link"] as? String {
                self.imagelink = link as! String
                
            }
        })

        // Do any additional setup after loading the view.
    }
    func back() {
        performSegue(withIdentifier: "goBack", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue , sender: Any?) {
  
        if (segue.identifier == "goBack") {
            var vc = segue.destination as! PersonalPageViewController
            vc.userUid = self.userUid
            vc.name = self.name
            vc.profileLink = self.profileLink
        }
        
    }
    func uploadImg(completion: @escaping (UIImage?, Error?) -> ()) {
        let storageRef = Storage.storage().reference(forURL: self.imagelink)
        storageRef.getData(maxSize: 100 * 1024) { (data, error) -> Void in
          // Create a UIImage, add it to the array
            if let error = error {
                print(error)
                return
            }
            if let imgData = data {
                if let imgg = UIImage(data: imgData) {
                    completion(imgg, error)
                    self.image.image = imgg
                }
            }
        }
    }
    
    @IBAction func sumbit(_ sender: Any) {
        self.captionText = self.field.text
        print(self.captionText)
        Database.database().reference().child("User").child(self.userUid).child("Photos").child("\(self.cellNumber)").setValue(["text": self.captionText, "link": self.imagelink])
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
