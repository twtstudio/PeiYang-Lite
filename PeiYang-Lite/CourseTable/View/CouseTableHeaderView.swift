//
//  CouseTableHeaderView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/31/20.
//

import SwiftUI

struct CouseTableHeaderView: View {
    @Binding var activeWeek: Int
    @Binding var showFullCourse: Bool
    var totalWeek: Int
    @ObservedObject var store = Storage.courseTable {
        didSet {
            scrollProxy?.scrollTo(activeWeek)
        }
    }
    @State private var scrollProxy: ScrollViewProxy? = nil
    private var courseTable: CourseTable { store.object }
    @AppStorage(SharedMessage.showCourseNumKey, store: Storage.defaults) private var showCourseNum = 6
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .firstTextBaseline) {
                Text("Schedule")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color(#colorLiteral(red: 0.3856853843, green: 0.403162986, blue: 0.4810273647, alpha: 1)))
                
                Text("WEEK \(activeWeek.description)")
                    .font(.body)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { proxy -> AnyView in
                    scrollProxy = proxy
                    return AnyView(
                        HStack {
                            ForEach(1...totalWeek, id: \.self) { week in
                                Button(action: {
                                    withAnimation {
                                        activeWeek = week
                                    }
                                }, label: {
                                    if let weekMatrixArray = self.getWeekMatrix() {
                                        VStack {
                                            WeekGridView(width: 40, height: 35, rows: 6, cols: showCourseNum, weekMatrix: weekMatrixArray[week-1])
                                                .padding(5)
                                                .background(Color(week==activeWeek ? .gray : .clear).cornerRadius(5).opacity(0.1))
                                            Text("WEEK\(week.description)")
                                                .foregroundColor(.gray)
                                                .font(.footnote)
                                        }
                                        .id(week)
                                    }
                                })
                                .padding(10)
                            }
                        }
                        .onAppear {
                            proxy.scrollTo(activeWeek)
                        }
                    )
                }
            }
            //            .cthViewButtonModifier()
        }
    }
    
    private func getWeekMatrix() -> [[[Bool]]] {
        var emptyMatrix = [[Bool]]()
        for _ in 0..<7 {
            var row = [Bool]()
            for _ in 0..<6 {
                row.append(false)
            }
            emptyMatrix.append(row)
        }
        
        var weekMatrixArray = Array(repeating: emptyMatrix, count: courseTable.totalWeek)
        
        for arrange in courseTable.courseArray.flatMap(\.arrangeArray) {
            for week in arrange.weekArray {
                for unit in arrange.unitArray {
                    
                    weekMatrixArray[week-1][arrange.weekday][Int(Double(unit))/2] = true
                    
                }
            }
        }
        return weekMatrixArray
    }
}

struct CouseTableHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            CouseTableHeaderView(activeWeek: .constant(1), showFullCourse: .constant(false), totalWeek: 1)
                .environment(\.colorScheme, .dark)
        }
    }
}
