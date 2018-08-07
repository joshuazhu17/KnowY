//
//  NewTimerViewController.swift
//  KnowY
//
//  Created by Joshua Zhu on 7/24/18.
//  Copyright © 2018 joshuazhu. All rights reserved.
//

import UIKit

class NewTimerViewController: UIViewController {

    @IBOutlet weak var durationDatePicker: UIDatePicker!
    @IBOutlet weak var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        durationDatePicker.countDownDuration = 60.0

        // Do any additional setup after loading the view.
        durationDatePicker.layer.cornerRadius = 12
        durationDatePicker.layer.masksToBounds = true
        durationDatePicker.backgroundColor = UIColor.white
        startButton.layer.cornerRadius = 12
    }
    
    @IBAction func unwindWithSegueToNewTimerViewController(_ segue: UIStoryboardSegue) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {return}
        
        switch identifier {
        case "startCountdown":
            let destination = segue.destination as! CountdownViewController
            destination.duration = durationDatePicker.countDownDuration
        default:
            print("unexpected segue in NewTimerViewController")
        }
    }

}
