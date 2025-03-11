//
//  AddClassView.swift
//  ClassPlannerFinished
//
//  Created by Justin Wong on 2/23/24.
//

import SwiftUI

struct AddClassView: View {
    @Environment(\.dismiss) private var dismiss

    var yearPlans: [CPYearPlan]
    @State private var newClassName = ""
    @State private var newClassDomain = ""
    @State private var newClassDifficulty = 0
    @State private var newClassInstructors = [String]()
    @State private var newClassInstructor = ""
    @State private var alreadyTakenClass = false
    @State private var showSelectSemesterSheet = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                CPHeaderTextField(headerTitle: "Class Name:", newText: $newClassName)
                Divider()
                CPHeaderTextField(headerTitle: "Class Domain:", newText: $newClassDomain)
                Divider()
                classInstructorsSection
                Spacer()
                nextButton
            }
            .padding()
            .navigationTitle("Add Class")
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
            .sheet(isPresented: $showSelectSemesterSheet) {
                SelectSemesterView(newClass: 
                                    CPClass(name: newClassName, instructors: newClassInstructors, domain: newClassDomain, alreadyTaken: alreadyTakenClass),
                                   yearPlans: yearPlans, dismissParentView: dismissAddClassView)
            }
        }
    }
    
    private var classInstructorsSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Class Instructors:")
                        .bold()
                        .font(.title2)
                Spacer()
                if newClassInstructors.count > 0 {
                    Text("\(newClassInstructors.count) Added")
                        .bold()
                        .foregroundStyle(.secondary)
                }
            }
            
            Text("You can only add a maximum of 5 instructors to a class")
                .foregroundStyle(.red)
                .font(.caption)
          
            if newClassInstructors.count < 5 {
                HStack {
                    CPTextField(newText: $newClassInstructor)
                    Button(action: {
                        guard !newClassInstructor.isEmpty, !newClassInstructors.contains(newClassInstructor)
                              else { return }
                        newClassInstructors.append(newClassInstructor)
                        newClassInstructor = ""
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(.green)
                            .font(.system(size: 26))
                    }
                }
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            }
            
            List(newClassInstructors, id: \.self) { instructor in
                HStack {
                    Button(action: {
                        if let removeIndex = newClassInstructors.firstIndex(of: instructor) {
                            newClassInstructors.remove(at: removeIndex)
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .foregroundStyle(.red)
                            .font(.system(size: 20))
                    }
                    Text(instructor)
                        .bold()
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
            }
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden)
        }
    }
    
    private var nextButton: some View {
        Button(action: {
            guard !newClassName.isEmpty, !newClassDomain.isEmpty, !newClassInstructors.isEmpty  else { return }
            showSelectSemesterSheet.toggle()
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

#Preview {
    AddClassView(yearPlans: CPSampleData.yearPlans)
}
