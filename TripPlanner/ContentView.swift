import SwiftUI

struct ContentView: View {
    @State private var tripPlans: [TripPlan] = TripSampleData.tripPlans
    @State private var currentPlanIndex = 0
    @State private var isInEditMode = false
    @State private var isPresentingAddDateSheet = false
    @State private var themeColor = Color.blue
    @State private var suggestionsByTrip: [Int: [Message]] = [0:[]]
    @ObservedObject var viewModel = ViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                headerView

                Text("Suggestions")
                    .font(.headline)
                    .padding(.bottom, 4)

                if ((suggestionsByTrip[currentPlanIndex]?.contains(where: { $0.role != .user })) != nil) {
                    messagesView
                      .frame(maxHeight: 150)      // clamp its height
                      .transition(.move(edge: .bottom).combined(with: .opacity))
                      .padding(.vertical, 4)
                }

                tripPagerView
            }
            .toolbar { toolbarItems() }
            .sheet(isPresented: $isPresentingAddDateSheet) { addDateSheet }
            .tint(themeColor)
            .animation(.default, value: viewModel.messages)
        }
    }

    // MARK: – Header with navigation & add buttons
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 25) {
            // 1) Title row expands to full width and aligns its contents to leading
            HStack {
                Image("Triplan-Logo")
                    .resizable()
                    .frame(width: 50, height: 50)
                Text("My Trips")
                    .font(.system(size: 35, weight: .heavy))
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // 2) Navigation row already stretches full width
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

                if currentPlanIndex < tripPlans.count - 1 {
                    Button {
                        withAnimation {
                            currentPlanIndex += 1
                        }
                    } label: {
                        Image(systemName: "chevron.right.circle.fill")
                    }
                } else {
                    Button {
                        withAnimation {
                            let newPlan = TripPlan(destination: "", dates: [])
                            tripPlans.append(newPlan)
                            currentPlanIndex = tripPlans.count - 1
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(.green)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .font(.largeTitle)
        .padding()
    }


    @ViewBuilder
    private var messagesView: some View {
        // only proceed if we actually have AI replies for this trip
        if let aiReplies = suggestionsByTrip[currentPlanIndex]?
                             .filter({ $0.role != .user }),
           !aiReplies.isEmpty
        {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(aiReplies, id: \.id) { msg in
                        let items = msg.content
                            .split(separator: ",")
                            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(items, id: \.self) { item in
                                HStack(alignment: .top, spacing: 6) {
                                    Text("•")
                                    Text(item)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .frame(maxHeight: 150)
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
        // else: nothing (EmptyView)
    }


    // MARK: – Paged trip-detail view
    private var tripPagerView: some View {
        TabView(selection: $currentPlanIndex) {
            ForEach(Array(tripPlans.enumerated()), id: \.offset) { idx, _ in
                TripDetailView(plan: $tripPlans[idx], isEditing: isInEditMode)
                    .tag(idx)
                    .padding(.horizontal, 10)
            }
        }
        .tabViewStyle(.page)
    }

    // MARK: – Toolbar buttons
    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                isPresentingAddDateSheet.toggle()
            } label: {
                Image(systemName: "plus").bold()
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button("Ask for Suggestions") {
                askForSuggestions(tripPlan: tripPlans[currentPlanIndex])
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button(isInEditMode ? "Done" : "Edit") {
                withAnimation { isInEditMode.toggle() }
            }
        }
    }

    // MARK: – Sheet content for adding dates/activities
    private var addDateSheet: some View {
        AddTripView(tripPlan: $tripPlans[currentPlanIndex])
    }

    // MARK: – Trigger the AI prompt
    private func askForSuggestions(tripPlan: TripPlan) {
        let allActivities = tripPlan.getAllActivitiesString()
        viewModel.currentInput = allActivities
        if tripPlan.destination.isEmpty {
            viewModel.currentInput = "This is an empty trip plan please reply with: 'Please provide a destination name or a few activity plans to get some suggestions!' Ignore the messages that come after."
        }
        viewModel.sendMessage { aiResponse in
            suggestionsByTrip[currentPlanIndex, default: []].append(aiResponse)
        }

    }

    // MARK: – Inline title editing
    @ViewBuilder
    private func TextDisplayOrEdit() -> some View {
        let plan = tripPlans[currentPlanIndex]
        if isInEditMode {
            TextField(
                "Type next trip destination here",
                text: $tripPlans[currentPlanIndex].destination
            )
            .font(.system(size: 35, weight: .heavy))
            .foregroundColor(plan.destination.isEmpty ? .gray : .primary)
            .multilineTextAlignment(.center)
        } else {
            Text(plan.destination.isEmpty
                 ? "— No Destination —"
                 : plan.destination
            )
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
                Text(isEditing
                     ? "Add days for \(plan.destination)"
                     : "No days yet"
                )
                .foregroundStyle(.secondary)
            } else {
                ForEach(plan.dates, id: \.id) { day in
                    Section(header: Text(day.date).font(.headline)) {
                        let sortedActs = day.activities.sorted { $0.time < $1.time }
                        if sortedActs.isEmpty {
                            Text("No activities")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(sortedActs, id: \.id) { act in
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
