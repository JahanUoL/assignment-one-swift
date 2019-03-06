//
//  ViewController.swift
//  AssignmentOne
//
//  Created by Jahan on 27/02/2019.
//  Copyright © 2019 Jahan. All rights reserved.
//

import UIKit

class ViewController: UITableViewController  {
    
    var reportsArray : [techReport]! // Stores all the reports from the JSON
    var jahanReport = [[techReport]]() // first array stores years, second year stores the reports associated with them
    
    // Have an array that stores each years count, so years[0] will store the amount of 2001, ex - 8.
    // if the current year selected is not equal to the previous year, inc counter, and move onto the next year (2002).
    // counter += 1
    // years[counter]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        decodeJson()
        
    }
    
    func array() {
        var count = 0
        jahanReport.append([techReport]())
        jahanReport[0].append(reportsArray[0])
        for i in 1..<reportsArray.count {
            if (reportsArray?[i-1].year != reportsArray?[i].year) {
                count += 1
                jahanReport.append([techReport]())
            }
            jahanReport[count].append(reportsArray[i])
        }
    }
    
    // Gets the title header for each section, by accessing the first array from the 2D which stores the years for every associated report
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return jahanReport[section].first?.year
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return jahanReport.count // returns 18 as there is 2001 - 2018 number of sections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(jahanReport[section].count)
        return jahanReport[section].count // Gets the count of how many papers there are given the year
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "jsonCells", for: indexPath)
        
        if !jahanReport.isEmpty{
            let report = jahanReport[indexPath.section][indexPath.row]
            cell.textLabel?.text = " \(report.year) -- \(report.authors) -- \(report.title)"
        }
        
        return cell
    }
    
    func decodeJson() {
        if let url = URL(string: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/techreports/data.php?class=techreports2") {
            let session = URLSession.shared
            
            session.dataTask(with: url) { (data, response, err) in
                
                guard let jsonData = data else { return }
                
                do {
                    let decoder = JSONDecoder()
                    let getTechnicalReports = try decoder.decode(technicalReports.self, from: jsonData)
                    self.reportsArray = getTechnicalReports.techreports2.sorted(by: {$0.year > $1.year })
                    self.array()
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                }
                    
                catch let jsonErr {
                    print("Error decoding JSON", jsonErr)
                }
                }
                .resume()
        }
    }
}


