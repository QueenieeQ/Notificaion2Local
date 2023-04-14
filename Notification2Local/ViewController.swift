//
//  ViewController.swift
//  Notification2Local
//
//  Created by Quý Ninh on 14/04/2023.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    @IBOutlet weak var datePicker:
    UIDatePicker!
    @IBOutlet weak var titleTextField:
    UITextField!
    
    @IBOutlet weak var messageTextField:
    UITextField!
    
    let notificationCenter = UNUserNotificationCenter.current()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        notificationCenter.requestAuthorization(options: [.alert, .sound]) {
            (premissionGrant, error) in
            if(premissionGrant){
                print("Permission Denied")
            }
        }
    }

    @IBAction func scheduleAction(_ sender: Any) {
        
        notificationCenter.getNotificationSettings { (settings) in
            let title = self.titleTextField.text!
            let message = self.messageTextField.text!
            let date = self.datePicker.date
            
            if( settings.authorizationStatus == .authorized){
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = message
                
                let dateComp = Calendar.current.dateComponents(
                    [.year, .month, .day, .hour, .minute],
                    from: date
                )
                let trigger = UNCalendarNotificationTrigger(
                    dateMatching: dateComp,
                    repeats: false
                )
                
                let request = UNNotificationRequest(
                    identifier: UUID().uuidString,
                    content: content,
                    trigger: trigger
                )
                self.notificationCenter.add(request) {(error) in
                    if(error != nil){
                        print("Error" + error.debugDescription)
                        return
                    }
                }
                let ac = UIAlertController(title: "Notification Scheduled", message: "At " + formattedDate(date: date), preferredStyle: .alert)
            }else{
                
            }
    }
        
        func formattedDate(date: Date) -> String{
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MM yy HH:mm"
            return formatter.string(from: date)
        }
    
    }
}

