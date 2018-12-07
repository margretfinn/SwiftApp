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
    
    var changeCol: [Double] = []
 
    var colorPicker: [(colorDates)] = []
    
//    var co = 0
    
    var availab = "available"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        // ****************************************************
        // fá daginn í dag
      //  let dateidag = Date()
        
        // print("dagurinn í dag", dateidag)
      
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
 
        // 08:00-23:30 as date
        for _ in 0...31{
            times.append(pickedTime)
            pickedTime = pickedTime + 1800
        }
        
//        for _ in 0...31{
//            changeCol.append(false)
//        }
  
      //  txtDate.text = dateFormatter.string(from: datePicker.date)
        
    }
    
    /*private func loadData(array: [Double]) {
        for i in 0...31 {
            Database.database().reference(withPath: "Room 3").child(String(format: "%.0f", dateInt[i])).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    self.goodTimes.append(self.strTime[i])
                    print("loob not ")
                }
            })
        }
        
    }*/

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     // #warning Incomplete implementation, return the number of rows
        //let len = (24-8)*2
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
        let daguridag = today.prefix(10)
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
        
//        for i in 0...31 {
//            if (strTime[i] > timiIDag) {
//                Database.database().reference(withPath: "Room 1").child(String(format: "%.0f", dateInt[indexPath.row])).observeSingleEvent(of: .value, with: { (snapshot) in
//                    if snapshot.exists() {
//                        print(self.strTime[i])
//                        print("loob not ")
//                        self.availab = "booked"
//                    } else {
//                        print("loop avail bit")
//                        print(self.strTime[i])
//                    }})
//            }
//        }
        
        if (strTime[indexPath.row] > timiIDag) {
            Database.database().reference(withPath: "Room 1").child(String(format: "%.0f", dateInt[indexPath.row])).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    print(self.strTime[indexPath.row])
                    print("loob not kkkkk")
                    self.availab = "booked"
                    self.changeCol.append(dagsetning)
                    self.colorPicker.append(colorDates(dateTime: self.strTime[indexPath.row], uiColor: UIColor.red))
                    //                    print("HALLÓÓÓ ELLEN HORFA HEEEEEEEEER", self.changeCol[indexPath.row], self.strTime[indexPath.row], indexPath.row)
                } else {
                    print("loop avail bit")
                    print(self.strTime[indexPath.row])
                    self.colorPicker.append(colorDates(dateTime: self.strTime[indexPath.row], uiColor: UIColor.green))
                }})

        }
        
//        if(today == Anyday){
//            for i in 0...31 {
//                if (strTime[i] < timiIDag) {
//                    colorPicker.append(colorDates(dateTime: strTime[i], uiColor: UIColor.lightGray, avail: availab))
//                } else if cell.detailTextLabel?.text! != nil && cell.detailTextLabel!.text! == "booked"{
//                    print("hæææ bitch þú er heimsk")
//                    colorPicker.append(colorDates(dateTime: strTime[i], uiColor: UIColor.red, avail: availab))
//                }
//                else {
//                    self.colorPicker.append(colorDates(dateTime: self.strTime[i], uiColor: UIColor.green, avail: availab))
//                }
//            }
//        }
//        else {
//            for i in 0...31 {
//                colorPicker.append(colorDates(dateTime: strTime[i], uiColor: UIColor.green, avail: availab))
//            }
//        }
        
        print("dagsetning", dagsetning)
        if changeCol.contains(dagsetning){
            print("HAAAAALELÚJA")
        }

        if(today == Anyday){
            if (strTime[indexPath.row] < timiIDag) {
                colorPicker.append(colorDates(dateTime: strTime[indexPath.row], uiColor: UIColor.lightGray))
            }
            else {
                if changeCol.contains(dagsetning){
                    self.colorPicker.append(colorDates(dateTime: self.strTime[indexPath.row], uiColor: UIColor.red))
                } else {
                    self.colorPicker.append(colorDates(dateTime: self.strTime[indexPath.row], uiColor: UIColor.green))
                }
            }
        }
        else {
            colorPicker.append(colorDates(dateTime: strTime[indexPath.row], uiColor: UIColor.green))
        }
        
        cell.textLabel?.text = colorPicker[indexPath.row].dateTime
        cell.backgroundColor = colorPicker[indexPath.row].uiColor
//        cell.detailTextLabel?.text = colorPicker[indexPath.row].avail
        return cell
     }
    
    @IBAction func nextDay(_ sender: UIBarButtonItem) {
        // fá daginn í dag
        // print("dagurinn í dag", dateidag)
        
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
    
    
    
    
    
    // MARK: - Table view data source

   /* override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 10
    }*/
    /*override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let len = (24-8)*2
        return len
    }*/

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation
w
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
