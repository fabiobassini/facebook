//
//  UIViewExtens.swift
//  FaceBook
//
//  Created by Fabio Bassini on 15/08/2020.
//  Copyright © 2020 Fabio Bassini. All rights reserved.
//

import UIKit

extension RegisterViewController {
    
    
    /// make corners rounded for any views (objects)
    func cornerRadius(for view: UIView) {
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
    }
 
    func padding(for textField: UITextField) {
        let blankView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: 35))
        textField.leftView = blankView
        textField.leftViewMode = .always
    }
    
    /// configuring the appearance of the footerView
    func configure_footerView() {
        
        // adding the line at the top of the footerView
        let topLine = CALayer()
        topLine.borderWidth = 1
        topLine.borderColor = UIColor.lightGray.cgColor
        topLine.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 1)
        
        footerView.layer.addSublayer(topLine)
        
    }
    
    
    
    /// cinfiguring the appearance of the gender buttons
    func configure_button(gender button: UIButton) {
        
        // creating constant with name border which's of type CALayer (it can execute func-s of CALayer Class)
        let border = CALayer()
        border.borderWidth = 1.5
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: 0, width: button.frame.width, height: button.frame.height)
        
        // assign the layer created to the button
        button.layer.addSublayer(border)
        
        // making corners rounded
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        
    }
    
}


extension URL {
    
    /// append parameters to the url with automatic &key=value
    func withQueries(_ queries: [String: Any]) -> URL? {
        var components = URLComponents(url: self,resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map {URLQueryItem(name: $0.0, value: $0.1 as? String)}
        return components?.url
    }
}
    


extension HomeTableViewController {
    
//    /// crea il corpo per una richiesta
//    func createBody(parameters: [String: Any], boundary: String, data: Data, mimeType: String, filename: String) -> Data {
//        let body = NSMutableData()
//
//        let boundaryPrefix = "--\(boundary)\r\n"
//
//        for (key, value) in parameters {
//            body.appendString(boundaryPrefix)
//            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//            body.appendString("\(value)\r\n")
//        }
//
//        body.appendString(boundaryPrefix)
//        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
//        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
//        body.append(data)
//        body.appendString("\r\n")
//        body.appendString("--".appending(boundary.appending("--")))
//
//        return body as Data
//    }
}

//extension UIViewController {
//    
//    /// crea il corpo per una richiesta
//    func createGeneralBodyParameters(parameters: [String: Any], boundary: String) -> Data {
//        let body = NSMutableData()
//        
//        let boundaryPrefix = "--\(boundary)\r\n"
//        
//        for (key, value) in parameters {
//            body.appendString(boundaryPrefix)
//            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//            body.appendString("\(value)\r\n")
//        }
//        
//        
//        return body as Data
//    }
//}



extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}


extension String
{
    func toDateString( inputDateFormat inputFormat  : String,  ouputDateFormat outputFormat  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        guard let date = dateFormatter.date(from: self) else {
            return "Error"
        }
        dateFormatter.dateFormat = outputFormat
        return dateFormatter.string(from: date)
    }
}

