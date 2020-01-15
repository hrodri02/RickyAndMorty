//
//  Date+Ext.swift
//  RickAndMorty
//
//  Created by Eri on 1/14/20.
//  Copyright © 2020 Eri. All rights reserved.
//

import UIKit

extension Date {
    func getHourMinSecStr() -> String {
        let date = self
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        let minStr = (minutes < 10) ? "0\(minutes)" : "\(minutes)"
        let secStr = (seconds < 10) ? "0\(seconds)" : "\(seconds)"
        
        return "\(hour):\(minStr):\(secStr)"
    }
    
    func getDateAsString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateStr = dateFormatter.string(from: self)
        return dateStr
    }
}
