//
//  EmailVC.swift
//  Magnet
//
//  Created by Esteban Richey on 3/28/21.
//

import Foundation
import MessageUI


class EmailVC: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    
    @IBAction func attach(_ sender: Any) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }
    @IBOutlet weak var Attach: UIButton!
    
    @IBAction func sendMail(_ sender: Any) {
        let picker = MFMailComposeViewController()
        picker.mailComposeDelegate = self
        picker.setToRecipients(["magnet_app@outlook.com"])
        if let subjectText = Subject.text {
            picker.setSubject(subjectText)
        }
        
        picker.setMessageBody(body.text, isHTML: true)
        if MFMailComposeViewController.canSendMail() {
            present(picker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Email not set up", message: "Email is not set up on this device. Are you using a Simulator rather than real hardware?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK Action"), style: .cancel, handler: {_ in NSLog("The \"CANCEL\" alert occured.")}))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    @IBOutlet weak var body: UITextView!
    @IBOutlet weak var Subject: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Subject.delegate = self
        body.delegate = self
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        body.text = textView.text
        if text == "\n" {
            textView.resignFirstResponder()
            
            return false
        }
        
        return true
        
    }
    
    
}
