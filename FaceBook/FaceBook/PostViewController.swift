//
//  PostViewController.swift
//  FaceBook
//
//  Created by Fabio Bassini on 25/09/2020.
//  Copyright © 2020 Fabio Bassini. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var avaImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    
    var  isPictureSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pictureImageView.isUserInteractionEnabled = true
        loadUser()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        avaImageView.layer.cornerRadius = avaImageView.frame.width / 2
        avaImageView.clipsToBounds = true
        
    }
    
    func loadUser() {
        Helper.shared.loadFullName(with: currentUser!["firstname"] as! String, lastname: currentUser!["lastname"] as! String, show: fullNameLabel)
        Helper.shared.downloadImage(from: currentUser!["user"] as! String, with: "USER_DEFAULT", and: "user", on: avaImageView)
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            placeholderLabel.isHidden = false
        } else {
            placeholderLabel.isHidden = true
        }
    }
    
    
    
    
    @IBAction func addPictureButtonPressed(_ sender: UIButton) {
        
        actionSheet()
        
    }
    
    
    func showPicker(with source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        picker.sourceType = source
        present(picker, animated: true, completion: nil)
    }
    
    func actionSheet() {
        
        
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.showPicker(with: .camera)
                
            }
            
        }
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.showPicker(with: .photoLibrary)
                
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        
        
        
        let buttons = [camera, photoLibrary, cancel]
        
        for button in buttons {
            sheet.addAction(button)
        }
        
        
        self.present(sheet, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        pictureImageView.image = image
        
        isPictureSelected = true
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func pictureTapGestureRecognizer(_ sender: Any) {
        
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let delete = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.pictureImageView.image = UIImage()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        
        
        
        let buttons = [delete, cancel]
        
        for button in buttons {
            sheet.addAction(button)
        }
        
        
        self.present(sheet, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        
        guard let id = currentUser?["id"], let text = postTextView.text else { return }
        
        let helper = Helper()
        
        
        let baseUrl = URL(string: "http://localhost:8888/Facebook/uploadPost.php")!
        
        
        let parameters = [
            "user_id"  : id,
            "text"    : text
        ]
        
        var request = URLRequest(url: baseUrl)
        
        
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        if isPictureSelected {
            
            guard let imageData = pictureImageView.image?.jpegData(compressionQuality: 0.5) else {
                return
            }
            
            request.httpBody = Helper.shared.createBody(parameters: parameters, boundary: boundary, data: imageData, mimeType: "image/jpg", filename: "\(NSUUID().uuidString).jpg")
            
            
            //            Network.shared.performRequestWithURLRequest(async: true, url: request, status: "200", in: self, with: helper) {
            //                print("Post Upload Completato correttamente")
            //            } onSuccess: { (parsedJSON) in
            //
            //                currentUser = parsedJSON.mutableCopy() as? NSDictionary
            //                UserDefaults.standard.setValue(currentUser, forKey: "currentUser")
            //                UserDefaults.standard.synchronize()
            //
            //                self.dismiss(animated: true, completion: nil)
            //
            //            } onError: { (err) in
            //                print(err)
            //            }
            
            
            
            
            Network.shared.performRequestWithURLRequest(async: true, url: request, status: "200", in: self, with: helper, onSuccess: { (parsedJSON) in
                
                currentUser = parsedJSON.mutableCopy() as? NSDictionary
                UserDefaults.standard.setValue(currentUser, forKey: "currentUser")
                UserDefaults.standard.synchronize()
                
                self.dismiss(animated: true, completion: nil)
                
            }) { (err) in
                print(err)
            }
            
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}
