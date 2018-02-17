//
//  ViewController.swift
//  ansh_SystemTask
//
//  Created by Pavankumar G on 17/02/18.
//  Copyright © 2018 Pavankumar G. All rights reserved.
//
class SingletonClass {
    let pathss = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    
    
    func saveAndUpdateValuesInPlist(_ inputValues:(name: String, mobileNumber: String,favouriteStatus: Bool, savOrUpdateStatus: Bool, indexNumber: Int), completion:()) -> Bool {
        var val : NSDictionary = [:]

       
        let documentsDirectorys: AnyObject = pathss[0] as AnyObject
        let dataPaths  =
            String(documentsDirectorys.appendingPathComponent("EmployeeDetails.plist"))
        
        let fileManager = FileManager.default
        if (!(fileManager.fileExists(atPath: dataPaths)))
        {

        }
        
        
        val=["Name":inputValues.name,"mobileNumber":inputValues.mobileNumber,"favouriteStatus":inputValues.favouriteStatus]
        var tempArr : NSMutableArray = []
        var saveDict : NSMutableDictionary = [:]
        if let tempDict = NSDictionary(contentsOfFile: dataPaths) {
            saveDict = tempDict as! NSMutableDictionary

            let finalArr : NSMutableArray = []

            tempArr.removeAllObjects()
            tempArr = saveDict.value(forKey: "Employee Details")! as! NSMutableArray
            if inputValues.savOrUpdateStatus {
                for i in 0..<tempArr.count {
                    if (inputValues.indexNumber == i){
                        finalArr.add(val)

                    }else{
                        finalArr.add(tempArr[i])

                    }

                    
                }
            }else{

                for i in 0..<tempArr.count {
                    
                    finalArr.add(tempArr[i])
                    
                }
                finalArr.add(val)

            }

            

            
            saveDict.removeAllObjects()
            saveDict.setValue(finalArr, forKey: "Employee Details")
            saveDict.write(toFile: dataPaths, atomically: true)
            
            return true
        }else {
            tempArr.add(val)
            saveDict.setValue(tempArr, forKey: "Employee Details")

            saveDict.write(toFile: dataPaths, atomically: true)
            
            return true
            
        }
        
    }
    func retriveValuesInPlist(completion:()) -> NSMutableArray?  {
        let documentsDirectorys: AnyObject = pathss[0] as AnyObject
        let dataPaths  =
            String(documentsDirectorys.appendingPathComponent("EmployeeDetails.plist"))
        guard NSDictionary(contentsOfFile: dataPaths) != nil else {
            return nil
        }
        let tempValues = NSDictionary(contentsOfFile: dataPaths)!
        var saveArr : NSMutableArray = []

        saveArr = tempValues.value(forKey: "Employee Details")! as! NSMutableArray
        

        return saveArr
    }
    
        
}

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var allBtnProperty: UIButton!
    @IBOutlet weak var favouritesBtnProperty: UIButton!
    @IBOutlet weak var tableViewObj: UITableView!
    
    var finalArrayValues : NSMutableArray = []
    // MARK: - View Controller method

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        

        

        

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        self.getAllEmployDetails()
        
    }
    
    //MARK: - getAllEmployDetails
    
    func getAllEmployDetails()  {
        let singletonObj = SingletonClass()

        if  let emploValues = singletonObj.retriveValuesInPlist(completion: {
        }())
        {
            self.finalArrayValues = emploValues
            DispatchQueue.main.async {
                self.tableViewObj.reloadData()
            }
        }else {
            print("Nil")
        }
    }
    //MARK: - filter favourite employees
    
    func filterEmployDetails()  {
        var tempStore : NSArray  = []
            tempStore = self.finalArrayValues
        
        self.finalArrayValues = []
        
        for i in 0..<tempStore.count{
            let dict : NSMutableDictionary = tempStore[i] as! NSMutableDictionary
            var myBool: Bool!
            myBool = (dict.value(forKey:"favouriteStatus") as AnyObject).boolValue
            if myBool
           {
            
                self.finalArrayValues.add(dict)

            }
            
            

        }
        
            DispatchQueue.main.async {
                self.tableViewObj.reloadData()
            
    }
    }
    
    //MARK: - select All And  Favourites Button Actions

    @IBAction func selectAllAndFavouritesButtonActions(_ sender: UIButton) {
        var senderBtn: UIButton!
        if(sender.tag == 1) {
            senderBtn = self.allBtnProperty
            self.getAllEmployDetails()

        }
        else if(sender.tag == 2) {
            self.filterEmployDetails()

            senderBtn = self.favouritesBtnProperty
        }
        unSelectedButton(btn: self.allBtnProperty)
        unSelectedButton(btn: self.favouritesBtnProperty)
        
        
        selectedButton(btn: senderBtn)
    }
    
    //MARK: - Custom Methods
    
    private func selectedButton(btn: UIButton)
    {
        
        btn.backgroundColor = UIColor.init(red: 110/255, green: 72/255, blue: 130/255, alpha: 1.0)
        btn.titleLabel?.textColor = UIColor.white
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    private func unSelectedButton(btn: UIButton)
    {
        
        btn.backgroundColor = UIColor.white
        btn.titleLabel?.textColor = UIColor.black

    }
    // MARK: - Memory Warning method

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableView Dlegate & Data Source methods

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.finalArrayValues.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellReuseIdentifier="CustomTableViewCell"
        let cell:CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! CustomTableViewCell
        let tempDictValues : NSDictionary = self.finalArrayValues[indexPath.row] as! NSDictionary
        
        cell.nameLable?.text = tempDictValues.value(forKey: "Name") as? String
        cell.phoneNumberLabel?.text = tempDictValues.value(forKey: "mobileNumber") as? String
        cell.favouriteIndivateBtn.addTarget(self, action: #selector(favouriteStatusChanging), for: .touchUpInside)
        cell.favouriteIndivateBtn.tag = indexPath.row
        var myBool: Bool!
        myBool = (tempDictValues.value(forKey:"favouriteStatus") as AnyObject).boolValue
        if myBool
        {
            cell.favouriteIndivateBtn.setImage(UIImage.init(named: "favourites"), for: .selected)

            cell.favouriteIndivateBtn.isSelected = true
            
        }
        else
        {
            cell.favouriteIndivateBtn.setImage(UIImage.init(named: "unSelected"), for: .selected)

            cell.favouriteIndivateBtn.isSelected = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let tempDictValues : NSDictionary = self.finalArrayValues[indexPath.row] as! NSDictionary
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmployeeFormViewController") as! EmployeeFormViewController
        vc.name = tempDictValues.value(forKey: "Name") as? String
        vc.mobileNumber = tempDictValues.value(forKey: "mobileNumber") as? String
        vc.favouritStatus = tempDictValues.value(forKey: "favouriteStatus") as! Bool 

        vc.saveOrUpdateNumber = true
        vc.indexNumber = indexPath.row

        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - rightBar Button Action

    @objc func favouriteStatusChanging(sender: UIButton)
    {
        var senderBtn: UIButton!
   senderBtn = sender
        let boolValue = true
        var favouritStatus = true
        
        if sender.isSelected == true{
            
            favouritStatus = false

                sender.setImage(UIImage.init(named: "unSelected"), for: .selected)
            
            senderBtn.isSelected = false

        }else{
             favouritStatus = true
            
            sender.setImage(UIImage.init(named: "favourites"), for: .selected)
            senderBtn.isSelected = true

        }
        let singletonObj = SingletonClass()
        
        
        let tempDictValues : NSDictionary = self.finalArrayValues[senderBtn.tag] as! NSDictionary
        let boolReturn = singletonObj.saveAndUpdateValuesInPlist(((tempDictValues.value(forKey: "Name") as? String)!,(tempDictValues.value(forKey: "mobileNumber") as? String)!,favouritStatus,boolValue,senderBtn.tag ), completion: {
            
        }())
        
        if boolReturn {
        }else{
        }
        
        
        
    }
    // MARK: - rightBar Button Action

    
    @IBAction func addNewRecordAction(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmployeeFormViewController") as! EmployeeFormViewController
        vc.saveOrUpdateNumber = false
        vc.indexNumber = 0
        vc.favouritStatus = false
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

