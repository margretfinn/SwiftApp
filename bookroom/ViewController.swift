//
//  ViewController.swift
//  bookroom
//
//  Created by Margrét Finnbogadóttir on 22/11/2018.
//  Copyright © 2018 Margrét Finnbogadóttir. All rights reserved.
//


import UIKit
import CoreData
import FirebaseDatabase
import Foundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate  {
  
    
    @IBOutlet weak var txtRoom: UITextField!
    
    @IBOutlet weak var calend: UICollectionView!
    
    @IBOutlet weak var MonthLabel: UILabel!
    
    @IBOutlet weak var txtUsername: UITextField!
    
    @IBOutlet weak var txtDate: UITextField!
    
    @IBOutlet weak var hours: UILabel!
    
    @IBAction func stepperhours(_ sender: UIStepper) {
        hours.text = String(sender.value)
    }
    
    @IBOutlet weak var notavail: UILabel!
    
    private var datePicker: UIDatePicker?
    private var timePicker: UIDatePicker?
    private var todayPicker: UIDatePicker?
    
    
    let Months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    
    let DaysOfMonth = ["Monday","Thuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    
    var DaysInMonths = [31,28,31,30,31,30,31,31,30,31,30,31]
    
    var currentMonth = String()
    
    var NumberOfEmptyBox = Int()    //empty boxes at the start of the month
    
    var NextNumberOfEmptyBox = Int() //empty boxes for the next month
    
    var PreviousNumberOfEmptyBox = 0 //empthy boxes for the prev month
    
    var Direction = 0   //0 if we are at the current month, -1 future month, 1 prev month
    
    var PositionIndex = 0   //empty boxes
    
    var LeapYearCounter = 2
    
    var dayCounter = 0
    
    var pickedDate = Date()
    
    var avaToday: [String] = []

    //var dateBaseArray = [AvDateBase]()
    
    var bookedDatesInt: [(datesInt)] = []
    
    var intNames: [String] = []
    
    let pickerView = UIPickerView()
    
    var cantbook = false
    
    var AvaCounter = 0
    
    /**************************************PICKER VIEW*************************************/
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return roomTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return roomTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtRoom.text = roomTypes[row]
    }
    
    let roomTypes = ["Room 1"]
    
    func createPickerView(){
//        let pickerView = UIPickerView()
        pickerView.delegate = self
    
        
        txtRoom.inputView = pickerView
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title:"Done", style: .plain, target: self, action:#selector(self.dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        txtRoom.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard () {
        view.endEditing(true)
    }
    /**************************************PICKER VIEW*************************************/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //fetchUser()
      
        //        let ref = Database.database().reference()
        
        //        ref.child("booker/username").setValue("hallo")
        
        createPickerView()
        dismissPickerView()
        
        // should make the first row in the pickerview be default
        pickerView.selectRow(1, inComponent: 0, animated: true)
        
        currentMonth = Months[month]
        MonthLabel.text = "\(currentMonth) \(year)"
        if weekday == 0 {
            weekday = 7
        }
        GetStartDateDayPosition()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .dateAndTime
        datePicker?.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        datePicker?.minuteInterval = 30
        datePicker?.minimumDate = NSDate(timeIntervalSinceNow: 0) as Date
        datePicker?.maximumDate = NSDate(timeIntervalSinceNow: 1209600) as Date
        datePicker?.addTarget(self, action: #selector(ViewController.dateChanged(datePicker:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.viewTapped(gestureRecognizer:)))
        
        txtDate.inputView = datePicker
        view.addGestureRecognizer(tapGesture)
        
        notavail.isHidden = true
        
        fetchUser()
        
        print(AvaCounter)
        print(intNames.count)

    }

    
    func fetchUser( ) {
       Database.database().reference().child("Room 1").observe(.childAdded, with: { (snapshot) in
            /*if let dictonary = snapshot.value as? [String: AnyObject] {
                let user = AvDateBase()
                user.userNameBase = dictonary["username"] as? String
                user.availabilityBase = dictonary["available"] as? Bool
                print(user.userNameBase ?? "nil",user.availabilityBase ?? false)
                self.dateBaseArray.append(user)
                DispatchQueue.main.async {
                    self.loadView()*/
            print(snapshot.key)
            self.intNames.append(snapshot.key)
            DispatchQueue.main.async {
                self.AvaCounter = self.intNames.count
            }
        }, withCancel: nil)
    }
    
    
    @objc func viewTapped(gestureRecognizer:UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        pickedDate = datePicker.date
        txtDate.text = dateFormatter.string(from: datePicker.date)
        print("kemur rangt", datePicker.date)
    }
    
    @objc func dismissPicker() {
        
        view.endEditing(true)
        
    }
    
    @IBAction func btnBook () {
        
        
        /*let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
         let context = appDel.persistentContainer.viewContext
         */
        
        // var interval = Double()
        // var date = NSDate()
        
        // date from double:
        // date = NSDate(timeIntervalSince1970: interval)
        
        // double from date:
        // interval = date.timeIntervalSince1970
        
        let inthours = hours.text!
        let inth = (inthours as NSString).integerValue
        
        let bookh = inth * 2
        
        //        let ref = Database.database().reference()
        //        let r2Ref = Database.database().reference(withPath: "Room 2")
        //        let r3Ref = Database.database().reference(withPath: "Room 3")
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        dateFormatter.timeZone = .current
        let bday = dateFormatter.date(from: txtDate.text!)
        var realDay = bday?.addingTimeInterval(3600)
        var realDay2 = realDay
        
        
        var counter = 0
        while counter < bookh {
            print("EFSTcantbook", cantbook)
            
            // date to double
            var dateInt = Double()
            dateInt = realDay!.timeIntervalSince1970
            
            // Add to Firebase
            // ref.childByAutoId().setValue(["date": dateInt, "room": txtRoom.text!, "username": txtUsername.text!, "duration": bookh])
            
            // double to date
            realDay = Date(timeIntervalSince1970: dateInt)
            
            // Database.database().reference(withPath: self.txtRoom.text!) -> path to Room2 or Room3
            Database.database().reference(withPath: self.txtRoom.text!).child(String(format: "%.0f", dateInt)).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    print(self.txtRoom.text! + " is not available at ", realDay!)
                    self.notavail.isHidden = false
                    counter = bookh
                    self.cantbook = true
                    print("cantbook", self.cantbook)
                } else if self.cantbook == false {
                    print(self.cantbook)
                    print("hægt að bókaaa")
                }
            })
            
            // add half an hour
            realDay = realDay?.addingTimeInterval(1800)
            print(realDay!)
            
            counter = counter + 1
            print("counter", counter, "bookh", bookh)
        }
        
        var counter2 = 0
        // Book if the room is available
        
        print("tekka hvort þetta sé cantbook eða ekki", cantbook)
        
        if cantbook == true{
            print("getumekkibókað")
        } else if cantbook == false{
            while counter2 < bookh{
                
                // date to double
                var dateInt = Double()
                dateInt = realDay2!.timeIntervalSince1970

                
                // double to date
                realDay2 = Date(timeIntervalSince1970: dateInt)
                
                // Database.database().reference(withPath: self.txtRoom.text!) -> path to Room2 or Room3
                Database.database().reference(withPath: self.txtRoom.text!).child(String(format: "%.0f", dateInt)).observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.exists() {
                        print(self.txtRoom.text! + " is not available at ", realDay2!)
                        self.notavail.isHidden = false
                        print("bóka ekki", self.cantbook)
                        self.avaToday.append("Bokað")
                    } else if self.cantbook == false{
                        self.notavail.isHidden = true
                        print("bóóóóóóóókaaaaaa biiitch")
                        Database.database().reference(withPath: self.txtRoom.text!).child(String(format: "%.0f", dateInt)).setValue(["available": false, "username": self.txtUsername.text!])
                    }})
