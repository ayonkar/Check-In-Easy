//
//  SignInController.swift
//  CheckInEasy
//
//  Created by Ayon Kar on 4/25/18.
//  Copyright © 2018 Ayon Kar. All rights reserved.
//

import UIKit
import CoreData

var userdata = [UserT]()

class SignInController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    var result = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInAction(_ sender: UIButton) {

        
        let username = self.username.text;
        let password = self.password.text;
        
        //Check for empty field
        if((username?.isEmpty)! || (password?.isEmpty)!){
            displayAlertMessage(userMessage: "All fields are required")
            return;
        }
        else{
            do{
                userdata = try context.fetch(UserT.fetchRequest())
            } catch {
                print("Error")
            }

                
                if(userdata.count > 0){
                    let x = (userdata[0] as AnyObject).value(forKey: "username") as! String
                    let y = (userdata[0] as AnyObject).value(forKey: "password") as! String
                    
                    if username == x && password == y {
                        print("Logged In")
                        isUserLoggedIn = true
                        
                        if let nav = self.navigationController {
                            nav.popViewController(animated: true)
                        } else {
                            self.dismiss(animated: true, completion: nil)
                        }
                        
//                        self.dismiss(animated: true, completion:nil);
                    }
                    else {
                        displayAlertMessage(userMessage: "Wrong username/password. Please try again.")
                    }
                    
                }
                else{
                    displayAlertMessage(userMessage: "No user is registered")
                }
            }

    }
    
    func displayAlertMessage(userMessage: String){
        let myAlert = UIAlertController(title:"Info", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"Ok", style: UIAlertActionStyle.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
