//
//  ViewController.swift
//  GradeTracker
//
//  Created by Matthew McCune on 12/11/21.
//

import UIKit

class ClassViewController: UITableViewController {
    
    let formatter = NumberFormatter()
    
    override func viewDidLoad() {
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classManager.classes.count
    }
    						
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "class", for: indexPath) as! ClassViewCell
        
        cell.textLabel?.text = classManager.classes[indexPath.row].name
        let totalEarned = classManager.classes[indexPath.row].assignments.reduce(0, { curr, next in
            curr + (next.pointsEarned ?? 0)
        })
        let totalPossible = classManager.classes[indexPath.row].assignments.reduce(0, { curr, next in
            curr + (next.pointsPossible ?? 0)
        })
        cell.gradeLabel.text = formatter.string(from: NSNumber(value: (Double(totalEarned) / Double(totalPossible))))
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ClassDetailSegue",
            let destination = segue.destination as? ClassDetailViewController,
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) {
                destination.configure(with: indexPath.row)
            }
        
        if segue.identifier == "ClassEditSegue",
            let destination = segue.destination as? ClassDetailViewController,
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) {
                destination.configure(with: indexPath.row)
            }
    }

}

