import SwiftUI

struct SelectDateView: View {
    @Environment(\.dismiss) private var dismiss

    /// The activity you want to add:
    var newActivity: Activity

    /// Binding to the single TripPlan you’re editing:
    @Binding var plan: TripPlan

    /// Call this when you’re done so the parent can refresh:
    var dismissParentView: () -> Void

    /// Which day the user tapped (existing or newly created):
    @State private var selectedDate: EachDay?

    /// TextField for typing a brand-new date:
    @State private var newDateString: String = ""

    var body: some View {
        NavigationStack {
            List {
                dateSelectionSection
                addDateSection
            }
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: toolbarItems)
            .listStyle(.insetGrouped)
        }
    }

    // MARK: – Subviews to ease type-checking

    private var dateSelectionSection: some View {
        // 1) Bind plan.dates to a simple local constant
        let days = plan.dates
        
        return Section("Choose a Date") {
            // 2) Iterate that local array
            ForEach(days, id: \.id) { day in
                dateRow(for: day)
            }
        }
    }

    // 3) Pull the row into its own function to simplify the closure
    private func dateRow(for day: EachDay) -> some View {
        HStack {
            Text(day.date)
            Spacer()
            if day == selectedDate {
                Image(systemName: "checkmark")
                    .foregroundColor(.accentColor)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            selectedDate = day
        }
    }




    private var addDateSection: some View {
        Section("Or Add a New Date") {
            HStack {
                TextField("Type next date here", text: $newDateString)
                    .foregroundColor(.gray)

                Button("Add Date") {
                    let trimmed = newDateString.trimmingCharacters(in: .whitespaces)
                    guard !trimmed.isEmpty,
                          !plan.hasDay(for: trimmed)
                    else { return }
                    // note: `activities` not `classes`
                    let newDay = EachDay(date: trimmed, activities: [])
                    plan.dates.append(newDay)
                    selectedDate = newDay
                    newDateString = ""
                }
                .disabled(newDateString.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
    }

    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button("Cancel") { dismiss() }
        }
        if selectedDate != nil {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add Activity") {
                    // append into the `activities` array
                    if let day = selectedDate,
                       let idx = plan.dates.firstIndex(of: day)
                    {
                        plan.dates[idx].activities.append(newActivity)
                    }
                    dismissParentView()
                    dismiss()
                }
                .bold()
                .foregroundStyle(.green)
            }
        }
    }
}

// Simple state‐to‐binding wrapper for previews:
struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    var content: (Binding<Value>) -> Content
    var body: some View { content($value) }
}

struct SelectDateView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(
            value: TripSampleData.tripPlans[0]
        ) { bindingPlan in
            SelectDateView(
                newActivity: Activity(
                    time: "13:30",
                    activityName: "Sample Shuttle",
                    location: "Hotel Balmoral",
                    alreadyTaken: false
                ),
                plan: bindingPlan,
                dismissParentView: {}
            )
        }
    }
}

