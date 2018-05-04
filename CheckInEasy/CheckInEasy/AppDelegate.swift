//
//  AppDelegate.swift
//  CheckInEasy
//
//  Created by Ayon Kar on 4/14/18.
//  Copyright © 2018 Ayon Kar. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let key = "CRDYZ4HEKWZSSAPJL2X7"
    let eventUrl = "https://www.eventbriteapi.com/v3/events/search?token=CRDYZ4HEKWZSSAPJL2X7"
    let venueUrl = "https://www.eventbriteapi.com/v3/venues/"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        parseData();
//        deleteSampleData();
        
        return true
    }
    
//    func deleteSampleData(){
//
//        let ReqVar = NSFetchRequest<NSFetchRequestResult>(entityName: "UserT")
//        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: ReqVar)
//        do { try context.execute(DelAllReqVar) }
//        catch { print(error) }
//    }
    
    func parseData(){
        
        let city = "Boston"
        let url = "\(eventUrl)&location.address=\(city)"
        print(url)
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request){(data, response, error) in
            
            if (error != nil) {
                print("Error")
            }
            else {
                do {
                    let fetchedData = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                    
                    if let events = fetchedData["events"]! as? [Dictionary<String, Any>]{
                        var eventArray = [EventT]()
                        for eachFetchedEvent in events {
                            
                            print("Event Name")
                            let eventData = EventT(context: context)
                            var eventDict = [String:Any]()
                            let name = eachFetchedEvent["name"] as! [String:Any]
                            eventDict["name"] = name["text"] as! String
                            print(eventDict["name"]!)
                            for(_, value) in eventDict{
                                eventData.event_name = value as? String
                                //                                print("\(key) = \(value)")
                            }
                            
                            print("Event Start Date")
                            let end = eachFetchedEvent["end"] as! [String:Any]
                            eventDict["date"] = end["local"] as! String
                            print(eventDict["date"]!)
                            for(_, value) in eventDict{
                                eventData.start_date = value as? String
                            }
                            
                            print("Event Logo")
                            let logo = eachFetchedEvent["logo"] as? [String:Any]
                            if let log = logo {
                                let original = log["original"] as! [String:Any]
                                eventDict["image"] = original["url"] as! String
                            }
                            //                            print(eventDict["image"]!)
                            for(_, value) in eventDict{
                                eventData.logo = value as? String
                                
                            }
                            
                            print("Event Address")
                            let venueId = eachFetchedEvent["venue_id"] as? String
                            if let vid = venueId {
                                print("YESSS")
                                print(vid)
                                self.getVenueDetails(vid: vid, completionHandler: { (venueDetails) in
                                    let addressDict = venueDetails["address"]  as? [String:Any]
                                    print("YESSS")
                                    var adr = ""
                                    if let addr  = addressDict {
                                        if let address_one = addr["address_1"] as? String {
                                            print("address_one")
                                            print(address_one)
                                            adr = address_one
                                            eventDict["address"] = adr
                                            let lat = venueDetails["latitude"] as! String
                                            let lon = venueDetails["longitude"] as! String
                                            eventDict["latitude"] = lat
                                            eventDict["longitude"] = lon
                                        }
                                    }
                                    
                                    for(_, value) in eventDict{
                                        eventData.address = value as? String
                                        eventData.latitude = value as? String
//                                        print("Latitude\(eventData.latitude!)")
                                        eventData.longitude = value as? String
                                    }

//                                    print(eventDict["address"]!)
//                                    print(eventDict["latitude"]!)
//                                    print(eventDict["longitude"]!)
//                                    let newEvent = EventT(dictionary: eventDict)!
//                                    eventArray.append(newEvent)
                                    
                                })
                                
                            }
                            
                            
                            
                            //                            print(eventDict["address"]!)
                            
                            //                            if let rooms = eachFetchedHotel["rooms"] as? [[String: Any]]{
                            //
                            //                                if let eachRoom = rooms[0] as? [String:Any]{
                            //                                    if let roomType = eachRoom["room_type_info"] as? [String: Any]{
                            //                                        if (roomType["number_of_beds"] as? String) == "1"{
                            //                                            hotelData.occupancy = "Single"
                            //
                            //                                        }
                            //                                        else{
                            //                                            hotelData.occupancy = "Double"
                            //                                        }
                            //                                    }
                            //                                    if let amount = eachRoom["total_amount"] as? [String: Any]{
                            //                                        if let price = Double((amount["amount"] as? String)!){
                            //                                            hotelData.price = Int64(price)
                            //                                            hotelData.vacant_status = true;
                            //                                        }
                            //                                    }
                            //                                }
                            //                            }
                            //
                            //
                            //                            let image = UIImage(named: "hotel1")
                            //                            let imageData = UIImageJPEGRepresentation(image!, 1)
                            //                            hotelData.image = NSData(data: imageData!) as Data
                            appDelegate.saveContext()
                            
                        }
                    }
                }
                    
                catch{
                    print("Error 2")
                }
            }
        }
        task.resume()
        
    }
    
    func getVenueDetails(vid:String , completionHandler:@escaping (NSDictionary)->()) {
        
        //      let venueUrl = "https://www.eventbriteapi.com/v3/venues/(vid)/?token=CRDYZ4HEKWZSSAPJL2X7" /categories/:id/
        //        let venueUrl = "https://www.eventbriteapi.com/v3/categories/102/?token=CRDYZ4HEKWZSSAPJL2X7"
        
        let url = "\(venueUrl)\(vid)?token=\(key)"
        print(venueUrl)
        var request = URLRequest(url: URL(string:url)!)
        print(request)
        request.httpMethod = "GET"
        
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                
                if let data = data {
                    print("data")
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        print("Inside 1")
                        completionHandler(responseDictionary)
                    }
                }else {
                    print("Inside 2")
                    completionHandler([:])
                }
        });
        task.resume()
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "CheckInEasy")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

