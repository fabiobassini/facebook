//
//  Network.swift
//  FaceBook
//
//  Created by Fabio Bassini on 02/09/2020.
//  Copyright © 2020 Fabio Bassini. All rights reserved.
//

import UIKit

class Network {
    
    static let shared = Network()
    
    /// Perform url Datatask(:url) in the main Thread
    func performRequestWithURL(async: Bool, url: URL, in alertVc: UIViewController, status on: String, with helper: Helper, onSuccess: @escaping (_ parsedJSON: NSDictionary) -> Void, onError: @escaping (_ errorMessage: String) -> Void) {
        
        
        if async == true {
            
            // STEP 2: Execute the above request
            URLSession.shared.dataTask(with: url) { (data, resp, err) in
                
                DispatchQueue.main.async {
                    //let helper = Helper()
                    
                    if err != nil {
                        helper.showAlert(title: "Server Error", message: err!.localizedDescription, in: alertVc)
                        return
                    }
                    
                    guard data != nil else {
                        helper.showAlert(title: "Data Error", message: err!.localizedDescription, in: alertVc)
                        return
                    }
                    
                    guard let data = data else {
                        return
                    }
                    
                    let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                    
                    guard let parsedJson = json else {
                        print("Parsing Error")
                        return
                    }
                    //Succesfully Logged In / registered
                    if (parsedJson["status"] as! String) == on {
                        
                        onSuccess(parsedJson)
                        
                    } else {
                        
                        if parsedJson["message"] != nil {
                            
                            let message = parsedJson["message"] as! String
                            helper.showAlert(title: "Error", message: message, in: alertVc)
                            onError(message)
                        }
                    }
                    
                    
                    print(parsedJson as Any)
                }
            }.resume()
            
        } else {
            
            
            // STEP 2: Execute the above request
            URLSession.shared.dataTask(with: url) { (data, resp, err) in
                
                //let helper = Helper()
                
                if err != nil {
                    helper.showAlert(title: "Server Error", message: err!.localizedDescription, in: alertVc)
                    return
                }
                
                guard data != nil else {
                    helper.showAlert(title: "Data Error", message: err!.localizedDescription, in: alertVc)
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                
                guard let parsedJson = json else {
                    print("Parsing Error")
                    return
                }
                
                //Succesfully Logged In / registered
                if (parsedJson["status"] as! String) == on {
                    
                    onSuccess(parsedJson)
                    
                } else {
                    
                    if parsedJson["message"] != nil {
                        
                        let message = parsedJson["message"] as! String
                        helper.showAlert(title: "Error", message: message, in: alertVc)
                        onError(message)
                    }
                }
                
                print(parsedJson as Any)
                
            }.resume()
        }
    }
    
    /// Perform url Datatask(:urlRequest) in the main Thread
    func performRequestWithURLRequest(async: Bool, url: URLRequest, status on: String, in alertVc: UIViewController, with helper: Helper,  onSuccess: @escaping (_ parsedJSON: NSDictionary) -> Void, onError: @escaping (_ errorMessage: String) -> Void) {
        
        if async == true {
            
            
            // STEP 2: Execute the above request
            
            
            URLSession.shared.dataTask(with: url) { (data, resp, err) in
                DispatchQueue.main.async {
                    //let helper = Helper()
                    
                    if err != nil {
                        helper.showAlert(title: "Server Error", message: err!.localizedDescription, in: alertVc)
                        return
                    }
                    
                    guard data != nil else {
                        helper.showAlert(title: "Data Error", message: err!.localizedDescription, in: alertVc)
                        return
                    }
                    
                    guard let data = data else {
                        return
                    }
                    
                    let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                    
                    guard let parsedJson = json else {
                        print("Parsing Error")
                        return
                    }
                    
                    //Succesfully Logged In / registered
                    if (parsedJson["status"] as! String) == on {
                        
                        onSuccess(parsedJson)
                        
                    } else {
                        
                        if parsedJson["message"] != nil {
                            
                            let message = parsedJson["message"] as! String
                            helper.showAlert(title: "Error", message: message, in: alertVc)
                            onError(message)
                        }
                    }
                    
                    
                    print(parsedJson as Any)
                }
            }.resume()
            
        } else {
            
            
            
            // STEP 2: Execute the above request
            
            
            URLSession.shared.dataTask(with: url) { (data, resp, err) in
                
                //let helper = Helper()
                
                if err != nil {
                    helper.showAlert(title: "Server Error", message: err!.localizedDescription, in: alertVc)
                    return
                }
                
                guard data != nil else {
                    helper.showAlert(title: "Data Error", message: err!.localizedDescription, in: alertVc)
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                
                guard let parsedJson = json else {
                    print("Parsing Error")
                    return
                }
                
                //Succesfully Logged In / registered
                if (parsedJson["status"] as! String) == on {
                    
                    onSuccess(parsedJson)
                    
                } else {
                    
                    if parsedJson["message"] != nil {
                        
                        let message = parsedJson["message"] as! String
                        helper.showAlert(title: "Error", message: message, in: alertVc)
                        onError(message)
                    }
                }
                
                print(parsedJson as Any)
                
                
            }.resume()
        }
        
        
    }
    
    
    
    /// Perform url Datatask(:urlRequest) in the main Thread
    func performRequestWithURLRequestCompletionHandler(async: Bool, url: URLRequest, status on: String, in alertVc: UIViewController, with helper: Helper, completion: @escaping () -> Void,  onError: @escaping (_ errorMessage: String) -> Void) {
        
        if async == true {
            
            
            // STEP 2: Execute the above request
            
            
            URLSession.shared.dataTask(with: url) { (data, resp, err) in
                DispatchQueue.main.async {
                    //let helper = Helper()
                    
                    if err != nil {
                        helper.showAlert(title: "Server Error", message: err!.localizedDescription, in: alertVc)
                        return
                    }
                    
                    guard data != nil else {
                        helper.showAlert(title: "Data Error", message: err!.localizedDescription, in: alertVc)
                        return
                    }
                    
                    guard let data = data else {
                        return
                    }
                    
                    let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                    
                    guard let parsedJson = json else {
                        print("Parsing Error")
                        return
                    }
                    
                    //Succesfully Logged In / registered
                    if (parsedJson["status"] as! String) == on {
                        
                        completion()
                    } else {
                        
                        if parsedJson["message"] != nil {
                            
                            let message = parsedJson["message"] as! String
                            helper.showAlert(title: "Error", message: message, in: alertVc)
                            onError(message)
                        }
                    }
                    
                    
                    print(parsedJson as Any)
                }
            }.resume()
            
        } else {
            
            
            
            // STEP 2: Execute the above request
            
            
            URLSession.shared.dataTask(with: url) { (data, resp, err) in
                
                //let helper = Helper()
                
                if err != nil {
                    helper.showAlert(title: "Server Error", message: err!.localizedDescription, in: alertVc)
                    return
                }
                
                guard data != nil else {
                    helper.showAlert(title: "Data Error", message: err!.localizedDescription, in: alertVc)
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                
                guard let parsedJson = json else {
                    print("Parsing Error")
                    return
                }
                
                //Succesfully Logged In / registered
                if (parsedJson["status"] as! String) == on {
                    
                    completion()
                    
                } else {
                    
                    if parsedJson["message"] != nil {
                        
                        let message = parsedJson["message"] as! String
                        helper.showAlert(title: "Error", message: message, in: alertVc)
                        onError(message)
                    }
                }
                
                print(parsedJson as Any)
                
                
            }.resume()
        }
        
        
    }
    
}
