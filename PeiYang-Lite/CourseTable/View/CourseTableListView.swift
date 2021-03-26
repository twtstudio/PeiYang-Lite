//
//  CourseTableListView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 8/2/20.
//

import SwiftUI

struct CourseTableListView: View {
    let activeCourseArray: [Course]
    
    @Environment(\.horizontalSizeClass) private var sizeClass
    private var isRegular: Bool { sizeClass == .regular }
    
    @State private var activeIndex = -1
    @State private var showDetail = false
    
    @State private var slectedCrouseIndex = [Int]()
    
    
    private var weekdays: [String] {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        var weekdays = calendar.shortWeekdaySymbols
        weekdays.append(weekdays.remove(at: 0))
        return weekdays
    }
    
    var body: some View {
        ForEach(activeCourseArray, id: \.no) { course in
            VStack(alignment: .leading) {
                // MARK: - Overview
                HStack {
                    Text(course.name)
                    
                    Spacer()
                    
                    Text(course.teachers)
                        .font(.subheadline)
                }
                .padding(.bottom)
                
                HStack {
                    Text("credit: \(course.credit)")
                    Text("weeks: \(course.weeks)")
                    
                    Spacer()
                    
                    Image(systemName: "ellipsis.circle")
                }
                .font(.headline)
                .foregroundColor(.secondary)
                
                // MARK: - Detail
                if activeIndex == activeCourseArray.firstIndex { $0.no == course.no } ?? -1 && showDetail {
                    ForEach(activeCourseArray[activeIndex].arrangeArray.sorted(), id: \.uuid) { arrange in
                        HStack {
                            Image(systemName: "chevron.right")
                                .padding(.top)
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    if isRegular {
                                        Text("week \(arrange.weekString)")
                                        Text(weekdays[arrange.weekday])
                                        Text("unit \(arrange.unitString)")
                                        Text(arrange.unitTimeString)
                                    } else {
                                        VStack(alignment: .leading) {
                                            HStack {
                                                Text("week \(arrange.weekString)")
                                                Text(weekdays[arrange.weekday])
                                            }
                                            HStack {
                                                Text("unit \(arrange.unitString)")
                                                Text(arrange.unitTimeString)
                                                }
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Text(arrange.teachers)
                                        .font(.subheadline)
                                }
                                .padding(.top)
                                
                                if !arrange.location.isEmpty {
                                    Text("location: \(arrange.location)")
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
//                        $activeIndex.append(slectedCrouseIndex)
//                        slectedCrouseIndex.append(course.no)
                        
                    }
                    .padding(.top, 8)
                    .transition(.opacity)
                }
            }
            .padding()
            .onTapGesture {
                let currentIndex = activeCourseArray.firstIndex { $0.no == course.no } ?? -1
                withAnimation {
                    if currentIndex == activeIndex {
                        activeIndex = -1
                        showDetail = false
                    } else {
                        activeIndex = currentIndex
                        showDetail = true
                    }
                }
            }
        }
    }
}

struct CourseTableListView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            CourseTableListView(activeCourseArray: [Course]())
                .environment(\.colorScheme, .dark)
        }
    }
}
