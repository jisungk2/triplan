//
//  CPSampleData.swift
//  ClassPlanner
//
//  Created by Justin Wong on 2/23/24.
//

import Foundation

// MARK: - DO NOT MODIFY ------>
struct TripSampleData {
    static let tripPlans = [
        TripPlan(destination: "Costa Rica", dates: [
            EachDay(date: "3/28/25", activities: [
                Activity(time: "13:30", activityName: "Take a shared shuttle to La Fortuna", location: "Hotel Balmoral", alreadyTaken: false),
                Activity(time: "17:00", activityName: "Drop off at La Fortuna", location: "Arenal Country Inn", alreadyTaken: false),
                Activity(time: "18:30", activityName: "Dinner at Don Rufino", location: "Don Rufino", alreadyTaken: false),
            ]),
            EachDay(date: "3/29/25", activities: [
                Activity(time: "15:00", activityName: "Ziplining", location: "Sky Adventures", alreadyTaken: false),
                Activity(time: "19:30", activityName: "Dinner at Restaurante Tiquica La Fortuna", location: "Restaurante Tiquica", alreadyTaken: false),
            ]),
        ]),
    ]
}
// MARK: <------ DO NOT MODIFY
