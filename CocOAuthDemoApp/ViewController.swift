//
//  ViewController.swift
//  CocOAuthDemoApp
//
//  Created by Marko Seifert on 07.12.15.
//  Copyright © 2015 CocOAuth. All rights reserved.
//

import UIKit
import CocOAuth

class ViewController: UIViewController, UITextFieldDelegate  {

    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    
    @IBOutlet var top: NSLayoutConstraint!
    @IBOutlet var login: UIButton!
    
    @IBOutlet weak var message: UILabel!
    
    var authenticator:Authenticator?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let config = OAuth2Config(tokenURL: URL(string: "https://brentertainment.com/oauth2/lockdin/token")!, clientID: "demoapp", clientSecret: "demopass")
        
    
        //let url = "http://192.168.128.115:8080/authorization_server/oauth/token"
        //let clientID = "F0B1C8C0-2964-40A0-AEFE-3EB1DA25A00Ddevelopment"
        //let clientSecret = "b7v5mpWw/t3Pp0a4pj8EFZs/f5OizeGdd/J5z1/xJxw="
        
        //let config = OAuth2Config(tokenURL: URL(string: url)!, clientID: clientID, clientSecret: clientSecret, additionalHeader:["tenant":"development"])

        authenticator = Authenticator(config: config)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
       // NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }

    @IBAction func onAccessToken(_ sender: Any) {
        
        authenticator?.retrieveAccessToken(handler: { (token, error) in
            if let accessToken = token{
                self.message.text = accessToken
            }else if let e = error{
                self.message.text = e.localizedDescription
                
            }
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func keyboardWillShow(_ notification: Notification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.top.constant = 240 - keyboardFrame.size.height
        })
    }
    
    @IBAction func loginAction() {
        view.endEditing(true)
        if let username = username.text, let password = password.text {
            authenticator?.authenticateWithUsername(username, password: password) {success, error in
                if(success){
                    self.message.text = "success"
                }else{
                    if let err = error{
                        self.message.text = err.localizedDescription
                    }
                }
                    
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

