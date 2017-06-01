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
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
       // NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
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
            let config = OAuth2Config(tokenURL: URL(string: "http://brentertainment.com/oauth2/lockdin/token")!, clientID: "demoapp", clientSecret: "demopass")
            let authenticator = Authenticator(config: config)
            authenticator.authenticateWithUsername(username, password: password) {success, errorMessage in
                if(success){
                    self.message.text = "success"
                }else{
                    self.message.text = errorMessage
                }
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

