//
//  ViewController.swift
//  FloatingtextField
//
//  Created by Bharat Lal on 20/09/17.
//  Copyright © 2017 Bharat Lal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: FloatingTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        textField.activeLineColor = UIColor.init(colorLiteralRed: 0, green: 183.0/255.0, blue: 183.0/255.0, alpha: 1.0)
        textField.filledTextFieldLineColor = .darkGray
        textField.delegate = self
        textField.validationRules = [ValidationRule.required(message: "Email is required"),
                                        ValidationRule.password(message: "Please enter a valid password.")]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneTapped(_ sender: UIButton){
        do {
               try textField.validate()
            
        }catch(let error){
            let textf = error._userInfo?["textField"] as? FloatingTextField
            textf?.showError(message: error.localizedDescription)
        }
    }

}

extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