//                print(dateInt)
                
                // add half an hour
                realDay2 = realDay2?.addingTimeInterval(1800)
                print("realday inni í seinni", realDay2!)
                
                counter2 = counter2 + 1
            }
        }
        
        counter = 0
        print("**************************************************")
        //        ref.childByAutoId().setValue(["date": txtDate.text!, "room": txtRoom.text!, "username": txtUsername.text!, "duration": bookh])
    }
    
    
    @IBAction func Next(_ sender: Any) {
        switch currentMonth {
        case "December":
            Direction = 1
            
            month = 0
            year += 1
            
            
            GetStartDateDayPosition()
            
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            calend.reloadData()
            
        default:
            Direction = 1
            
            GetStartDateDayPosition()
            
            month += 1
            
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            calend.reloadData()
        }
    }
    
    
    @IBAction func Back(_ sender: Any) {
        switch currentMonth {
        case "January":
            month = 11
            year -= 1
            Direction = -1
            
            GetStartDateDayPosition()
            
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            calend.reloadData()
            
        default:
            month -= 1
            Direction = -1
            
            GetStartDateDayPosition()
            
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            calend.reloadData()
        }
    }
    
    func GetStartDateDayPosition() { //functions gives us the nr of empty boxes
        switch Direction{
        case 0:
            NumberOfEmptyBox = weekday
            dayCounter = day
            while dayCounter > 0 {
                NumberOfEmptyBox = NumberOfEmptyBox - 1
                dayCounter = dayCounter - 1
                if NumberOfEmptyBox == 0 {
                    NumberOfEmptyBox = 7
                }
            }
            if NumberOfEmptyBox == 7 {
                NumberOfEmptyBox = 0
            }
            PositionIndex = NumberOfEmptyBox
        case 1...:
            NextNumberOfEmptyBox = (PositionIndex + DaysInMonths[month])%7
            PositionIndex = NextNumberOfEmptyBox
            
        case -1:
            PreviousNumberOfEmptyBox = (7 - (DaysInMonths[month] - PositionIndex)%7)
            if PreviousNumberOfEmptyBox == 7 {
                PreviousNumberOfEmptyBox = 0
            }
            PositionIndex = PreviousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    // Returns the numbers of days in the month + the number of empthy boxes
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        switch Direction{
        case 0:
            return DaysInMonths[month] + NumberOfEmptyBox
        case 1...:
            return DaysInMonths[month] + NextNumberOfEmptyBox
        case -1:
            return DaysInMonths[month] + PreviousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calend", for: indexPath) as! DateCollectionViewCell
       
        if ((indexPath.row + 1 - NumberOfEmptyBox < day && currentMonth == Months[calender.component(.month, from: date) - 1])){
            cell.backgroundColor = UIColor.lightGray
        }else{
            cell.backgroundColor = UIColor.green
        }
        
        if cell.isHidden{
            cell.isHidden = false
        }
        
        
        //the first cells that needs to be hidden (if needed) will be negative or zero so we can hide them
        switch Direction {
        case 0:
            cell.DateLabel.text = "\(indexPath.row + 1 - NumberOfEmptyBox)"
        case 1:
            cell.DateLabel.text = "\(indexPath.row + 1 - NextNumberOfEmptyBox)"
        case -1:
            cell.DateLabel.text = "\(indexPath.row + 1 - PreviousNumberOfEmptyBox)"
        default:
            fatalError()
        }
        
        //here we hide the negative numbers or zero
        if Int(cell.DateLabel.text!)! < 1{
            cell.isHidden = true
        }
     
        if currentMonth == Months[calender.component(.month, from: date) - 1] && year == calender.component(.year, from: date) && indexPath.row + 1 - NumberOfEmptyBox == day{
            cell.backgroundColor = UIColor.red
            // cell.Circle.isHidden = false
            //cell.DrawCircle()
        }
        
        return cell
    }
    
}

