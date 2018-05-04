//
//  BookingViewController.swift
//  CheckInEasy
//
//  Created by Ayon Kar on 4/26/18.
//  Copyright © 2018 Ayon Kar. All rights reserved.
//

import UIKit

class BookingViewController: UITableViewController {
    
    var booking_data = [BookingT]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 100.0
//        tableView.allowsMultipleSelectionDuringEditing = true;
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
            
            booking_data = try context.fetch(BookingT.fetchRequest())
            
        } catch{
            print("Error")
        }
        
        return booking_data.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cellIdentifier = "BookingViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as?
            BookingViewCell else{fatalError("The dequeued cell is not an instance of BookingViewCell.")}
        
        do{
            booking_data = try context.fetch(BookingT.fetchRequest())
            let bookingData = booking_data[indexPath.row]
//            let format = DateFormatter()
//            format.dateFormat = "yyyy-MM-dd"
            
            
            cell.username.text!  = (bookingData.with?.username!)!
            cell.bookingId.text! = String(bookingData.bookingId)
            cell.eventName.lineBreakMode = .byWordWrapping
            cell.eventName.numberOfLines = 0
            cell.eventName.text! = (bookingData.by?.event_name)!
//            cell.endDate.text! = format.string(for: bookingData.to_date!)!
        }
        catch{print("BookingError")}
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true;
//    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let note = booking_data[indexPath.row]
        
        if editingStyle == .delete {
            managedContext.delete(note)
            
            do {
//                try managedContext.save()
                appDelegate.saveContext()
            } catch let error as NSError {
                print("Error While Deleting Note: \(error.userInfo)")
            }

            appDelegate.saveContext()
        }
        
        //Code to Fetch New Data From The DB and Reload Table.
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: noteEntity)
        
        do {
            booking_data = try context.fetch(BookingT.fetchRequest())
        } catch let error as NSError {
            print("Error While Fetching Data From DB: \(error.userInfo)")
        }
        
        for b in booking_data{
            print("The booking Id is \(b.bookingId)")
        }
        tableView.reloadData()
    }

 

}
