//
//  InitialTableViewController.swift
//  CheckInEasy
//
//  Created by Ayon Kar on 4/23/18.
//  Copyright © 2018 Ayon Kar. All rights reserved.
//

import UIKit
import CoreData

var event_data = [EventT]()


class InitialTableViewController: UITableViewController {
    
//    let key = "CRDYZ4HEKWZSSAPJL2X7"
//    let eventUrl = "https://www.eventbriteapi.com/v3/events/search?token=CRDYZ4HEKWZSSAPJL2X7"
//    let venueUrl = "https://www.eventbriteapi.com/v3/venues/"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
//        parseData();
//        fetchData();
        
        self.tableView.rowHeight = 240.0
        
        do{
            
            event_data = try context.fetch(EventT.fetchRequest())
            
        } catch{
            print("Error")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
                do{
        
                    event_data = try context.fetch(EventT.fetchRequest())
        
                } catch{
                    print("Error")
                }
        print("Fetch Data Count \(event_data.count)")
        return event_data.count
    }
    



    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CellTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as?
            CellTableViewCell else{fatalError("The dequeued cell is not an instance of CellTableViewCell.")}

        
        let eventData = event_data[indexPath.row]

        let pictureURL = URL(string: eventData.logo!)!
        
        // Creating a session object with the default configuration.
        // You can read more about it here https://developer.apple.com/reference/foundation/urlsessionconfiguration
        let session = URLSession(configuration: .default)
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: pictureURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        cell.eventImage.image = UIImage(data: imageData)
                        // Do something with your image.
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        downloadPicTask.resume()
        
        //Convert String to Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from: eventData.start_date!) //according to date format your date string
        print("The DATA is \(date!)")
        
        //Convert Date to Month
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: date!)
        print("The MONTH is \(nameOfMonth)")
        
        //Slicing Month to first 3 characters
        cell.monthName.text = nameOfMonth.substring(to:nameOfMonth.index(nameOfMonth.startIndex, offsetBy: 3)).uppercased()
        
        //Slicing Date in a range
        let start = eventData.start_date!.index(eventData.start_date!.startIndex, offsetBy: 8)
        let end = eventData.start_date!.index(eventData.start_date!.endIndex, offsetBy: -9)
        let range = start..<end
        let mySubstring = eventData.start_date![range]  // play
        cell.date.text = " " + String(mySubstring)
        
//        let delimiter = "."
//        var event_name = eventData.event_name!
//        var token = event_name.components(separatedBy: delimiter)
//        print (token[0])
        
        //Multiple line activated for text
        cell.eventName.lineBreakMode = .byWordWrapping
        cell.eventName.numberOfLines = 0
        cell.eventName.text! = eventData.event_name!
        
        cell.eventAddress.text! = eventData.address!

        // Configure the cell...

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        return indexPath.row
//    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
            //        case "AddItem":
            //            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            
        case "dispplayEvent":
            guard let detailVC = segue.destination as? eventDetailController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let tableCell = sender as? CellTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: tableCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            do{
                 event_data = try context.fetch(EventT.fetchRequest())
                 detailVC.eventDetail = event_data[indexPath.row]
                
            }
            catch{
                print("Error in Databse")
            }
            
        case "login":
            guard segue.destination is LoginViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
        case "selfView":
            guard segue.destination is InitialTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
        case "createEvent":
            guard segue.destination is createEventController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
        case "searchView":
            guard segue.destination is searchController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }


    @IBAction func BookingAction(_ sender: UIBarButtonItem) {
        
        do{
            user_data = try context.fetch(UserT.fetchRequest())
        } catch{
            print("Error")
        }
        
        print("User data count \(user_data.count)")
        if(user_data.count == 0){
            noBookingFound();
        }
        else{
            bookingFound();
        }
    }
    
    func noBookingFound(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let abcViewController = storyboard.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
        navigationController?.pushViewController(abcViewController, animated: true)
        
    }
    
    func bookingFound(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let abcViewController = storyboard.instantiateViewController(withIdentifier: "bookingViewController") as! BookingViewController
        navigationController?.pushViewController(abcViewController, animated: true)
        
    }
    
    func fetchData(){
        do{
            event_data = try context.fetch(EventT.fetchRequest())
            print("Fetch Data Count \(event_data.count)")
            for i in event_data{
                print("Inside Fetch Data 2")
                print("Event Name : \(i.event_name!)")
                print("Event Address : \(i.address!)")
            }
        }catch{
            print("Error")
        }
    }


}
