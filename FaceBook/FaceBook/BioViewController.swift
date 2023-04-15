//
//  BioViewController.swift
//  FaceBook
//
//  Created by Fabio Bassini on 21/09/2020.
//  Copyright © 2020 Fabio Bassini. All rights reserved.
//

import UIKit

class BioViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var avaImgeView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        configureUserImageView()
        loadUser()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func configureUserImageView() {
        
        avaImgeView.layer.cornerRadius = avaImgeView.frame.width / 2
        avaImgeView.clipsToBounds = true
        
    }
    
    
    @objc func loadUser() {
        
        guard let firstName = currentUser!["firstname"] as? String, let lastName = currentUser!["lastname"] as? String, let userImagePath = currentUser!["user"] as? String else { return }
        
        
        fullNameLabel.text = "\(firstName) \(lastName)"
        
        
        
        Helper.shared.downloadImage(from: userImagePath, with: "USER_DEFAULT", and: "user", on: avaImgeView)
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        // calculation of characters
        let allowed = 101
        let typed = textView.text.count
        let reamain = allowed - typed
        
        counterLabel.text = "\(reamain)/101"
        
        
        if textView.text.isEmpty {
            placeHolderLabel.isHidden = false
        } else {
            placeHolderLabel.isHidden = true
        }
    }
    
    
    // executed wheneveer textview is about to be changed. return TRUE -> allow change, return FALSE -> do not allow
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard text.rangeOfCharacter(from: CharacterSet.newlines) == nil else {
            return false
        }
        
        // if 0 characters are remaining, do not allow to type anything else
        return textView.text.count + (text.count - range.length) <= 101
        
    }
    
    
    func updateBio() {
        
        let helper = Helper()
        
        guard let id = currentUser!["id"], let bio = textView.text else {
            return
        }
        
        
        // STEP 1: Declare the URL of the request
        
        let baseUrl = URL(string: "http://localhost:8888/Facebook/updateBio.php")!
        
        let parameters = [
            "id": id,
            "bio": bio
        ]
        
        
        var request = URLRequest(url: baseUrl)
        
        
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        request.httpBody = Helper.shared.createBody(parameters: parameters, boundary: boundary)
        
        
        //        Network.shared.performRequestWithURLRequest(async: true, url: request, status: "200", in: self, with: helper) {
        //            print("Bio aggiornata correttamente")
        //        } onSuccess: { (parsedJSON) in
        //            currentUser = parsedJSON.mutableCopy() as? NSDictionary
        //            UserDefaults.standard.setValue(currentUser, forKey: "currentUser")
        //            UserDefaults.standard.synchronize()
        //
        //            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBio"), object: nil)
        //            self.dismiss(animated: true, completion: nil)
        //        } onError: { (err) in
        //            print(err)
        //        }
        
        
        
        Network.shared.performRequestWithURLRequest(async: true, url: request, status: "200", in: self, with: helper, onSuccess: { (parsedJSON) in
            currentUser = parsedJSON.mutableCopy() as? NSDictionary
            UserDefaults.standard.setValue(currentUser, forKey: "currentUser")
            UserDefaults.standard.synchronize()
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBio"), object: nil)
            self.dismiss(animated: true, completion: nil)
        }) { (err) in
            print(err)
        }
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        
        if textView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty == false{
            self.updateBio()
        }
    }
    
    
    
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
