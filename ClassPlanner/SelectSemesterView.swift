//
//  SelectSemesterView.swift
//  ClassPlannerFinished
//
//  Created by Justin Wong on 2/24/24.
//

import SwiftUI

struct SelectSemesterView: View {
    @Environment(\.dismiss) private var dismiss
    
    var newClass: CPClass
    var yearPlans: [CPYearPlan]
    var dismissParentView: () -> Void
    @State private var selectedSemester: CPSemester?
    
    var body: some View {
        NavigationStack {
            List(yearPlans) { yearPlan in
                VStack(spacing: 20) {
                    HStack {
                        Text(String(yearPlan.year))
                                .fontWeight(.heavy)
                                .font(.title)
                        Spacer()
                    }
                   
                    HStack {
                        if yearPlan.hasSemester(for: .fall) {
                            SelectSemesterButton(selectedSemester: $selectedSemester, yearPlan: yearPlan, semesterType: .fall)
                        }
                        
                        Spacer()
                        
                        if yearPlan.hasSemester(for: .spring) {
                            SelectSemesterButton(selectedSemester: $selectedSemester, yearPlan: yearPlan, semesterType: .spring)
                        }
                    }
                }
                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Select Semester")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancel")
                    }
                }
                
                if selectedSemester != nil {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            dismiss()
                            dismissParentView()
                            selectedSemester?.classes.append(newClass)
                        }) {
                            Text("Add")
                                .foregroundStyle(.green)
                                .bold()
                        }
                    }
                }
            }
        }
    }
}

// MARK: - SelectSemesterButton
struct SelectSemesterButton: View {
    @Binding var selectedSemester: CPSemester?
    var yearPlan: CPYearPlan
    var semesterType: CPSemester.CPSemesterType
    
    private var currentSemester: CPSemester? {
        yearPlan.getSemester(for: semesterType)
    }
    
    var body: some View {
        Button(action: {
            selectedSemester = currentSemester
        }) {
            Text("\(semesterType == .fall ? "FALL" : "SPRING")")
                .padding()
                // TODO: - THEME COLOR SHOULD BE HERE
                .background(currentSemester == selectedSemester ? Color.blue.opacity(0.2) : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}
#Preview {
    SelectSemesterView(newClass: CPClass(name: "CS61A", instructors: ["John Denro"], domain: "Computer Science", alreadyTaken: true), yearPlans: CPSampleData.yearPlans, dismissParentView: {})
}
