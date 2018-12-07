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
    
    var availab = "available"

    var hellosistahh = ViewController();
    
    var intNamesTwo: [String] = []
    
    var dateBaseArray = [AvDateBase]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        // ****************************************************
        // fá daginn í dag
      //  let dateidag = Date()
        
      
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        let idag = formatter.string(from: nextDayTime)
        let daguridag = idag.prefix(10)
        
        let dagur = daguridag.prefix(5)
        navBar.title = "\(dagur)"
        
        
        // print("bara dagur í dag", type(of: daguridag))
        
        // ****************************************************
        
        timePicker = UIDatePicker()
        timePicker?.datePickerMode = .time
        timePicker?.locale = NSLocale(localeIdentifier: "da_DK") as Locale
        timePicker?.minuteInterval = 30
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        timePicker?.date = dateFormatter.date(from: "08:00")!
        pickedTime  = ((timePicker?.date)!)
    
        fetchUser()
    }
    
    
    func fetchUser(){
        Database.database().reference().child("Room 1").observe(.childAdded, with: { (snapshot) in
            self.intNamesTwo.append(snapshot.key)
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
        }, withCancel: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
     }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        
        cell.detailTextLabel?.text! = "available"
        
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
        //print("dagur og tími")
        for i in 0...31{
            dagklukk.append(daguridag + " " + strTime[i])
        }
        
        for i in 0...31{
            let dateForm = DateFormatter()
            dateForm.dateFormat = "dd/MM/yyyy HH:mm"
            let date = dateForm.date(from: dagklukk[i])
            dagLok.append(date!.addingTimeInterval(3600))
        }
        
        //print("ÞETTA ER ORÐIÐ AÐ DOUBLE")
        var dagsetning = Double()
        for i in 0...31{
            dagsetning = dagLok[i].timeIntervalSince1970
            dateInt.append(dagsetning)
        }
    
        if(today == Anyday){
            if (strTime[indexPath.row] < timiIDag) {
                colorPicker.append(colorDates(dateTime: strTime[indexPath.row], uiColor: UIColor.lightGray))
            }
            else {
               if intNamesTwo.contains(String(format: "%.0f", self.dateInt[indexPath.row])){
                    self.colorPicker.append(colorDates(dateTime: self.strTime[indexPath.row], uiColor: UIColor.red))
                }
               else {
                    self.colorPicker.append(colorDates(dateTime: self.strTime[indexPath.row], uiColor: UIColor.green))
                }
            }
        } else {
            if intNamesTwo.contains(String(format: "%.0f", self.dateInt[indexPath.row])){
                self.colorPicker.append(colorDates(dateTime: self.strTime[indexPath.row], uiColor: UIColor.red))
            }
            else {
                
                self.colorPicker.append(colorDates(dateTime: self.strTime[indexPath.row], uiColor: UIColor.green))
            }
        }
        
        cell.textLabel?.text = colorPicker[indexPath.row].dateTime
        cell.backgroundColor = colorPicker[indexPath.row].uiColor
        return cell
     }
    
    @IBAction func nextDay(_ sender: UIBarButtonItem) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        nextDayTime  = nextDayTime.addingTimeInterval(86400)
        let idag = formatter.string(from: nextDayTime)
        let daguridag = idag.prefix(10)
        let dagur = daguridag.prefix(5)
        navBar.title = "\(dagur)"
        colorPicker.removeAll()
        tableView.reloadData()
        tableTable.reloadData()
    }
    

    @IBAction func LastDay(_ sender: UIBarButtonItem) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        if(nextDayTime <= todayTime){
            let idag = formatter.string(from: todayTime)
            let daguridag = idag.prefix(10)
            let dagur = daguridag.prefix(5)
            navBar.title = "\(dagur)"
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
            colorPicker.removeAll()
            tableView.reloadData()
            tableTable.reloadData()
        }
    }
    
    /*if (self.strTime[indexPath.row] > timiIDag) {
     Database.database().reference(withPath: "Room 1").child(String(format: "%.0f", self.dateInt[indexPath.row])).observeSingleEvent(of: .value, with: { (snapshot) in
     if snapshot.exists() {
     print(self.strTime[indexPath.row])
     print("loob not kkkkk")
     self.availab = "booked"
     } else {
     print("loop avail bit")
     print(self.strTime[indexPath.row])
     }})
     
     }*/
}
