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
    
    let cellId = "cellID"
    
    private var timePicker: UIDatePicker?
    
    var pickedTime = Date()
    
    var times: [Date] = []
    
    var stringTimes: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        /*let date = Date()
        let cal = Calendar.current
        
      //  let timeComp = cal.dateComponents([.hour:.minute], from: Date())
        
        let hour = cal.component(.hour, from: date )
        let minutes = cal.component(.minute, from: date)
        print("hours = \(hour):\(minutes)")*/
        
        timePicker = UIDatePicker()
        timePicker?.datePickerMode = .time
        timePicker?.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        timePicker?.minuteInterval = 30
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "HH:mm"
        timePicker?.date = dateFormatter.date(from: "08:00")!
        pickedTime  = ((timePicker?.date)!)
       
    
        for _ in 0...32{
            times.append(pickedTime)
            pickedTime = pickedTime + 1800
        }
        
        
        /*let cal = Calendar.current
         let hour = cal.component(.hour, from: pickedTime)
         let minutes = cal.component(.minute, from: pickedTime)
         print("Hours:")
         print(type(of: hour))
         print(minutes + 30)*/
      //  txtDate.text = dateFormatter.string(from: datePicker.date)
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     // #warning Incomplete implementation, return the number of rows
        //let len = (24-8)*2
        return times.count
     }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        
        //let times = self.times[indexPath.row]
        
        for i in 0...32{
            print(times[i])
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            stringTimes.append(dateFormatter.string(from: times[i]))
        }
        
        let nameTime = self.stringTimes[indexPath.row]
        
        cell.backgroundColor = UIColor.brown
        
        cell.textLabel?.text = nameTime
        
     // Configure the cell...
        return cell
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
