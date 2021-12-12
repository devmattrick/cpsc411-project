//
//  ClassDetailViewController.swift
//  GradeTracker
//
//  Created by Matthew McCune on 12/11/21.
//

import UIKit

class ClassDetailViewController: UITableViewController {
    
    var index: Int?
    var clazz: Class?
    
    func configure(with index: Int) {
        self.index = index
        self.clazz = classManager.classes[index]
        self.title = clazz?.name ?? ""
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clazz?.assignments.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assignment", for: indexPath)
        
        cell.textLabel?.text = clazz?.assignments[indexPath.row].name
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ClassDetailEditSegue",
           let destination = segue.destination as? EditClassViewController {
            destination.configure(with: index)
        }
        
        if segue.identifier == "AssignmentAddSegue",
           let destination = segue.destination as? AssignmentDetailViewController {
            if let index = index {
                destination.configure(classIndex: index, assignmentIndex: nil)
            }
        }
        
        if segue.identifier == "AssignmentDetailSegue",
            let destination = segue.destination as? AssignmentDetailViewController,
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) {
                if let index = index {
                    destination.configure(classIndex: index, assignmentIndex: indexPath.row)
                }
            }
    }
    
    
}
