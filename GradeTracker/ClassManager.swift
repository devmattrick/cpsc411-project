//
//  ClassManager.swift
//  GradeTracker
//
//  Created by Matthew McCune on 12/12/21.
//

import Foundation
import SQLite

let classManager = ClassManager()

class ClassManager {
    
    var classes: [Class] = []
    
    var db: Connection?
    let classTable = Table("class")
    let assignmentTable = Table("assignment")
    let id = Expression<Int64>("id")
    let name = Expression<String>("name")
    let pointsPossible = Expression<Int64?>("pointsPossible")
    let pointsEarned = Expression<Int64?>("pointsEarned")
    let classId = Expression<Int64>("classId")
    
    init() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
            ).first!
            db = try Connection("\(path)/db.sqlite3")
            
            if let db = db {
                try db.run(classTable.create(ifNotExists: true) { t in
                    t.column(id, primaryKey: true)
                    t.column(name)
                })
                
                try db.run(assignmentTable.create(ifNotExists: true) { t in
                    t.column(id, primaryKey: true)
                    t.column(name)
                    t.column(pointsEarned)
                    t.column(pointsPossible)
                    t.column(classId)
                })
                for clazz in try db.prepare(classTable) {
                    var newClass = Class(id: clazz[id], name: clazz[name], assignments: [])
                    
                    for assign in try db.prepare(assignmentTable.filter(classId == clazz[id])) {
                        let assignment = Assignment(id: assign[id], name: assign[name], pointsPossible: assign[pointsPossible], pointsEarned: assign[pointsEarned])
                        
                        newClass.assignments.append(assignment)
                    }
                    
                    classes.append(newClass)
                }
            }
            
        } catch {
            print(error)
        }
    }
    
    func save() {
        do {
            if let db = db {
                for clazz in classes {
                    print("saving", clazz.id)
                    if clazz.id == -1 {
                        try db.run(classTable.insert(name <- clazz.name))
                    } else {
                        try db.run(classTable.filter(id == clazz.id).update(name <- clazz.name))
                    }
                    
                    for assign in clazz.assignments {
                        if assign.id == -1 {
                            try db.run(assignmentTable.insert(name <- assign.name, pointsEarned <- assign.pointsEarned, pointsPossible <- assign.pointsPossible, classId <- clazz.id))
                        } else {
                            try db.run(assignmentTable.filter(id == assign.id).update(name <- assign.name, pointsEarned <- assign.pointsEarned, pointsPossible <- assign.pointsPossible, classId <- clazz.id))
                        }
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
}
