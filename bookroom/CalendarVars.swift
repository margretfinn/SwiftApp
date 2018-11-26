//
//  CalendarVars.swift
//  bookroom
//
//  Created by Margrét Finnbogadóttir on 22/11/2018.
//  Copyright © 2018 Margrét Finnbogadóttir. All rights reserved.
//

import Foundation

let date = Date()
let calendar = Calendar.current


let day = calendar.component(.day, from: date)
var weekday = calendar.component(.weekday, from: date) - 1
var month = calendar.component(.month, from: date) - 1
var year = calendar.component(.year, from: date)
