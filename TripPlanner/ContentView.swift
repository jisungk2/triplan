import SwiftUI

struct ContentView: View {
    @State private var tripPlans: [TripPlan] = TripSampleData.tripPlans
    @State private var currentPlanIndex = 0
    @State private var isInEditMode = false
    @State private var isPresentingAddDateSheet = false
    @State private var themeColor = Color.blue

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button {
                        withAnimation {
                            if currentPlanIndex > 0 {
                                currentPlanIndex -= 1
                            }
                        }
                    } label: {
                        Image(systemName: "chevron.left.circle.fill")
                    }
                    Spacer()
                    TextDisplayOrEdit()
                    Spacer()
                    Button {
                        withAnimation {
                            // append a new, empty TripPlan
                            let newPlan = TripPlan(destination: "", dates: [])
                            tripPlans.append(newPlan)
                            currentPlanIndex = tripPlans.count - 1
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(Color.green)
                    }
                }
                .font(.largeTitle)
                .padding()

                TabView(selection: $currentPlanIndex) {
                    ForEach(Array(tripPlans.enumerated()), id: \.offset) { idx, plan in
                        TripDetailView(plan: $tripPlans[idx], isEditing: isInEditMode)
                            .tag(idx)
                            .padding(.horizontal, 10)
                    }
                }
                .tabViewStyle(.page)
            }
            .navigationTitle("My Trips")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        isPresentingAddDateSheet.toggle()
                    }) {
                        Image(systemName: "plus")
                            .bold()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(isInEditMode ? "Done" : "Edit") {
                        withAnimation { isInEditMode.toggle() }
                    }
                }
            }
            .sheet(isPresented: $isPresentingAddDateSheet) {
                AddTripView(tripPlan: $tripPlans[currentPlanIndex])
            }
            .tint(themeColor)
        }
    }

    @ViewBuilder
    private func TextDisplayOrEdit() -> some View {
        let plan = tripPlans[currentPlanIndex]
        if isInEditMode {
            // bind directly into the array’s destination
            TextField(
                "Type next trip destination here",
                text: $tripPlans[currentPlanIndex].destination
            )
            .font(.system(size: 35, weight: .heavy))
            .foregroundColor(plan.destination.isEmpty ? .gray : .primary)
            .multilineTextAlignment(.center)
        } else {
            Text(plan.destination.isEmpty ? "— No Destination —" : plan.destination)
                .font(.system(size: 20, weight: .heavy))
                .multilineTextAlignment(.center)
        }
    }
}

struct TripDetailView: View {
  @Binding var plan: TripPlan
  let isEditing: Bool

  var body: some View {
    List {
      if plan.dates.isEmpty {
        Text(isEditing ? "Add days for \(plan.destination)" : "No days yet")
          .foregroundStyle(.secondary)
      } else {
        // for each day, make a Section with the date as header
        ForEach(plan.dates) { day in
          Section(header: Text(day.date).font(.headline)) {
            if day.activities.isEmpty {
              Text("No activities")
                .foregroundStyle(.secondary)
            } else {
              // for each activity on that day...
              ForEach(day.activities) { act in
                VStack(alignment: .leading, spacing: 4) {
                  Text(act.time)
                    .font(.subheadline).bold()
                  Text(act.activityName)
                  Text(act.location)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
              }
            }
          }
        }
      }
    }
    .listStyle(.insetGrouped)
  }
}

#Preview {
    ContentView()
}
