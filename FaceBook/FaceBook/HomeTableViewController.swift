//
//  HomeTableViewController.swift
//  FaceBook
//
//  Created by Fabio Bassini on 09/09/2020.
//  Copyright © 2020 Fabio Bassini. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var homeCoverImageView: UIImageView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var addBioButton: UIButton!
    @IBOutlet weak var bioLabel: UILabel!
    
    
    
    
    var isCover = false
    var isAva = false
    var imageViewTapped: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeCoverImageView.isUserInteractionEnabled = true
        userProfileImageView.isUserInteractionEnabled = true
        bioLabel.isUserInteractionEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadUser), name: NSNotification.Name(rawValue: "updateBio"), object: nil)
        
        
        
        loadUser()
        
        
        
    }
    
    @objc func loadUser() {
        
        
        guard let firstName = currentUser!["firstname"] as? String, let lastName = currentUser!["lastname"] as? String, let userImagePath = currentUser!["user"] as? String, let coverImagePath = currentUser!["cover"] as? String, let bio = currentUser!["bio"]  as? String else { return }
        
        
        if userImagePath.count > 10 {
            isAva = true
        } else {
            userProfileImageView.image = UIImage(named: "user")
            isAva = false
        }
        
        if coverImagePath.count > 10 {
            isCover = true
        } else {
            homeCoverImageView.image = UIImage(named: "HomeCover")
            isCover = false
        }
        
        
        fullNameLabel.text = "\(firstName) \(lastName)"
        
        
        Helper.shared.downloadImage(from: coverImagePath, with: "COVER_DEFAULT", and: "HomeCover", on: homeCoverImageView)
        Helper.shared.downloadImage(from: userImagePath, with: "USER_DEFAULT", and: "user", on: userProfileImageView)
        
        
        if bio == "BIO_DEFAULT" {
            bioLabel.isHidden = true
            addBioButton.isHidden = false
        } else {
            bioLabel.text = "\(bio)"
            bioLabel.isHidden = false
            addBioButton.isHidden = true
        }
        
    }
    
    
    
    func configureUserProfileImageView() {
        
        // creating a layer that will applied to userPofileImaegView
        let border = CALayer()
        border.borderColor = UIColor.white.cgColor
        border.borderWidth = 5
        border.frame = CGRect(x: 0, y: 0, width: userProfileImageView.frame.width, height: userProfileImageView.frame.height)
        userProfileImageView.layer.addSublayer(border)
        
        
        userProfileImageView.layer.cornerRadius = 10
        userProfileImageView.layer.masksToBounds = true
        userProfileImageView.clipsToBounds = true
        
    }
    
    
    
    @IBAction func homeTapped(_ sender: Any) {
        
        imageViewTapped = "cover"
        
        actionSheet()
        
    }
    
    
    @IBAction func userTapped(_ sender: Any) {
        
        imageViewTapped = "user"
        
        actionSheet()
        
    }
    
    
    
    func showPicker(with source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        picker.sourceType = source
        present(picker, animated: true, completion: nil)
    }
    
    
    
    
    
    @objc func actionSheet() {
        
        
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
        
        let delete = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            
            if self.imageViewTapped == "user" {
                self.userProfileImageView.image = UIImage(named: "user")
                self.isAva = false
                self.uploadImage(from: self.userProfileImageView)
            } else if self.imageViewTapped == "cover" {
                self.homeCoverImageView.image = UIImage(named: "HomeCover")
                self.isCover = false
                self.uploadImage(from: self.homeCoverImageView)
            }
            
        }
        
