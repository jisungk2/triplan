//
//  CPYearPlan.swift
//  ClassPlannerFinished
//
//  Created by Justin Wong on 2/23/24.
//

import Foundation

class TripPlan: Identifiable {
    let id = UUID()
    var destination: String
    var dates: [EachDay]
    
    init(destination: String, dates: [EachDay]) {
        self.destination = destination
        self.dates = dates
    }
    
    func hasDay(for date: String) -> Bool {
        // TODO: 3A. IMPLEMENT USING A CLOSURE
        for day in dates {
            if day.date == date {
                return true
            }
        }
        return false
    }
    
    func getDay(for date: String) -> EachDay? {
        // TODO: 3B. IMPLEMENT USING A CLOSURE
        for day in dates {
            if day.date == date {
                return day
            }
        }
        return nil
    }
}

class EachDay: Identifiable, Equatable {
    static func == (lhs: EachDay, rhs: EachDay) -> Bool {
        lhs.id == rhs.id
    }
    
    var id = UUID()
    var date: String
    var activities: [Activity]
    
    init(id: UUID = UUID(), date: String, activities: [Activity]) {
        self.id = id
        self.date = date
        self.activities = activities
    }
}

class Activity: Identifiable {
    var id = UUID()
    var time: String
    var activityName: String
    var location: String
    var alreadyTaken: Bool
    
    init(id: UUID = UUID(), time: String, activityName: String, location: String, alreadyTaken: Bool) {
        self.id = id
        self.time = time
        self.activityName = activityName
        self.location = location
        self.alreadyTaken = alreadyTaken
    }
}
