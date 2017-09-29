# FloatingTextField
A beautiful and flexible text field control implementation of "Float Label Pattern". Written in Swift.

To add into your project drag and drop the 'Source' folder into your project.
if you wants to add validation with propmt error meessage then you can do like-

        // bottom line color when textfield is active
        textField.activeLineColor = UIColor.init(colorLiteralRed: 0, green: 183.0/255.0, blue: 183.0/255.0, alpha: 1.0)
        // bottom line color when textfield filled (did end editing and has text)
        textField.filledTextFieldLineColor = .darkGray
        
  
        // set validation rules with message (for more validation check ValidationRule file in Source folder)
        textField.validationRules = [ValidationRule.required(message: "Email is required"),
                                        ValidationRule.email(message: "Please enter a valid email.")]
                                        
        // implement the action 
        @IBAction func doneTapped(_ sender: UIButton){
        do {
               try textField.validate()
            
        }catch(let error){
            let textf = error._userInfo?["textField"] as? FloatingTextField
            textf?.showError(message: error.localizedDescription)
        }
    }
