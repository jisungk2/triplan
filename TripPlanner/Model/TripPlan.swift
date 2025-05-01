import Foundation

/// A single trip, composed of a destination and a list of days
struct TripPlan: Identifiable {
    let id = UUID()
    var destination: String
    var dates: [EachDay]

    init(destination: String, dates: [EachDay]) {
        self.destination = destination
        self.dates = dates
    }

    /// Flatten every activity into one comma‐separated string
    func getAllActivitiesString() -> String {
        destination + ": " +
        dates
          .flatMap { day in
            day.activities.map { activity in
              "\(day.date) \(activity.time) \(activity.activityName) \(activity.location)"
            }
          }
          .joined(separator: ", ")
    }
}

/// One calendar day within a trip, with its list of activities
struct EachDay: Identifiable {
    let id = UUID()
    var date: String
    var activities: [Activity]

    init(date: String, activities: [Activity]) {
        self.date = date
        self.activities = activities
    }

    // Equatable is synthesized, comparing id, date, activities
}

/// A single scheduled thing to do
struct Activity: Identifiable {
    let id = UUID()
    var time: String
    var activityName: String
    var location: String
    var alreadyTaken: Bool

    init(time: String, activityName: String, location: String, alreadyTaken: Bool) {
        self.time = time
        self.activityName = activityName
        self.location = location
        self.alreadyTaken = alreadyTaken
    }
}
