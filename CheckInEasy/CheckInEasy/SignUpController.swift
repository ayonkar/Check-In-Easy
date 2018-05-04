//
//  SignUpController.swift
//  CheckInEasy
//
//  Created by Ayon Kar on 4/25/18.
//  Copyright © 2018 Ayon Kar. All rights reserved.
//

import UIKit
import CoreData

var user_data = [UserT]()

class SignUpController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        username.isEnabled = true
//        username.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpAction(_ sender: UIButton) {
        
        let username = self.username.text;
        let password = self.password.text;
        
        //Check for empty field
        if((username?.isEmpty)! || (password?.isEmpty)!){
            displayAlertMessage(userMessage: "All fields are required")
            return;
        }
        else{
            do{
                user_data = try context.fetch(UserT.fetchRequest())
            } catch {
                print("Error")
            }
            
            var flag = true;
            for x in user_data {
                print(x.username!)
                if x.username == username {
                    flag = false;
                }
            }
            
            if(flag){
                let new_user = UserT(context: context)
                new_user.username = username
                new_user.password = password
                
                appDelegate.saveContext()
                displayAlertMessage(userMessage: "Thank you for registering with us")

            }
            else{
                displayAlertMessage(userMessage: "User already exist")
            }
        }
        
        
    }
    
    func displayAlertMessage(userMessage: String){
        let myAlert = UIAlertController(title:"Info", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"Ok", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }

}
