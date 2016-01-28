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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
       // NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func keyboardWillShow(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.top.constant = 240 - keyboardFrame.size.height
        })
    }

    
    @IBAction func loginAction() {
        view.endEditing(true)
        if let username = username.text, password = password.text {
            let config = CocOAuthConfig(tokenURL: NSURL(string: "http://brentertainment.com/oauth2/lockdin/token")!, clientID: "demoapp", clientSecret: "demopass")
            let account = Account(config: config)
            account.authenticateWithUsername(username, password: password) {
            }
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

