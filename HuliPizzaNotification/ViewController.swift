//
//  ViewController.swift
//  HuliPizzaNotification
//
//  Created by Janet Weber on 9/9/17.
//  Copyright © 2017 Weber Software Solutions. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController,UNUserNotificationCenterDelegate {

    var isGrantedNotificationAccess = false
    
    func makePizzaContent() -> UNMutableNotificationContent{
        let content = UNMutableNotificationContent()
        content.title = "A Timed Pizza Step"
        content.body = "Making Pizza"
        content.userInfo = ["Step":0]
        return content
    }
    
    func addNotification(trigger:UNNotificationTrigger?,content:UNMutableNotificationContent, identifier:String){
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request){
            (error) in
            if error != nil {
                print("Error adding notification:\(error?.localizedDescription)")
            }
        }
    }
    
    @IBAction func schedulePizza(_ sender: UIButton) {
        if isGrantedNotificationAccess {
            let content = UNMutableNotificationContent()
            content.title = "A Scheduled Pizza"
            content.body = "Time to Make a Pizza!!"
            let unitFlags:Set<Calendar.Component> = [.minute,.hour,.second]
            var date = Calendar.current.dateComponents(unitFlags, from: Date())
            date.second = date.second! + 15
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
            addNotification(trigger: trigger, content: content, identifier: "message.scheduled")
        }
    }

    @IBAction func makePizza(_ sender: UIButton) {
        if isGrantedNotificationAccess {
            let content = makePizzaContent()
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10.0, repeats: false)
            addNotification(trigger: trigger, content: content, identifier: "message.pizza")
        }
    }
    
    @IBAction func nextPizzaStep(_ sender: UIButton) {
    }
    
    @IBAction func viewPendingPizzas(_ sender: UIButton) {
    }
    
    @IBAction func viewDeliveredPizzas(_ sender: UIButton) {
    }
    
    @IBAction func removeNotification(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (granted, error) in
            self.isGrantedNotificationAccess = granted
            if !granted {
                //add alert to complain to user
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK :  DELEGATES
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
    }

}

