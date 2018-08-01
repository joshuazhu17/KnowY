//
//  DetailedReflectionViewController.swift
//  KnowY
//
//  Created by Joshua Zhu on 7/24/18.
//  Copyright © 2018 joshuazhu. All rights reserved.
//

import UIKit

class DetailedReflectionViewController: UIViewController {
    
    var reflection: Reflection?

    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let reflection = reflection else {return}
        
        if reflection.success {
            successLabel.text = "You succeeded! Keep it up!"
        }
        else {
            successLabel.text = "Hm, not quite... Don't let this get you down though!"
        }
        detailsLabel.text = reflection.details ?? ""

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        guard let identifier = segue.identifier else {return}
        
        switch identifier {
        case "editReflection":
            guard let destination = segue.destination as? EditReflectionViewController else {return}
            destination.reflection = reflection
        default:
            print("unidentified segue in detailed reflection view controller")
        }
    }
    

}
