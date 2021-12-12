//
//  AssignmentDetailViewController.swift
//  GradeTracker
//
//  Created by Matthew McCune on 12/12/21.
//

import UIKit

class AssignmentDetailViewController: UIViewController {
    
    var classIndex: Int?
    var assignmentIndex: Int?
    
    @IBOutlet
    var nameInput: UITextField!
    
    @IBOutlet
    var earnedInput: UITextField!
    
    @IBOutlet
    var possibleInput: UITextField!
    
    func configure(classIndex: Int, assignmentIndex: Int?) {
        self.classIndex = classIndex
        self.assignmentIndex = assignmentIndex
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let classIndex = classIndex,
           let assignmentIndex = assignmentIndex {
            let clazz = classManager.classes[classIndex]
            let assignment = clazz.assignments[assignmentIndex]
            
            nameInput.text = assignment.name
            if let earned = assignment.pointsEarned {
                earnedInput.text = String(earned)
            }
            if let possible = assignment.pointsPossible {
                possibleInput.text = String(possible)
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ClassDetailSegue",
           let destination = segue.destination as? ClassDetailViewController {
            if let classIndex = classIndex {
                let name = nameInput.text ?? "Unnamed Assignment"
                
                if let assignmentIndex = assignmentIndex {
                    classManager.classes[classIndex].assignments[assignmentIndex].name = name
                    
                    if let earned = earnedInput.text {
                        classManager.classes[classIndex].assignments[assignmentIndex].pointsEarned = Int64(earned)
                    }
                    
                    if let possible = possibleInput.text {
                        classManager.classes[classIndex].assignments[assignmentIndex].pointsPossible = Int64(possible)
                    }
                } else {
                    var assignment = Assignment(id: -1, name: nameInput.text ?? "Unnamed Assignment")
                    
                    if let earned = earnedInput.text {
                        assignment.pointsEarned = Int64(earned)
                    }
                    
                    if let possible = possibleInput.text {
                        assignment.pointsPossible = Int64(possible)
                    }
                    
                    classManager.classes[classIndex].assignments.append(assignment)
                }
                
                classManager.save()
                destination.configure(with: classIndex)
            }
        }
    }
    
}
