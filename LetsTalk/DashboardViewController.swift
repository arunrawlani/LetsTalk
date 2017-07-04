//
//  DashboardViewController.swift
//  LetsTalk
//
//  Created by Arun Rawlani on 6/18/17.
//  Copyright © 2017 Arun Rawlani. All rights reserved.
//

import Foundation
import UIKit

class DashboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var probLabel: UILabel!
    @IBOutlet weak var imageDot: UIImageView!
    @IBOutlet weak var numOfSessionsLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    var arrayOfSessions: [Session]?
    
    override func viewDidLoad() {
        let s1 = Session(percentage: "73", status: "High impairment chance")
        let s2 = Session(percentage: "81", status: "High impairment chance")
        let s3 = Session(percentage: "59", status: "High impairment chance")
        let s4 = Session(percentage: "61", status: "Higher impairment chance")
        let s5 = Session(percentage: "77", status: "Higher impairment chance")
        arrayOfSessions = [s1, s2, s3, s4, s5]
        
        numOfSessionsLabel.text = "Age: "+"\(4)"
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfSessions!.count 
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        if (arrayOfSessions?.count == 0) {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            messageLabel.text = "No sessions recorded"
            messageLabel.textColor = UIColor.white
            messageLabel.font = UIFont(name: "Avenir Next", size: 27)
            messageLabel.numberOfLines = 1
            messageLabel.textAlignment = NSTextAlignment.center
            messageLabel.sizeToFit()
            self.tableView.backgroundView = messageLabel
            return 0
        }
        else {
            self.tableView.backgroundView = nil
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardCell") as! DashboardTableViewCell
        
        cell.sessionName.text = self.arrayOfSessions?[indexPath.row].status
        cell.percentage.text = (self.arrayOfSessions?[indexPath.row].percentage)! + "%"
        

        
        return cell
    }
    
}

