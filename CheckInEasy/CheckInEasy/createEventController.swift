//
//  createEventController.swift
//  CheckInEasy
//
//  Created by Ayon Kar on 4/27/18.
//  Copyright © 2018 Ayon Kar. All rights reserved.
//

import UIKit

class createEventController: UIViewController,UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventAddress: UITextField!
    @IBOutlet weak var eventDate: UIDatePicker!
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            else{
                fatalError("Expected a Dictionary containing an Image , but was provided the following : \(info)")
        }
        eventImage.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectPicture(_ sender: UITapGestureRecognizer) {
        
                print("Inside image Picker ")
                eventName.resignFirstResponder()
                eventAddress.resignFirstResponder()
                eventDate.resignFirstResponder()
                //pick media from photo library
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.delegate = self
                present(imagePickerController, animated: true, completion: nil)
    }
    
    
//    @IBAction func selectPictures(_ sender: UITapGestureRecognizer) {
//        //Hide the Keyboard
//        print("Inside image Picker ")
//        eventName.resignFirstResponder()
//        eventAddress.resignFirstResponder()
//        eventDate.resignFirstResponder()
//        //pick media from photo library
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.sourceType = .photoLibrary
//        imagePickerController.delegate = self
//        present(imagePickerController, animated: true, completion: nil)
//    }
    
    
    @IBAction func saveEvent(_ sender: UIBarButtonItem) {
        
        let date = NSCalendar.current.compare(eventDate.date, to: Date(), toGranularity: .day)
        
        if eventName!.text != "" && eventAddress!.text != "" {
            
            if(date.rawValue < 0 )
            {
                let alertController = UIAlertController(title: "Info", message: "Event date cannot be less than current date", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                do{
                    event_data = try context.fetch(EventT.fetchRequest())
                }
                catch{print("Error")}
                
                let new_event = EventT(context: context)
                new_event.event_name = eventName!.text!
                print("Event Name\(new_event.event_name!) ")
                new_event.address = eventAddress!.text!
                print("Event Address \(new_event.address!) ")
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                let somedateString = dateFormatter.string(from: eventDate.date)
                new_event.start_date = somedateString
                print("Event Date \(new_event.start_date!) ")
                
                let selectedPicture = eventImage.image
                var setSelectedPicture = UIImageJPEGRepresentation(selectedPicture!, 3)
                //            let imageData:NSData = UIImagePNGRepresentation(selectedPicture!)! as NSData
                //            let strImageData = imageData.base64EncodedString(options: .lineLength64Characters)
                let url: String = "https://img.evbuc.com/https%3A%2F%2Fcdn.evbuc.com%2Fimages%2F35261743%2F224779210858%2F1%2Foriginal.jpg?auto=compress&s=977e40f448a39c8b2b515fc0008df929"
                //            new_event.logo = String(data: setSelectedPicture!, encoding: String.Encoding.utf8) as String!
                new_event.logo = url
                print("Event Picture \(new_event.logo!)")
                
                appDelegate.saveContext()
                
                let alertController = UIAlertController(title: "Info", message: "Event \(new_event.event_name!) is successfully created", preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }
            

        }
        else{
            let alertController = UIAlertController(title: "Info", message: "Please enter all the fields", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
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