//        if imageViewTapped == "user" && isAva == false {
//            delete.isEnabled = false
//        } else if imageViewTapped == "cover" && isCover == false {
//            delete.isEnabled = false
//        }
        
        if imageViewTapped == "user" && isAva == false && imageViewTapped != "cover" {
            delete.isEnabled = false
        }
        
        if imageViewTapped == "cover" && isCover == false && imageViewTapped != "user" {
            delete.isEnabled = false
        }
        
        
        let buttons = [camera, photoLibrary, cancel, delete]
        
        for button in buttons {
            sheet.addAction(button)
        }
        
        
        self.present(sheet, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        // assigning the selected picture to the corret imageview
        if imageViewTapped == "cover" {
            homeCoverImageView.image = image
            
            self.uploadImage(from: homeCoverImageView)
            
        } else if imageViewTapped == "user" {
            userProfileImageView.image = image
            self.uploadImage(from: userProfileImageView)
        }
        
        
        // communicate that an image has been selected
        dismiss(animated: true) {
            if self.imageViewTapped == "cover" {
                self.isCover = true
            } else if self.imageViewTapped == "user" {
                self.isAva = true
            }
            
        }
    }
    
    
    
    func uploadImage(from imageView: UIImageView) {
        
        guard let id = currentUser?["id"] else { return }
        
        let helper = Helper()
        
        
        let baseUrl = URL(string: "http://localhost:8888/Facebook/uploadImage.php")!
        
        var imageDatas = Data()
        
        if imageView.image != UIImage(named: "HomeCover") && imageView.image != UIImage(named: "user") {
            
            guard let imageData = imageView.image?.jpegData(compressionQuality: 0.5) else {
                return
            }
            
            imageDatas = imageData
        }
        
        let parameters = [
            "id"  : id,
            "type"    : imageViewTapped!
        ]
        
        var request = URLRequest(url: baseUrl)
        
        
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = Helper.shared.createBody(parameters: parameters, boundary: boundary, data: imageDatas, mimeType: "image/jpg", filename: "\(imageViewTapped!).jpg")
        
        //        Network.shared.performRequestWithURLRequest(async: true, url: request, status: "200", in: self, with: helper) {
        //            print("Home aggiornata correttamente")
        //        } onSuccess: { (parsedJSON) in
        //            currentUser = parsedJSON.mutableCopy() as? NSDictionary
        //            UserDefaults.standard.setValue(currentUser, forKey: "currentUser")
        //            UserDefaults.standard.synchronize()
        //        } onError: { (err) in
        //            print(err)
        //        }
        
        
        
        Network.shared.performRequestWithURLRequest(async: true, url: request, status: "200", in: self, with: helper, onSuccess: { (parsedJSON) in
            
            currentUser = parsedJSON.mutableCopy() as? NSDictionary
            UserDefaults.standard.setValue(currentUser, forKey: "currentUser")
            UserDefaults.standard.synchronize()
            
        }) { (err) in
            print(err)
        }
        
    }
    
    
    @IBAction func bioLabelTapped(_ sender: Any) {
        
        
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editBio = UIAlertAction(title: "Edit Bio", style: .default) { (action) in
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BioVC")
            
            self.present(vc, animated: true, completion: nil)
            
        }
        
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let delete = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            
            self.updateBio()
            
        }
        
        
        
        
        let buttons = [editBio, cancel, delete]
        
        for button in buttons {
            sheet.addAction(button)
        }
        
        
        self.present(sheet, animated: true, completion: nil)
        
        
    }
    
    
    func updateBio() {
        
        let helper = Helper()
        
        guard let id = currentUser!["id"] else {
            return
        }
        
        
        // STEP 1: Declare the URL of the request
        
        let baseUrl = URL(string: "http://localhost:8888/Facebook/updateBio.php")!
        
        let bio = "BIO_DEFAULT"
        
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
        //            print("Bio aggiornata")
        //        } onSuccess: { (parsedJSON) in
        //            currentUser = parsedJSON.mutableCopy() as? NSDictionary
        //            UserDefaults.standard.setValue(currentUser, forKey: "currentUser")
        //            UserDefaults.standard.synchronize()
        //
        //            self.loadUser()
        //        } onError: { (err) in
        //            print(err)
        //        }
        
        
        
        Network.shared.performRequestWithURLRequest(async: true, url: request, status: "200", in: self, with: helper, onSuccess: { (parsedJSON) in
            currentUser = parsedJSON.mutableCopy() as? NSDictionary
            UserDefaults.standard.setValue(currentUser, forKey: "currentUser")
            UserDefaults.standard.synchronize()
            
            self.loadUser()
            
        }) { (err) in
            print(err)
        }
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            self.configureUserProfileImageView()
        }
        
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
}



