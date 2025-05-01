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
            .toolbar { toolbarItems() }
            .listStyle(.insetGrouped)
        }
    }

    // MARK: – Choose existing date
    private var dateSelectionSection: some View {
        Section("Choose a Date") {
            ForEach(plan.dates, id: \.id) { day in
                HStack {
                    Text(day.date)
                    Spacer()
                    if day.id == selectedDate?.id {
                        Image(systemName: "checkmark")
                            .foregroundColor(.accentColor)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture { selectedDate = day }
            }
        }
    }

    // MARK: – Add a new date
    private var addDateSection: some View {
        Section("Or Add a New Date") {
            HStack {
                TextField("Type next date here", text: $newDateString)
                    .foregroundColor(.gray)

                Button("Add Date") {
                    let trimmed = newDateString.trimmingCharacters(in: .whitespaces)
                    // ensure it's nonempty and not already present
                    guard !trimmed.isEmpty,
                          !plan.dates.contains(where: { $0.date == trimmed })
                    else { return }

                    let newDay = EachDay(date: trimmed, activities: [])
                    plan.dates.append(newDay)
                    selectedDate = newDay
                    newDateString = ""
                }
                .disabled(newDateString.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
    }

    // MARK: – Toolbar buttons
    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button("Cancel") { dismiss() }
        }

        // Only show "Add Activity" if a date is selected
        if let day = selectedDate,
           let idx = plan.dates.firstIndex(where: { $0.id == day.id }) {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add Activity") {
                    plan.dates[idx].activities.append(newActivity)
                    dismissParentView()
                    dismiss()
                }
                .bold()
                .foregroundStyle(.green)
            }
        }
    }
}

struct SelectDateView_Previews: PreviewProvider {
    @State static var samplePlan = TripSampleData.tripPlans[0]

    static var previews: some View {
        SelectDateView(
            newActivity: Activity(
                time: "13:30",
                activityName: "Sample Shuttle",
                location: "Hotel Balmoral",
                alreadyTaken: false
            ),
            plan: $samplePlan,
            dismissParentView: {}
        )
    }
}
