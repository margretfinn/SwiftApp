//
//  calendVars.swift
//  bookroom
//
//  Created by Margrét Finnbogadóttir on 22/11/2018.
//  Copyright © 2018 Margrét Finnbogadóttir. All rights reserved.
//

import Foundation

let date = Date()
let calender = Calendar.current


let day = calender.component(.day, from: date)
var weekday = calender.component(.weekday, from: date) - 1
var month = calender.component(.month, from: date) - 1
var year = calender.component(.year, from: date)
