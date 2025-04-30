////
////  SemesterListView.swift
////  ClassPlannerFinished
////
////  Created by Justin Wong on 2/23/24.
////
//
//import SwiftUI
//
//struct SemesterListView: View {
//    var yearPlan: CPYearPlan
//    var isInEditMode: Bool
//    
//    var body: some View {
//        VStack {
//            ForEach(yearPlan.semesters) { semester in
//                SemesterDisclosureGroup(semester: semester, isInEditMode: isInEditMode)
//            }
//            Spacer()
//        }
//    }
//}
//
//// MARK: - SemesterDisclosureGroup
//struct SemesterDisclosureGroup: View {
//    @State private var isExpanded = true
//    var semester: CPSemester
//    var isInEditMode: Bool
//    
//    var body: some View {
//        DisclosureGroup(
//            isExpanded: $isExpanded,
//            content: {
//                if !semester.classes.isEmpty {
//                    VStack(spacing: 20) {
//                        ForEach(semester.classes, id: \.id) { cpClass in
//                            ClassRowView(semester: semester, cpClass: cpClass, isInEditMode: isInEditMode)
//                        }
//                    }
//                } else {
//                    Text("No Classes Available")
//                        .bold()
//                        .foregroundStyle(.secondary)
//                }
//            },
//            label: {
//                Text(semester.type == .fall ? "Fall" : "Spring")
//                    .font(.system(size: 30))
//                    .fontWeight(.heavy)
//            }
//        )
//    }
//}
//
//// MARK: - ClassRowView
//struct ClassRowView: View {
//    var semester: CPSemester
//    var cpClass: CPClass
//    var isInEditMode: Bool
//    
//    @State private var showClassDetailView = false
//    
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading) {
//                Text(cpClass.name)
//                        .bold()
//                Text(cpClass.domain)
//                    .font(.caption)
//                // TODO: - THEME COLOR SHOULD BE HERE
//                    .foregroundStyle(Color.blue)
//                Text(cpClass.getInstructorsString)
//                        .foregroundStyle(.secondary)
//                        .font(.caption)
//            }
//            
//            Spacer()
//            
//            if isInEditMode {
//                Button(action: {
//                    if let removeIndex = semester.classes.firstIndex(where: { $0.id == cpClass.id }) {
//                        semester.classes.remove(at: removeIndex)
//                    }
//                }) {
//                    Image(systemName: "trash")
//                        .font(.system(size: 20))
//                        .foregroundStyle(.red)
//                }
//            } else {
//                Button(action: {
//                    withAnimation {
//                        cpClass.alreadyTaken.toggle()
//                    }
//                }) {
//                    Image(systemName: cpClass.alreadyTaken ? "checkmark.circle.fill" : "circle")
//                        .font(.system(size: 20))
//                }
//            }
//        }
//        .onTapGesture {
//            withAnimation {
//                showClassDetailView.toggle()
//            }
//        }
//    }
//}
//
//
//#Preview {
//    Group {
//        SemesterListView(yearPlan: CPSampleData.yearPlan, isInEditMode: false)
//    }
//    .padding()
//}
