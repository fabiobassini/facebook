//
//  EditTableViewController.swift
//  FaceBook
//
//  Created by Fabio Bassini on 29/09/2020.
//  Copyright © 2020 Fabio Bassini. All rights reserved.
//

import UIKit

class EditTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    //MARK: - OutletReference to Main Storyboard
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var avaImageView: UIImageView!
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var addBioButton: UIButton!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var birthdayTextfield: UITextField!
    @IBOutlet weak var genderTextfield: UITextField!
    
    
    
    //MARK: - Variables setting to control image selection with picker
    var isCover = false
    var isAva = false
    
    var isAvaChanged = false
    var isCoverChanged = false
    
    var imageViewTapped: String?
    
    var isPasswordchanged = false
    
    //MARK: - Picker for date and gender
    var datePicker: UIDatePicker!
    var genderPicker: UIPickerView!
    let genderPickerValues = ["Male", "Female"]
    
    
    //MARK: - View load methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coverImageView.isUserInteractionEnabled = true
        avaImageView.isUserInteractionEnabled = true
        configureUserProfileImageView()
        
        loadUser()
        
        
        
        //creating, configuring and implementig custom DatePicker
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -17, to: Date())
        datePicker.addTarget(self, action: #selector(datePickerDidChanged(_:)), for: .valueChanged)
        birthdayTextfield.inputView = datePicker
        
        
        genderPicker = UIPickerView()
        genderPicker.dataSource = self
        genderPicker.delegate = self
        genderTextfield.inputView = genderPicker
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureAddBioButton()
    }
    
    
    
    //MARK: - My Methods
    func loadUser() {
        
        
        guard let firstName = currentUser!["firstname"] as? String,
              let lastName = currentUser!["lastname"] as? String,
              let email = currentUser!["email"] as? String,
              let birthday = currentUser!["birthday"] as? String,
              let gender = currentUser!["gender"] as? String,
              let userImagePath = currentUser!["user"] as? String,
              let coverImagePath = currentUser!["cover"] as? String else { return }
        
        if userImagePath.count > 10 {
            isAva = true
        } else {
            avaImageView.image = UIImage(named: "user")
            isAva = false
        }
        
        if coverImagePath.count > 10 {
            isCover = true
        } else {
            coverImageView.image = UIImage(named: "HomeCover")
            isCover = false
        }
        
        
        firstname.text = "\(firstName)"
        lastname.text = "\(lastName)"
        emailTextfield.text = "\(email)"
        
        Helper.shared.downloadImage(from: coverImagePath, with: "COVER_DEFAULT", and: "HomeCover", on: coverImageView)
        Helper.shared.downloadImage(from: userImagePath, with: "USER_DEFAULT", and: "user", on: avaImageView)
        
        
        if gender == "1" {
            genderTextfield.text = "Male"
        } else {
            genderTextfield.text = "Female"
        }
        
        
        //        let formatterGet = DateFormatter()
        //        formatterGet.dateFormat = "yyyy-MM-dd HH:mm:sszzzz"
        //        let date = formatterGet.date(from: birthday)
        //
        //        let formatterShow = DateFormatter()
        //        formatterShow.dateFormat = "MMM dd, yyyy"
        //        let newFormattedDate = formatterShow.string(from: date!)
        
        birthdayTextfield.text = "\(birthday)"
        
    }
    
    func configureAddBioButton() {
        
        // creating constant named 'border'
        let border = CALayer()
        border.borderWidth = 2
        border.borderColor = UIColor(red: 68/255, green: 105/255, blue: 176/255, alpha: 1).cgColor
        border.frame = CGRect(x: 0, y: 0, width: addBioButton.frame.width, height: addBioButton.frame.height)
        
        
        // assigninig border to the obj (button)
        addBioButton.layer.addSublayer(border)
        
        //round it
        addBioButton.layer.cornerRadius = 5
        addBioButton.layer.masksToBounds = true
        
    }
    
    
    func configureUserProfileImageView() {
        
        // creating a layer that will applied to userPofileImaegView
        let border = CALayer()
        border.borderColor = UIColor.white.cgColor
        border.borderWidth = 5
        border.frame = CGRect(x: 0, y: 0, width: avaImageView.frame.width, height: avaImageView.frame.height)
        avaImageView.layer.addSublayer(border)
        
        
        avaImageView.layer.cornerRadius = 10
        avaImageView.layer.masksToBounds = true
        avaImageView.clipsToBounds = true
        
    }
    
    //MARK: Picking images
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
                self.avaImageView.image = UIImage(named: "user")
                self.isAva = false
                self.isAvaChanged = true
            } else if self.imageViewTapped == "cover" {
                self.coverImageView.image = UIImage(named: "HomeCover")
                self.isCover = false
                self.isCoverChanged = true
            }
            
        }
        
        if imageViewTapped == "user" && isAva == false {
            delete.isEnabled = false
        } else if imageViewTapped == "cover" && isCover == false {
            delete.isEnabled = false
        }
        
        
        
        let buttons = [camera, photoLibrary, cancel, delete]
        
        for button in buttons {
            sheet.addAction(button)
        }
        
        
        self.present(sheet, animated: true, completion: nil)
        
    }
    
    
    
    
    //MARK: - Actions connection
    @IBAction func homeTapped(_ sender: Any) {
        
        imageViewTapped = "cover"
        
        actionSheet()
        
    }
    
    @IBAction func userTapped(_ sender: Any) {
        
        imageViewTapped = "user"
        
        actionSheet()
        
    }
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        // assigning the selected picture to the corret imageview
        if imageViewTapped == "cover" {
            coverImageView.image = image
            
            //            self.uploadImage(from: homeCoverImageView)
            
        } else if imageViewTapped == "user" {
            avaImageView.image = image
            //            self.uploadImage(from: userProfileImageView)
        }
        
        
        // communicate that an image has been selected
        dismiss(animated: true) {
            if self.imageViewTapped == "cover" {
                self.isCover = true
                self.isCoverChanged = true
            } else if self.imageViewTapped == "user" {
                self.isAva = true
                self.isAvaChanged = true
            }
            
        }
    }
    
    
    
    
    
    
    @objc func datePickerDidChanged(_ datePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        birthdayTextfield.text = formatter.string(from: datePicker.date)
        
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderPickerValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderPickerValues[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextfield.text = genderPickerValues[row]
        genderTextfield.resignFirstResponder()
    }
    
    
    @IBAction func passwordChangedTextField(_ textField: UITextField) {
        
        if textField == passwordTextfield {
            isPasswordchanged = true
            print("is password changed: ", isPasswordchanged)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        updateUser()
        
        if isAvaChanged == true {
            uploadImage(from: avaImageView, type: "user") {
                Helper.shared.showAlert(title: "Success", message: "Profile image has been updated", in: self)
            }
            
        }
        
        
        if isCoverChanged == true {
            uploadImage(from: coverImageView, type: "cover") {
                Helper.shared.showAlert(title: "Success", message: "Profile image has been updated", in: self)
            }
        }
        
        
        
    }
    
    
    func updateUser() {
        
        guard let id = currentUser!["id"] else { return }
        
        guard let email = emailTextfield.text,
              let firstName = firstname.text,
              let lastName = lastname.text,
              let birthday = datePicker.date.description as? String,
              let password = passwordTextfield.text else {
            return
        }
        var gender = ""
        if genderTextfield.text == "Male" {
            gender = "1"
        } else {
            gender = "0"
        }
        
        if genderTextfield.text == "Female" {
            gender = "0"
        } else {
            gender = "1"
        }
        
        if Helper.shared.isValid(email: email) == false {
            Helper.shared.showAlert(title: "Invalid E-mail", message: "Please use a valid e-mail address", in: self)
        } else if Helper.shared.isValid(name: firstName) == false {
            Helper.shared.showAlert(title: "Invalid Username", message: "Please use a valid username", in: self)
        } else if Helper.shared.isValid(name: lastName) == false {
            Helper.shared.showAlert(title: "Invalid Lastname", message: "Please use a valid lastname", in: self)
        } else if password.count < 6 {
            Helper.shared.showAlert(title: "Invalid Password", message: "Password must be 6 characters lenght", in: self)
        }
        
        
        // STEP 1: Declare the URL of the request
        
        let baseUrl = URL(string: "http://localhost:8888/Facebook/updateUser.php")!
        
        let query = [
            "id" : id,
            "email": String(email.lowercased()),
            "firstname": String(firstName.lowercased()),
            "lastname": String(lastName.lowercased()),
            "birthday": String(birthday),
            "gender": String(gender),
            "newPassword": isPasswordchanged,
            "password": String(password)
        ]
        
        
        var request = URLRequest(url: baseUrl)
        
        
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = Helper.shared.createBody(parameters: query, boundary: boundary)
        
        
        let helper = Helper()
        
        
        
        
        Network.shared.performRequestWithURLRequest(async: true, url: request, status: "200", in: self, with: helper) { (parsedJSON) in
            print("Update User")
            
            currentUser = parsedJSON.mutableCopy() as? NSDictionary
            UserDefaults.standard.setValue(currentUser, forKey: "currentUser")
            UserDefaults.standard.synchronize()
        } onError: { (err) in
            print(err)
        }
        
        
    }
    
    
    // sends request to the server to upload the Image (ava/cover)
    func uploadImage(from imageView: UIImageView, type: String, completion: @escaping () -> Void) {
        
        // save method of accessing ID of current user
        guard let id = currentUser?["id"] else {
            return
        }
        
        
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
            "type"    : type
        ]
        
        var request = URLRequest(url: baseUrl)
        
        
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = Helper.shared.createBody(parameters: parameters, boundary: boundary, data: imageDatas, mimeType: "image/jpg", filename: "\(type).jpg")
        
        let helper = Helper()
        

        Network.shared.performRequestWithURLRequest(async: true, url: request, status: "200", in: self, with: helper) { (parsedJSON) in
            currentUser = parsedJSON.mutableCopy() as? NSDictionary
            UserDefaults.standard.setValue(currentUser, forKey: "currentUser")
            UserDefaults.standard.synchronize()
            completion()
        } onError: { (err) in
            print(err)
        }

        
        
        
        
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    //
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        // #warning Incomplete implementation, return the number of rows
    //        return 0
    //    }
    
    
    
}
