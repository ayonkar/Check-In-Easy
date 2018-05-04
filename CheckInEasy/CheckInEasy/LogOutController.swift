//
//  LogOutController.swift
//  CheckInEasy
//
//  Created by Ayon Kar on 4/26/18.
//  Copyright © 2018 Ayon Kar. All rights reserved.
//

import UIKit

var isUserLoggedIn = false

class LogOutController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        
        if(!isUserLoggedIn)
        {
            self.performSegue(withIdentifier: "loginView", sender: self);
        }
        
        
    }
    
    
    @IBAction func logOutAction(_ sender: UIButton) {
        
//        UserDefaults.standard.set(false,forKey:"isUserLoggedIn");
//        UserDefaults.standard.synchronize();
        
        self.performSegue(withIdentifier: "homeView", sender: self);
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
