//
//  ViewController.swift
//  Notification2Local
//
//  Created by Quý Ninh on 14/04/2023.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationCenter.requestAuthorization(options: [.alert, .sound]) {
            (premissionGrant, error) in
            if(!premissionGrant){
                print("Permission Denied")
            }
        }
    }
    @IBAction func scheduleAction(_ sender: Any) {
        
        notificationCenter.getNotificationSettings { (settings) in
            
        DispatchQueue.main.async {
                let title = self.titleTextField.text!
                let message = self.messageTextField.text!
                let date = self.datePicker.date
                
                if( settings.authorizationStatus == .authorized)
            {
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
                    self.notificationCenter.add(request) { (error) in
                        if(error != nil)
                        {
                            print("Error" + error.debugDescription)
                            return
                        }
                    }
                    let ac = UIAlertController(
                        title: "Notification Scheduled",
                        message: "At " + self.formattedDate(date: date),
                        preferredStyle: .alert)
                    ac.addAction(UIAlertAction(
                        title: "Ok",
                        style: .default,
                        handler: { (_) in }))
                    self.present(
                        ac,
                        animated: true
                    )
            }
            else
            {
                    let ac = UIAlertController(
                        title: "Enable Notification?",
                        message: "To feature you must enable notifications in settings ",
                        preferredStyle: .alert
                    )
                    let goToSettings = UIAlertAction(
                        title: "Settingss",
                        style: .default
                    ){ (_) in
                        guard let settingsURL = URL(string: UIApplication.openSettingsURLString)
                        else
                        {
                            return
                        }
                        
                        if(UIApplication.shared.canOpenURL(settingsURL))
                        {
                            UIApplication.shared.open(settingsURL){ (_) in}
                        }
                    }
                    ac.addAction(goToSettings)
                    ac.addAction(UIAlertAction(
                        title: "Ok",
                        style: .default,
                        handler: { (_) in }))
                    self.present(ac, animated: true)
                }
        }
        
    }
}
    func formattedDate(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MM yy HH:mm"
        return formatter.string(from: date)
    }
}

