//
//  LoginViewController.swift
//  FaceBook
//
//  Created by Fabio Bassini on 12/08/2020.
//  Copyright © 2020 Fabio Bassini. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var textFieldsView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rigthView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var handsImageView: UIImageView!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var coverImageViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var whiteIconImageViewY: NSLayoutConstraint!
    @IBOutlet weak var handsImageViewTop: NSLayoutConstraint!
    @IBOutlet weak var registerButtonBottom: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    //    deinit {
    //        NotificationCenter.default.removeObserver(self)
    //    }
    
    //quando tocco lo schermo bianco
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // notifications
    @objc func keyboardWillShow(notification: Notification) {
        print("keyboardWillShowNotification is executed")
        
        let userInfo = notification.userInfo!
        let beginFrameValue = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)!
        let beginFrame = beginFrameValue.cgRectValue
        let endFrameValue = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)!
        let endFrame = endFrameValue.cgRectValue
        
        if beginFrame.equalTo(endFrame) {
            
            print("keyboard is alredy shown")
            
            return
        } else {
            coverImageViewConstraint.constant -= (self.view.frame.width / 2.2)
            handsImageViewTop.constant -= (self.view.frame.width / 2.2)
            whiteIconImageViewY.constant += self.view.frame.width / 5
            
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                registerButtonBottom.constant -= (keyboardSize.height) - (keyboardSize.height / 14)
            }
            
            UIView.animate(withDuration: 0.5) {
                self.handsImageView.alpha = 0
                
                self.view.layoutIfNeeded()
            }
            
        }
        
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        print("keyboardWillHideNotification is executed")
        
        coverImageViewConstraint.constant = 0
        handsImageViewTop.constant = 0
        whiteIconImageViewY.constant = 0
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            registerButtonBottom.constant = (keyboardSize.height) - (keyboardSize.height) / 0.95 - 6.5
        }
        
        UIView.animate(withDuration: 0.5) {
            self.handsImageView.alpha = 1
            
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        configureTextFieldsView()
        configureLoginButton()
        configureOrLabel()
        configureRegisterButton()
    }
    
    func configureTextFieldsView() {
        let width = CGFloat(2)
        let color = UIColor.groupTableViewBackground.cgColor
        
        //creating layer to be a border of a view
        let border = CALayer()
        border.borderColor = color
        border.frame = CGRect(x: 0, y: 0, width: textFieldsView.frame.width, height: textFieldsView.frame.height)
        border.borderWidth = width
        
        
        //create a latyer to be a line in the center of the view
        let line = CALayer()
        line.borderWidth = width
        line.borderColor = color
        line.frame = CGRect(x: 0, y: textFieldsView.frame.height / 2 - 2, width: textFieldsView.frame.width, height: width)
        
        //assigning layers to the view
        textFieldsView.layer.addSublayer(border)
        textFieldsView.layer.addSublayer(line)
        
        //corner radius to the view
        textFieldsView.layer.cornerRadius = 5
        textFieldsView.layer.masksToBounds = true
    }
    
    
    func configureLoginButton() {
        loginButton.layer.cornerRadius = 5
        loginButton.layer.masksToBounds = true
        //        loginButton.isEnabled = false
        
    }
    
    func configureOrLabel() {
        
        let width = CGFloat(2)
        let color = UIColor.groupTableViewBackground.cgColor
        
        
        //creating left line object
        let leftLine = CALayer()
        leftLine.borderWidth = width
        leftLine.borderColor = color
        leftLine.frame = CGRect(x: 0, y: leftView.frame.height / 2 - width, width: leftView.frame.width, height: width)
        
        
        //creating right line object
        let rightLine = CALayer()
        rightLine.borderWidth = width
        rightLine.borderColor = color
        rightLine.frame = CGRect(x: 0, y: rigthView.frame.height / 2 - width, width: rigthView.frame.width, height: width)
        
        //assigning to the view
        leftView.layer.addSublayer(leftLine)
        rigthView.layer.addSublayer(rightLine)
        
        
    }
    
    
    func configureRegisterButton() {
        
        // creating constant named 'border'
        let border = CALayer()
        border.borderWidth = 2
        border.borderColor = UIColor(red: 68/255, green: 105/255, blue: 176/255, alpha: 1).cgColor
        border.frame = CGRect(x: 0, y: 0, width: registerButton.frame.width, height: registerButton.frame.height)
        
        
        // assigninig border to the obj (button)
        registerButton.layer.addSublayer(border)
        
        //round it
        registerButton.layer.cornerRadius = 5
        registerButton.layer.masksToBounds = true
        
        
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        let helper = Helper()
        
        if helper.isValid(email: emailTextField.text!) == false {
            
            helper.showAlert(title: "Invalid email", message: "Please enter the resgistered email address", in: self)
            return
            
        } else if passwordTextField.text!.count < 6 {
            helper.showAlert(title: "Invalid Password", message: "Password must be contain at least 6 charaters", in: self)
            return
        }
        
        loginRequest()
        
    }
    
    
    func loginRequest() {
        
        let baseUrl = URL(string: "http://localhost:8888/Facebook/login.php")!
        
        let query: [String: String] = [
            "email": String(emailTextField.text!.lowercased()),
            "password": String(passwordTextField.text!)
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
}
