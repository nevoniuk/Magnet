//
//  PhotoLinkPageViewController.swift
//  Magnet
//
//  Created by Natalie Evoniuk on 4/13/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
class PhotoLinkPageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var photopage: UICollectionView!
    var userUid = String()
    var imageList = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        photopage.delegate = self
        photopage.dataSource = self
        photopage.isHidden = false
        print("UID INPHOTO PAGE \(self.userUid)")
        Database.database().reference().child("User").child(self.userUid).child("Photos").observeSingleEvent(of: .value, with: { snapshot in
            for users in snapshot.children.allObjects as! [DataSnapshot] {
                let value = users.childSnapshot(forPath: "link").value as! String
                print("link \(value)")
                self.imageList.append(value)
            
            }
            self.photopage.reloadData()
        })

        // Do any additional setup after loading the view.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photolinkcell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoLinkCell", for: indexPath) as! photoLinkCell
        if ((self.imageList.count > 0) && (indexPath.item < self.imageList.count)) {
            print("upload on cell # \(indexPath.item)")
            photolinkcell.configCell(img: self.imageList[indexPath.item])
        }
        return photolinkcell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineitemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
 
    
}
