//
//  RegisterViewController.swift
//  FaceBook
//
//  Created by Fabio Bassini on 15/08/2020.
//  Copyright © 2020 Fabio Bassini. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    //constraints
    @IBOutlet weak var emailViewWidth: NSLayoutConstraint!
    @IBOutlet weak var nameViewWidth: NSLayoutConstraint!
    @IBOutlet weak var passwordViewWidth: NSLayoutConstraint!
    @IBOutlet weak var birthdayViewWidth: NSLayoutConstraint!
    @IBOutlet weak var genderViewWidth: NSLayoutConstraint!
    @IBOutlet weak var contentViewWidth: NSLayoutConstraint!
    
    
    //textFields
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var birthDayTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    
    //buttons
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var fullNameButton: UIButton!
    @IBOutlet weak var pwdButton: UIButton!
    @IBOutlet weak var birthButton: UIButton!
    
    
    //footer
    @IBOutlet weak var footerView: UIView!
    
    
    //gender
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    
    
    var datePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //definire una larghezza statica è servita solo per costruzione
        
        //è dinamica la larghezza...
        //sarà sempre la larghezza del dispositivo, moltiplicata per 5
        contentViewWidth.constant = self.view.frame.width * 5
        
        //lo stesso concetto viene applicato
        emailViewWidth.constant = self.view.frame.width
        nameViewWidth.constant = self.view.frame.width
        passwordViewWidth.constant = self.view.frame.width
        birthdayViewWidth.constant = self.view.frame.width
        genderViewWidth.constant = self.view.frame.width
        
        
        
        
        //make corners of the objects rounded
        cornerRadius(for: emailTextField)
        cornerRadius(for: firstNameTextfield)
        cornerRadius(for: lastnameTextField)
        cornerRadius(for: passTextField)
        cornerRadius(for: birthDayTextField)
        cornerRadius(for: emailButton)
        cornerRadius(for: fullNameButton)
        cornerRadius(for: pwdButton)
        cornerRadius(for: birthButton)
        
        //add paddings
        padding(for: emailTextField)
        padding(for: firstNameTextfield)
        padding(for: lastnameTextField)
        padding(for: passTextField)
        padding(for: birthDayTextField)
        
        
        //set line for footer
        configure_footerView()
        
        
        //creating, configuring and implementig custom DatePicker
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -17, to: Date())
        datePicker.addTarget(self, action: #selector(datePickerDidChanged(_:)), for: .valueChanged)
        birthDayTextField.inputView = datePicker
        
        //swipe gesture
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handle(_:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    @IBAction func emailReturnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    
    @IBAction func nameReturnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func pwdReturnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func birthReturnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        
        let helper = Helper()
        
        if textField == self.emailTextField {
            
            if helper.isValid(email: self.emailTextField.text!) {
                self.emailButton.isHidden = false
            }
        } else if textField == self.firstNameTextfield || textField == self.lastnameTextField {
            
            if helper.isValid(name: self.firstNameTextfield.text!) && helper.isValid(name: self.lastnameTextField.text!) {
                self.fullNameButton.isHidden = false
            }
            
        } else if textField == self.passTextField {
            
            if self.passTextField.text!.count >= 6 {
                self.pwdButton.isHidden = false
            }
        }
    }
    
    
    @objc func handle(_ gesture: UISwipeGestureRecognizer) {
        
        let currentX = scrollView.contentOffset.x
        
        let newX = CGPoint(x: currentX - self.view.frame.width, y: 0)
        
        if currentX > 0 {
            scrollView.setContentOffset(newX, animated: true)
        }
        
    }
    
    @objc func datePickerDidChanged(_ datePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        birthDayTextField.text = formatter.string(from: datePicker.date)
        
        let compareDateFormatter = DateFormatter()
        compareDateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        let compareDate = compareDateFormatter.date(from: "2003/01/01 00:01")
        
        if datePicker.date < compareDate! {
            birthButton.isHidden = false
        } else {
            birthButton.isHidden = true
        }
    }
    
    @IBAction func emailContinueButton(_ sender: UIButton) {
        let pos = CGPoint(x: self.view.frame.width, y: 0)
        scrollView.setContentOffset(pos, animated: true)
        
        
        if firstNameTextfield.text!.isEmpty {
            firstNameTextfield.becomeFirstResponder()
        } else if lastnameTextField.text!.isEmpty {
            lastnameTextField.becomeFirstResponder()
        } else if firstNameTextfield.text?.isEmpty == false && lastnameTextField.text?.isEmpty == false {
            firstNameTextfield.resignFirstResponder()
            lastnameTextField.resignFirstResponder()
        }
    }
    
    
    @IBAction func fullNameContinueButton(_ sender: Any) {
        let pos = CGPoint(x: self.view.frame.width * 2, y: 0)
        scrollView.setContentOffset(pos, animated: true)
        
        if passTextField.text!.isEmpty {
            passTextField.becomeFirstResponder()
        } else if passTextField.text?.isEmpty == false {
            passTextField.resignFirstResponder()
        }
        
    }
    
    
    @IBAction func passwordButton(_ sender: UIButton) {
        let pos = CGPoint(x: self.view.frame.width * 3, y: 0)
        scrollView.setContentOffset(pos, animated: true)
        
        if passTextField.text!.isEmpty {
            passTextField.becomeFirstResponder()
        } else if passTextField.text?.isEmpty == false {
            passTextField.resignFirstResponder()
        }
    }
    
    
    
    @IBAction func birthdatContinueButton(_ sender: UIButton) {
        let pos = CGPoint(x: self.view.frame.width * 4, y: 0)
        scrollView.setContentOffset(pos, animated: true)
        birthDayTextField.resignFirstResponder()
    }
    
    
    
    
    @IBAction func genderButtonPressed(_ sender: UIButton) {
        
        // STEP 1: Declare the URL of the request
        
        let baseUrl = URL(string: "http://localhost:8888/Facebook/register.php")!
        
        let query: [String: String] = [
            "email": String(emailTextField.text!.lowercased()),
            "firstname": String(firstNameTextfield.text!.lowercased()),
            "lastname": String(lastnameTextField.text!.lowercased()),
            "password": String(passTextField.text!),
            "birthday": String(datePicker.date.description),
            "gender": String(sender.tag)
        ]
        
        let url = baseUrl.withQueries(query)
        
        let helper = Helper()
        
        // STEP 2: Execute the above request
        Network.shared.performRequestWithURL(async: true, url: url!, in: self, status: "200", with: helper, onSuccess: { (parsedJSON) in
            helper.instantiateViewController(identifier: "TabBar", animated: true, by: self, completion: nil)
            
            
            currentUser = parsedJSON.mutableCopy() as? NSDictionary
            
            
            UserDefaults.standard.setValue(currentUser, forKey: "currentUser")
            UserDefaults.standard.synchronize()
        }) { (err) in
            print(err)
            
        }
        
    }
    
    
    @IBAction func alredyHaveAnAccount(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            self.configure_button(gender: self.femaleButton)
            self.configure_button(gender: self.maleButton)
        }
        
    }
    
    
}
