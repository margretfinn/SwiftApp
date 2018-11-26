//
//  ViewController.swift
//  bookroom
//
//  Created by Margrét Finnbogadóttir on 22/11/2018.
//  Copyright © 2018 Margrét Finnbogadóttir. All rights reserved.
//


import UIKit
import CoreData

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate  {
    
    @IBOutlet weak var txtRoom: UITextField!
    
    @IBOutlet weak var Calendar: UICollectionView!
    
    @IBOutlet weak var MonthLabel: UILabel!
    
    @IBOutlet weak var txtUsername: UITextField!
    
    @IBOutlet weak var txtDate: UITextField!
    
    @IBOutlet weak var txtFromDate: UITextField!
    
    private var datePicker: UIDatePicker?
    private var fromDatePicker: UIDatePicker?
    
    let Months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    
    let DaysOfMonth = ["Monday","Thuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    
    var DaysInMonths = [31,28,31,30,31,30,31,31,30,31,30,31]
    
    var currentMonth = String()
    
    var NumberOfEmptyBox = Int()    //empthy boxes at the start of the month
    
    var NextNumberOfEmptyBox = Int() //empty boxes for the next month
    
    var PreviousNumberOfEmptyBox = 0 //empthy boxes for the prev month
    
    var Direction = 0   //0 if we are at the current month, -1 future month, 1 prev month
    
    var PositionIndex = 0   //empty boxes
    
    var LeapYearCounter = 2
    
    var dayCounter = 0
    
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
    
    let roomTypes = ["Room 2", "Room 3"]
    
    func createPickerView(){
        let pickerView = UIPickerView()
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
        
        createPickerView()
        dismissPickerView()
        
        currentMonth = Months[month]
        MonthLabel.text = "\(currentMonth) \(year)"
        if weekday == 0 {
            weekday = 7
        }
        GetStartDateDayPosition()
        
        datePicker = UIDatePicker()
        fromDatePicker = UIDatePicker()
        datePicker?.datePickerMode = .dateAndTime
        fromDatePicker?.datePickerMode = .dateAndTime
        datePicker?.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        fromDatePicker?.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        datePicker?.minimumDate = NSDate(timeIntervalSinceNow: 0) as Date
        fromDatePicker?.minimumDate = NSDate(timeIntervalSinceNow: 0) as Date
        datePicker?.addTarget(self, action: #selector(ViewController.dateChanged(datePicker:)), for: .valueChanged)
        fromDatePicker?.addTarget(self, action: #selector(ViewController.fromDateChanged(fromDatePicker:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        txtDate.inputView = datePicker
        txtFromDate.inputView = fromDatePicker
        
    }
    
    @objc func viewTapped(gestureRecognizer:UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        txtDate.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    @objc func fromDateChanged(fromDatePicker:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        txtFromDate.text = dateFormatter.string(from: fromDatePicker.date)
        view.endEditing(true)
    }
    
    @IBAction func btnBook () {
        
        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context = appDel.persistentContainer.viewContext
        
        //LOADING
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        
        //SAVING
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
        newUser.setValue("" + txtUsername.text!, forKey: "username")
        newUser.setValue("" + txtRoom.text!, forKey: "room")
        newUser.setValue("" + txtDate.text!, forKey: "datetime")
        newUser.setValue("" + txtFromDate.text!, forKey: "fromdatetime")
 
        
        do{
            //LOADING
            let results = try context.fetch(request)
            if results.count > 0 {
                for i in results as! [NSManagedObject]{
                    print(i)
                }
            }
            //SAVING
            try context.save()
            print(newUser)
            print("Object Saved.")
        }
        catch {
            //PROCESSING ERROR
        }
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
            Calendar.reloadData()
            
        default:
            Direction = 1
            
            GetStartDateDayPosition()
            
            month += 1
            
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            Calendar.reloadData()
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
            Calendar.reloadData()
            
        default:
            month -= 1
            Direction = -1
            
            GetStartDateDayPosition()
            
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            Calendar.reloadData()
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
    
    //Returns the numbers of days in the month + the number of empthy boxes
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calendar", for: indexPath) as! DateCollectionViewCell
        
        cell.backgroundColor = UIColor.cyan
        
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
        
        if currentMonth == Months[calendar.component(.month, from: date) - 1] && year == calendar.component(.year, from: date) && indexPath.row + 1 - NumberOfEmptyBox == day{
            cell.backgroundColor = UIColor.red
            // cell.Circle.isHidden = false
            //cell.DrawCircle()
        }
        
        return cell
    }

}

