//
//  AcSetShowDayView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/3/6.
//

import SwiftUI

struct AcSetShowDayView: View {
    init(){UITableView.appearance().backgroundColor = .clear}
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @AppStorage(SharedMessage.showCourseNumKey, store: Storage.defaults) private var showCourseNum = 5
    var body: some View {
        VStack {
            NavigationBar()
            HStack {
                Text("课程表-每周展示天数")
                    .font(.custom("Avenir-heavy", size: UIScreen.main.bounds.height / 35))
                    .foregroundColor(.init(red: 48/255, green: 60/255, blue: 102/255))
                Spacer()
            }
            .padding(.horizontal, 30)
            
            HStack {
                Text("课程表页面将会根据选择调整展示的天数。")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
            
            List {
                Section {
                    Button(action: {
                        showCourseNum = 4
                    }, label: {
                        ChooseShowDaysView(isSelected: showCourseNum == 4, title: "5天")
                    })
                    Button(action: {
                        showCourseNum = 5
                    }, label: {
                        ChooseShowDaysView(isSelected: showCourseNum == 5, title: "6天")
                    })
                    Button(action: {
                        showCourseNum = 6
                    }, label: {
                        ChooseShowDaysView(isSelected: showCourseNum == 6, title: "7天")
                    })
                }
            }.listStyle(InsetGroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
        }
        .onAppear(perform: {
            UMAnalyticsSwift.beginLogPageView(pageName: "DayNumSettingView")
        })
        .onDisappear(perform: {
            UMAnalyticsSwift.endLogPageView(pageName: "DayNumSettingView")
        })
        .frame(width: screen.width)
        .background(Color.init(red: 245/255, green: 245/255, blue: 245/255).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height).ignoresSafeArea()
        )
        .navigationBarHidden(true)
    }
}

struct AcSetShowDayView_Previews: PreviewProvider {
    static var previews: some View {
        AcSetShowDayView()
    }
}

fileprivate struct ChooseShowDaysView: View {
    var isSelected: Bool
    var title: String
    var subTitle: String {
        switch title {
        case "5天":
            return "周一至周五"
        case "6天":
            return "周一至周六"
        case "7天":
            return "周一至周日"
        default:
            return "wrong"
        }
    }
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                Text(title)
                    .foregroundColor(.init(red: 98/255, green: 103/255, blue: 122/255))
                Text(subTitle)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            Spacer()
            Image("selected")
                .opacity(isSelected ? 1 : 0)
                .animation(.easeInOut)
        }
        .frame(height: screen.height / 15)
    }
}
