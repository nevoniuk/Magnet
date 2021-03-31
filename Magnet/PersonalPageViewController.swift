//
//  PersonalPageViewController.swift
//  Magnet
//
//  Created by Natalie Evoniuk on 3/30/21.
//

import UIKit

class PersonalPageViewController: UIViewController {

    @IBOutlet weak var NameField: UILabel!
    @IBOutlet weak var Miles: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var location: UISlider!
    @IBOutlet weak var Bio: UITextView!
    @IBOutlet weak var EditBio: UIButton!
    @IBOutlet weak var PressEditBio: UIButton!
    
    @IBOutlet weak var PhotoPage: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
