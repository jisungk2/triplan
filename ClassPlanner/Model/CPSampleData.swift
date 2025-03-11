//
//  CPSampleData.swift
//  ClassPlanner
//
//  Created by Justin Wong on 2/23/24.
//

import Foundation

// MARK: - DO NOT MODIFY ------>
struct CPSampleData {
    static let yearPlans = [
        CPYearPlan(year: 2024, semesters: [
            CPSemester(type: .fall, classes: [
                CPClass(name: "CS61C", instructors: ["Dan Garcia, Justin Yokota"], domain: "Computer Science", alreadyTaken: false),
                CPClass(name: "CS70", instructors: ["Satish Rao, Avishay Tal"], domain: "Computer Science", alreadyTaken: false),
                CPClass(name: "PUBPOL155", instructors: ["Daniel Sargent, Jannet Napolitano"], domain: "Physics", alreadyTaken: false)
            ]),
            CPSemester(type: .spring, classes: [
                CPClass(name: "CS170", instructors: ["Christian Borgs, Prasad Raghavendra"], domain: "Computer Science", alreadyTaken: false),
                CPClass(name: "CS164", instructors: ["Koushik Sen"], domain: "Computer Science", alreadyTaken: false),
                CPClass(name: "Physics 7B", instructors: ["Ronnie Spitizer"], domain: "Physics", alreadyTaken: false)
            ])
        ]),
        CPYearPlan(year: 2023, semesters: [
            CPSemester(type: .fall, classes: [
                CPClass(name: "CS61A", instructors: ["John Denro"], domain: "Computer Science", alreadyTaken: false),
                CPClass(name: "EECS16A", instructors: ["Miki Lustig, Anna Arias"], domain: "Electrical Engineering", alreadyTaken: false),
                CPClass(name: "MATH53", instructors: ["James Sethian"], domain: "Mathematics", alreadyTaken: false)
            ]),
            CPSemester(type: .spring, classes: [
                CPClass(name: "EECS16B", instructors: ["Kannan Ramchandran, Ali Niknejad"], domain: "Computer Science", alreadyTaken: false),
                CPClass(name: "CS61B", instructors: ["Josh Hug, Justin Yokota"], domain: "Computer Science", alreadyTaken: false),
                CPClass(name: "Physics 7A", instructors: ["Catherine Bordel"], domain: "Physics", alreadyTaken: false)
            ])
        ])
    ]
    
    static let yearPlan = CPYearPlan(year: 2024, semesters: [
        CPSemester(type: .spring, classes: [
            CPClass(name: "CS170", instructors: ["Christian Borgs"], domain: "Computer Science", alreadyTaken: false),
            CPClass(name: "CS164", instructors: ["Koushik Sen"], domain: "Computer Science", alreadyTaken: false),
            CPClass(name: "Physics 7B", instructors: ["Ronnie Spitizer"], domain: "Physics", alreadyTaken: false)
        ])
    ])
}
// MARK: <------ DO NOT MODIFY
