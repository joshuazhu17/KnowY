//
//  CountdownViewController.swift
//  KnowY
//
//  Created by Joshua Zhu on 7/24/18.
//  Copyright © 2018 joshuazhu. All rights reserved.
//

import UIKit
import UserNotifications

class CountdownViewController: UIViewController {

    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    var duration: TimeInterval!
    var timer = Timer()
    var isRunning = true
    var seconds: TimeInterval!
    
    func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(CountdownViewController.updateLabel)), userInfo: nil, repeats: true)
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        if isRunning {
            isRunning = false
            startButton.setTitle("Resume", for: .normal)
            timer.invalidate()
        }
        else {
            isRunning = true
            startButton.setTitle("Pause", for: .normal)
            runTimer()
        }
        
    }
    
    @objc func updateLabel() {
        if seconds <= 0 {
            let content = UNMutableNotificationContent()
            content.title = "Timer done!"
            content.body = "Check on the app!"
            content.sound = UNNotificationSound.default()
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.001, repeats: false)
            
            let request = UNNotificationRequest(identifier: "testIdentifier", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            self.timer.invalidate()
            performSegue(withIdentifier: "timerDone", sender: self)
        }
        else {
            seconds! -= 1.0
            timeLeftLabel.text = timeString(time: seconds)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seconds = duration
        timeLeftLabel.text = timeString(time: duration)
        timeLeftLabel.layer.cornerRadius = 12
        timeLeftLabel.layer.masksToBounds = true
        
        runTimer()

        // Do any additional setup after loading the view.
        
        startButton.layer.cornerRadius = 12
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        timer.invalidate()
    }
    

}
