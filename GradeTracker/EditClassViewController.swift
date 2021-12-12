//
//  EditClassViewController.swift
//  GradeTracker
//
//  Created by Matthew McCune on 12/12/21.
//

import UIKit

class EditClassViewController: UIViewController {
    var index: Int?
    
    @IBOutlet
    var nameInput: UITextField!
    
    func configure(with index: Int?) {
        self.index = index
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = index {
            self.nameInput.text = classManager.classes[index].name
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FinishEditingSegue",
           let destination = segue.destination as? ClassDetailViewController {
            if let name = nameInput.text {
                if let index = index {
                    classManager.classes[index].name = name
                    destination.configure(with: index)
                    return
                }
                
                let clazz = Class (id: -1, name: name, assignments: [])
                classManager.classes.append(clazz)
                
                classManager.save()
                destination.configure(with: classManager.classes.count - 1)
            }
        }
    }
    
}
