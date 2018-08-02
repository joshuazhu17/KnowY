//
//  FirstTutorialLastPageViewController.swift
//  KnowY
//
//  Created by Joshua Zhu on 8/2/18.
//  Copyright © 2018 joshuazhu. All rights reserved.
//

import UIKit

class FirstTutorialLastPageViewController: UIViewController {

    @IBOutlet weak var doneButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func doneButtonTouched(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: Constants.UserDefaults.isNotNewUser)
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
