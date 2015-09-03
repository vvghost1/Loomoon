//
//  ViewController.swift
//  Loomoon
//
//  Created by Yura Vorontsov on 02.09.15.
//  Copyright (c) 2015 Yura Vorontsov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LoginDelegate, UITextFieldDelegate
{
    let loginClass = Networking()
    var alert = UIAlertController(title: "Error", message: "", preferredStyle: UIAlertControllerStyle.Alert)
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var passwordOutlet: UITextField!{didSet{passwordOutlet.secureTextEntry = true}}
    @IBOutlet weak var loginOutlet: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginButtonPress()
    {
        if passwordOutlet.isFirstResponder()
        {
            passwordOutlet.resignFirstResponder()
        }
        if loginOutlet.isFirstResponder()
        {
            loginOutlet.resignFirstResponder()
        }
        if isFieldsNotEmpty()
        {
            //loginClass.login(login: "9643304900014655",password: "11")
            loginClass.login(login: loginOutlet.text, password: passwordOutlet.text)
            spinner.startAnimating()
            loginButton.enabled = false
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loginClass.delegate = self
        alert.addAction(UIAlertAction(title: "ok", style: .Default, handler: nil))
    }
    
    
//MARK: LoginDelegate
    func someErrorInLogin()
    {
        resetToStartState()
        alert.message = "Network error"
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func loginSuccess()
    {
        sleep(5)
        resetToStartState()
        performSegueWithIdentifier("userInfo", sender: nil)
    }
    
    func invalidLoginOrPassword()
    {
        resetToStartState()
        alert.message = "Invalid login"
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if let mvc = segue.destinationViewController as? UserInfoViewController
        {
            mvc.dataSourse = loginClass
        }
    }
    
    func resetToStartState()
    {
        spinner.stopAnimating()
        loginButton.enabled = true
        loginOutlet.text = ""
        passwordOutlet.text = ""
    }
    
//MARK: Textfields
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func isFieldsNotEmpty() -> Bool
    {
        if let pwd = passwordOutlet.text, lgn = loginOutlet.text
        {
            if pwd != "" && lgn != ""
            {
                return true
            }
        }
        return false
    }

}

