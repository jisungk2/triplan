//
//  AddClassView.swift
//  ClassPlannerFinished
//
//  Created by Justin Wong on 2/23/24.
//

import SwiftUI

struct AddTripView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var tripPlan: TripPlan
    
    @State private var newTime = ""
    @State private var newActivityName = ""
    @State private var newLocation = ""
    @State private var alreadyTakenClass = false
    @State private var showSelectDateSheet = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                CPHeaderTextField(headerTitle: "Activity Time:", newText: $newTime)
                Divider()
                CPHeaderTextField(headerTitle: "Activity Name:", newText: $newActivityName)
                Divider()
                CPHeaderTextField(headerTitle: "Activity Location:", newText: $newLocation)
                Spacer()
                nextButton
            }
            .padding()
            .navigationTitle("Add Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray)
                            .font(.system(size: 25))
                    }
                }
            }
            .sheet(isPresented: $showSelectDateSheet) {
                SelectDateView(newActivity:
                                Activity(time: newTime, activityName: newActivityName, location: newLocation, alreadyTaken: alreadyTakenClass),
                               plan: $tripPlan, dismissParentView: dismissAddClassView)
            }
        }
    }
    
    private var nextButton: some View {
        Button(action: {
            guard !newTime.isEmpty, !newActivityName.isEmpty, !newLocation.isEmpty  else { return }
            showSelectDateSheet.toggle()
        }) {
            HStack {
                Spacer()
                Text("Next")
                Spacer()
            }
            .foregroundStyle(.white)
            .bold()
            .padding()
            .background(.gray)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    func dismissAddClassView() {
        dismiss()
    }
}

//MARK: - CPHeaderTextField 
struct CPHeaderTextField: View {
    var headerTitle: String
    @Binding var newText: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(headerTitle)
                .bold()
                .font(.title2)
           CPTextField(newText: $newText)
        }
    }
}

//MARK: - CPTextField
struct CPTextField: View {
    @Binding var newText: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(lineWidth: 2)
            .frame(height: 50)
            .overlay(
                TextField("", text: $newText)
                    .bold()
                // TODO: - THEME COLOR SHOULD BE HERE
                    .foregroundStyle(Color.blue)
                    .padding()
            )
    }
}

struct AddTripView_Previews: PreviewProvider {
    static var previews: some View {
        AddTripView(
            tripPlan: .constant(TripSampleData.tripPlans[0])
        )
    }
}
