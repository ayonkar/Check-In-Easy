//
//  eventDetailController.swift
//  CheckInEasy
//
//  Created by Ayon Kar on 4/24/18.
//  Copyright © 2018 Ayon Kar. All rights reserved.
//

import UIKit
import MapKit
import CoreData

var booking_data = [BookingT]()


class eventDetailController: UIViewController {
    
    var eventDetail: EventT?
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventAddress: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    @IBAction func panGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        if let view = sender.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        sender.setTranslation(CGPoint.zero, in: self.view)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Getting Event Image
        let pictureURL = URL(string: (eventDetail?.logo!)!)!
        let session = URLSession(configuration: .default)
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
                        self.eventImage.image = UIImage(data: imageData)
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
        
        //Getting Event Name
        eventName.lineBreakMode = .byWordWrapping
        eventName.numberOfLines = 0
        eventName.text! = (eventDetail?.event_name!)!
        
        //Getting Start Date
        //Convert String to Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from: (eventDetail?.start_date!)!) //according to date format your date string
        print("The DATA is \(date!)")
        
        //Convert Date to Month
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: date!)
        print("The MONTH is \(nameOfMonth)")
        
        //Slicing Date in a range
        let start = eventDetail!.start_date!.index((eventDetail!.start_date!.startIndex), offsetBy: 8)

        let end = eventDetail!.start_date!.index((eventDetail!.start_date!.endIndex), offsetBy: -9)
        let range = start..<end
        let mySubstring = eventDetail?.start_date![range]  // play

        eventDate.text = nameOfMonth.substring(to:nameOfMonth.index(nameOfMonth.startIndex, offsetBy: 3)).capitalized + " " + String(describing: mySubstring!) + "," + eventDetail!.start_date!.substring(to:eventDetail!.start_date!.index(eventDetail!.start_date!.startIndex, offsetBy: 4))
        
        //Getting EVent Address
        eventAddress.text! = (eventDetail?.address!)!
        
        //Getting Map
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        let regionRadius: CLLocationDistance = 1000
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                      regionRadius, regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        centerMapOnLocation(location: initialLocation)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func BookEvent(_ sender: UIBarButtonItem) {
        
        do{
            user_data = try context.fetch(UserT.fetchRequest())
            booking_data = try context.fetch(BookingT.fetchRequest())
            event_data = try context.fetch(EventT.fetchRequest())
            
        } catch{
            print("Error")
        }
        
        var bookingId = 1000
        
        var flag = true
        for book in booking_data{
            
            if(book.bookingId == Int64(bookingId)){
                flag = false;
                break;
            }
        }
        
        
        if(user_data.count > 0){
            
            if(flag){

            for user in user_data{
                
                for event in event_data{
                    
                        
                        print("Event Address \(event.address!)")
                        print("Event Address Specific View \(eventAddress.text!)")
                            
                            if(event.address == eventAddress.text!){
                                
                                print("Inside Booking Customer \(user.username!)")
                                
                                let new_user = UserT(context: context)
                                new_user.username = user.username
                                
                                let new_event = EventT(context: context)
                                new_event.event_name = event.event_name
                                new_event.address = event.address
                                
                                let book_event = BookingT(context: context)
                                book_event.bookingId = Int64(bookingId)
                                book_event.with = new_user
                                book_event.by = new_event
                                print("Before App delegate")
                                appDelegate.saveContext()
                                bookingId += 1
                                //                    checkBookingData();
                                let alertController = UIAlertController(title: "Info", message: "Booking successfully done", preferredStyle: .alert)
                                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(OKAction)
                                self.present(alertController, animated: true, completion: nil)
                                
                                break;
                        }
                 

                    }

                }

            }
            else{
                let alertController = UIAlertController(title: "Info", message: "Booking exist", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        else{
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let abcViewController = storyboard.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
            navigationController?.pushViewController(abcViewController, animated: true)

        }

   }
    
    func checkBookingData() {
        
        for b in booking_data{
            print("Inside booking data")
            print(b.bookingId)
            print(b.with!.username!)
            print(b.by!.event_name!)
            print("End")
        }
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
