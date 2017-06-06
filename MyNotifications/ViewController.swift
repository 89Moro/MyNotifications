//
//  ViewController.swift
//  MyNotifications
//
//  Created by Ospite on 06/06/17.
//  Copyright © 2017 Ospite. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController,UNUserNotificationCenterDelegate {
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    var messageSubtitle = " Riunione con lo staff tecnico "

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //richiesta id autorizzazione la sistema di notificare
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler:{(granted,error) in  //gestione errore
        })
        
        UNUserNotificationCenter.current().delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    //presenta la tipologia di notifica
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier{
            case "Repat":
                self.sendNotification()
            case "Cambia":
                let textResponse =  response as! UNTextInputNotificationResponse
                messageSubtitle = textResponse.userText
        default :
            break
        }
        completionHandler()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnNotification_TouchUp(_ sender: Any)
    {
        sendNotification()
    }
    //lancia la notifica quando esco dall'app con home
    func sendNotification()
    {
        let content = UNMutableNotificationContent()
        content.title = "Notifica Riunione"
        content.subtitle = messageSubtitle
        content.body = "Ricordarsi si portare il caffè"
        content.badge = 1
        
        let repeatAction = UNNotificationAction(identifier:"Repeat",title: "Ripeti",options:[])
        let changeAction = UNTextInputNotificationAction(identifier:"Cambia",title:"Modifica Notifica",options: [])
        let category = UNNotificationCategory(identifier:"actionCategory",actions: [repeatAction,changeAction],intentIdentifiers:[], options:[])
        content.categoryIdentifier = "actionCategory"
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,repeats: false)
        
        let requestIdentifier = "testNotification"
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request,withCompletionHandler: {(error) in // gestione errore
            })
    }
    
    @IBAction func btnCancel_TouchUp(_ sender: Any) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers:["testNotifications"])
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
    }
    
}

