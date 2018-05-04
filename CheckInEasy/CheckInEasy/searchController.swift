//
//  searchController.swift
//  CheckInEasy
//
//  Created by Ayon Kar on 4/27/18.
//  Copyright © 2018 Ayon Kar. All rights reserved.
//

import UIKit
import CoreData

class searchController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchView: UISearchBar!
    var filteredRooms = [EventT]();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.rowHeight = 240.0
        
        do{
            
            event_data = try context.fetch(EventT.fetchRequest())
            
        } catch{
            print("Error")
        }
        
        filteredRooms = event_data;
        searchView.delegate = self
        
        
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
//        do{
//
//            event_data = try context.fetch(EventT.fetchRequest())
//
//        } catch{
//            print("Error")
//        }
        return filteredRooms.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "CellSearchViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as?
            CellSearchViewCell else{fatalError("The dequeued cell is not an instance of CellSearchViewCell.")}
        
        
        let eventData = filteredRooms[indexPath.row]
        
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
        cell.eventMonth.text = nameOfMonth.substring(to:nameOfMonth.index(nameOfMonth.startIndex, offsetBy: 3)).uppercased()
        
        //Slicing Date in a range
        let start = eventData.start_date!.index(eventData.start_date!.startIndex, offsetBy: 8)
        let end = eventData.start_date!.index(eventData.start_date!.endIndex, offsetBy: -9)
        let range = start..<end
        let mySubstring = eventData.start_date![range]  // play
        cell.eventDate.text = " " + String(mySubstring)
        
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !(searchView.text?.isEmpty)! else{
            filteredRooms = event_data
            tableView.reloadData()
            return
        }
        filteredRooms = event_data.filter({search -> Bool in guard
            let text = searchView.text else { return false }
            return (search.event_name?.lowercased().contains(text.lowercased()))!
        })
        tableView.reloadData();
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
