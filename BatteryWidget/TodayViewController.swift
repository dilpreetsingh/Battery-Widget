//
//  TodayViewController.swift
//  BatteryWidget
//
//  Created by Dilpreet Singh on 7/1/17.
//  Copyright © 2017 Dilpreet Singh. All rights reserved.
//

import Cocoa
import NotificationCenter

class TodayViewController: NSViewController, NCWidgetProviding {

    @IBOutlet weak var batteryRemainingTextField: NSTextField!
    
    private let batteryInfo = BatteryInfo()
    
    override var nibName: String? {
        return "TodayViewController"
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        
        let (timeRemaining, charging) = batteryInfo.timeAndPercentageRemaining()
        if let timeRemaining = timeRemaining {
            batteryRemainingTextField.stringValue = "\(timeRemaining) \(charging ? "Until Full" : "Remaining")"
        } else {
            batteryRemainingTextField.stringValue = "🤷‍♀️"
        }
        
        completionHandler(.newData)
    }
}


class BatteryInfo {
    
    typealias BatteryRemaining = (timeRemaining: String?, charging: Bool)
    
    private let COMMAND_PATH = "/usr/bin/pmset"
    private let COMMAND_ARGUMENTS = ["-g", "batt"]
    
    func timeAndPercentageRemaining() -> BatteryRemaining {
		// Get console output for battery
        let process = Process()
        let pipe = Pipe()
        
        process.launchPath = COMMAND_PATH
        process.arguments = COMMAND_ARGUMENTS
        
        process.standardError = pipe
        process.standardOutput = pipe
        process.launch()
        process.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as! String
        process.terminate()
		
		// Extract the relevant data from the output and return
        return extractTimeRemainingAndPercentage(input: output)
    }
    
    private func extractTimeRemainingAndPercentage(input: String) -> BatteryRemaining {
        var timeRemaining: String? = nil, charging: Bool = true
        let words = input.characters.split {$0 == " " || $0 == "\t"}.map(String.init)
        var index = 0
        
        for word in words {
            if word.contains("discharging") {
                charging = false
            } else if word.contains(":") && index+1 < words.count && words[index+1] == "remaining" {
                timeRemaining = word
            }
            index = index + 1
        }
        
        return (timeRemaining, charging)
    }
    
}
