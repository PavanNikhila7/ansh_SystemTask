//
//  EmployeeFormViewController.swift
//  ansh_SystemTask
//
//  Created by Pavankumar G on 17/02/18.
//  Copyright © 2018 Pavankumar G. All rights reserved.
//

import UIKit

class EmployeeFormViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var fullNameTextFieldObj: UITextField!
    @IBOutlet weak var mobileNumberTextFieldObj: UITextField!
    
    var name : String?
    var mobileNumber : String?
    var favouritStatus : Bool!

    var saveOrUpdateNumber : Bool!
    var indexNumber : Int!

    // MARK: - View Controller method

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.title = "Employee Form"
            if let tempName = self.name, let tempMobileNumber = self.mobileNumber {
                self.fullNameTextFieldObj.text = tempName
                self.mobileNumberTextFieldObj.text = tempMobileNumber

            }
        }

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Memory management method

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - submit Btn Action

    @IBAction func submitBtnAction(_ sender: UIButton) {
        guard  !(self.fullNameTextFieldObj.text?.isEmpty)!, !(self.mobileNumberTextFieldObj.text?.isEmpty)! else {
            return
        }
        if let tempName = self.fullNameTextFieldObj.text, let tempNumber = self.mobileNumberTextFieldObj.text
        {
            self.fullNameTextFieldObj.resignFirstResponder()
            self.mobileNumberTextFieldObj.resignFirstResponder()
            let singletonObj = SingletonClass()
            var boolValue = true
            if self.saveOrUpdateNumber{
                boolValue = true
            }
            else{
                boolValue = false
            }
            let boolReturn = singletonObj.saveAndUpdateValuesInPlist((tempName,tempNumber,favouritStatus,boolValue,indexNumber ), completion: {
                
            }())
            
            if  boolReturn {
                print("Updated favourite status")

                self.navigationController?.popViewController(animated: true)
            }else{
                print("Error in update time")

            }
            

           
        }
        
        
        
        
    }
    
    // MARK: - UITextFieldDelegate methods
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        if(textField == self.fullNameTextFieldObj)
        {
            self.mobileNumberTextFieldObj.becomeFirstResponder()
        }else if(textField == self.mobileNumberTextFieldObj){
            textField.resignFirstResponder()
        }
        return true
        
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        
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
