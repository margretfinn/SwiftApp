//
//  TableViewController.swift
//  bookroom
//
//  Created by Ellen Sigurðardóttir on 29/11/2018.
//  Copyright © 2018 Margrét Finnbogadóttir. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TableViewController: UITableViewController {
    
    @IBOutlet weak var tableTable: UITableView!
    
    let cellId = "cellID"
        
    @IBOutlet weak var navBar: UINavigationItem!
    
    private var timePicker: UIDatePicker?
    
    private var todayPicker: UIDatePicker?
    
    var pickedTime = Date()
    var nextDayTime = Date()
    var todayTime = Date()
    
    var times: [Date] = []
    
    var goodTimes: [String] = []
    
    var strTime: [String] = []
    
    var dagklukk: [String] = []
    
    var dagLok: [Date] = []
    
    var dateInt: [Double] = []
    var array: [Double] = []
    
    var changeCol: [String] = []
 
    var colorPicker: [(colorDates)] = []

    var intNamesTwo: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        //Prints out the days availability
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        let idag = formatter.string(from: nextDayTime)
        let daguridag = idag.prefix(10)
        
        let dagur = daguridag.prefix(5)
        navBar.title = "\(dagur)"
        
        //Making a timer from 08:00 to 23:30
        timePicker = UIDatePicker()
        timePicker?.datePickerMode = .time
        timePicker?.locale = NSLocale(localeIdentifier: "da_DK") as Locale
        timePicker?.minuteInterval = 30
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        timePicker?.date = dateFormatter.date(from: "08:00")!
        pickedTime  = ((timePicker?.date)!)
        
        // 08:00-23:30 as date
        for _ in 0...31{
            times.append(pickedTime)
            pickedTime = pickedTime + 1800
        }
    
        //Fetching the database for all the unavalabilities
        fetchUser()
    }
    
    
    func fetchUser(){
        Database.database().reference().child("Room 1").observe(.childAdded, with: { (snapshot) in
            self.intNamesTwo.append(snapshot.key)
        }, withCancel: nil)
    }
    
    //Return the how many rows should return
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
     }
    
    //Making the cell
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        
        //Making todays date and the table date
        let toDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        let today = formatter.string(from: toDate)
        let Anyday = formatter.string(from: nextDayTime)
        let daguridag = Anyday.prefix(10)
        let timiIDag = today.suffix(5)
       
        // 08:00-23:30 as string
        for i in 0...31{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            strTime.append(dateFormatter.string(from: times[i]))
        }
        
        // todays date plus 08:00-23:30 as string
        for i in 0...31{
            dagklukk.append(daguridag + " " + strTime[i])
        }
        
        //Making string to date and adding one hour
        for i in 0...31{
            let dateForm = DateFormatter()
            dateForm.dateFormat = "dd/MM/yyyy HH:mm"
            let date = dateForm.date(from: dagklukk[i])
            dagLok.append(date!.addingTimeInterval(3600))
        }
        
        //Making string to double
        var dagsetning = Double()
        for i in 0...31{
            dagsetning = dagLok[i].timeIntervalSince1970
            dateInt.append(dagsetning)
        }
      
        //Check if we are working with the todays day
        if(today.prefix(10) == daguridag){
            //Checks what time it is today marks grey if the time has passed
            if (strTime[indexPath.row] < timiIDag) {
                colorPicker.append(colorDates(dateTime: strTime[indexPath.row], uiColor: UIColor.lightGray))
            }
            else {
                //Checks for availability red for unavailble and green for available
               if intNamesTwo.contains(String(format: "%.0f", self.dateInt[indexPath.row])){
                    self.colorPicker.append(colorDates(dateTime: self.strTime[indexPath.row], uiColor: UIColor.red))
                }
               else {
                    self.colorPicker.append(colorDates(dateTime: self.strTime[indexPath.row], uiColor: UIColor.green))
                }
            }
        }else {
            if intNamesTwo.contains(String(format: "%.0f", self.dateInt[indexPath.row])){
                self.colorPicker.append(colorDates(dateTime: self.strTime[indexPath.row], uiColor: UIColor.red))
            }
            else {
                
                self.colorPicker.append(colorDates(dateTime: self.strTime[indexPath.row], uiColor: UIColor.green))
            }
        }
        
        //Reads from the colopicker and marks each cell right color and time
        cell.textLabel?.text = colorPicker[indexPath.row].dateTime
        cell.backgroundColor = colorPicker[indexPath.row].uiColor
        return cell
     }
    
    @IBAction func nextDay(_ sender: UIBarButtonItem) {
        //Adding a dag
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        nextDayTime  = nextDayTime.addingTimeInterval(86400)
        let idag = formatter.string(from: nextDayTime)
        let daguridag = idag.prefix(10)
        let dagur = daguridag.prefix(5)
        navBar.title = "\(dagur)"
        //Clean all arrays to make room for the new date
        dagklukk.removeAll()
        dagLok.removeAll()
        dateInt.removeAll()
        colorPicker.removeAll()
        tableView.reloadData()
        tableTable.reloadData()
    }
    
    @IBAction func LastDay(_ sender: UIBarButtonItem) {
        //Going back day
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        //Not availble to go back in time only the date today
        if(nextDayTime <= todayTime){
            let idag = formatter.string(from: todayTime)
            let daguridag = idag.prefix(10)
            let dagur = daguridag.prefix(5)
            navBar.title = "\(dagur)"
            //Clean all arrays to make room for the new date
            dagklukk.removeAll()
            dagLok.removeAll()
            dateInt.removeAll()
            colorPicker.removeAll()
            tableView.reloadData()
            tableTable.reloadData()
        }
        else {
            nextDayTime = nextDayTime.addingTimeInterval(-86400)
            let idag = formatter.string(from: nextDayTime)
            let daguridag = idag.prefix(10)
            let dagur = daguridag.prefix(5)
            navBar.title = "\(dagur)"
            //Clean all arrays to make room for the new date
            dagklukk.removeAll()
            dagLok.removeAll()
            dateInt.removeAll()
            colorPicker.removeAll()
            tableView.reloadData()
            tableTable.reloadData()
        }
    }

}
