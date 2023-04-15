//
//  Helper.swift
//  FaceBook
//
//  Created by Fabio Bassini on 16/08/2020.
//  Copyright © 2020 Fabio Bassini. All rights reserved.
//

import UIKit

class Helper {
    
    static let shared = Helper()
    
    // validate email address function / logic
    func isValid(email: String) -> Bool {
        
        // declaring the rule of regular expression (chars to be used). Applying the rele to current state. Verifying the result (email = rule)
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        let result = test.evaluate(with: email)
        
        return result
    }
    
    
    // validate name function / logic
    func isValid(name: String) -> Bool {
        
        // declaring the rule of regular expression (chars to be used). Applying the rele to current state. Verifying the result (email = rule)
        let regex = "[A-Za-z]{2,}"
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        let result = test.evaluate(with: name)
        
        return result
    }
    
    func showAlert(title: String, message: String, in vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(confirmButton)
        vc.present(alert, animated: true, completion: nil)
    }
    
    func instantiateViewController(identifier: String, animated: Bool, by vc: UIViewController, completion: (() -> Void)?) {
        
        let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
        vc.present(newVC, animated: animated, completion: completion)
        
    }
    
    func downloadImage(from path: String, with defaultMessage: String, and defaultImage: String, on imageView: UIImageView) {
        if path != defaultMessage {
            if let url = URL(string: path) {
                
                guard let data = try? Data(contentsOf: url) else {
                    imageView.image = UIImage(named: defaultImage)
                    return
                }
                guard let image = UIImage(data: data) else {
                    imageView.image = UIImage(named: defaultImage)
                    return
                }
                
                DispatchQueue.main.async {
                    imageView.image = image
                    
                }
                
            }
        }
    }
    
    func loadFullName(with name: String, lastname: String, show label: UILabel) {
        
        DispatchQueue.main.async {
            label.text = "\(name) \(lastname)"
            
        }
                
    }
    
    
    /// crea il corpo per una richiesta x caricare immagini e parametri
    func createBody(parameters: [String: Any], boundary: String, data: Data, mimeType: String, filename: String) -> Data {
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
    }
    
    /// crea il corpo per una richiesta x caricare solo parametri
    func createBody(parameters: [String: Any], boundary: String) -> Data {
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        
        return body as Data
    }
    
}
