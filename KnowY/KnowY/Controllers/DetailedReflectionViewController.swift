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
    @IBOutlet weak var detailsTextView: UITextView!
    
    @IBAction func unwindWithSegueToDetailedReflectionViewController(_ segue: UIStoryboardSegue) {
        if segue.source is EditReflectionViewController {
            guard let vc = segue.source as? EditReflectionViewController else {return}
            self.reflection = vc.reflection
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let reflection = reflection else {return}
        
        successLabel.layer.cornerRadius = 12
        successLabel.layer.masksToBounds = true
        detailsTextView.text = reflection.details ?? ""
        detailsTextView.isEditable = false
        detailsTextView.isSelectable = false
        detailsTextView.layer.cornerRadius = 12
        
        if reflection.success {
            successLabel.text = "You succeeded! Keep it up!"
            successLabel.backgroundColor = UIColor(red: 241.0/255.0, green: 146.0/255.0, blue: 0.0/255.0, alpha: 1)
        }
        else {
            successLabel.text = "Hm, not quite... Perhaps you should reconsider your motivations"
            successLabel.backgroundColor = UIColor(displayP3Red: 27.0/255.0, green: 102.0/255.0, blue: 141.0/255.0, alpha: 1)
        }
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
