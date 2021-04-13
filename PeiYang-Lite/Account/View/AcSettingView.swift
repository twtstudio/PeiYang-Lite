//
//  AcSettingView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/7.
//

import SwiftUI

struct AcSettingView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var isNightKitty = false

    let remindTimes = [15,30,45,60]
    
    @AppStorage(SharedMessage.isShowFullCourseKey, store: Storage.defaults) private var showFullCourse = true
    @AppStorage(SharedMessage.isShowGPAKey, store: Storage.defaults) private var isShowGPA = true
    @AppStorage(SharedMessage.showCourseNumKey, store: Storage.defaults) private var showCourseNum = 6
    @AppStorage(SharedMessage.isRemindBeforeClassKey, store: Storage.defaults) private var isRemindBeforeClass = false
    @AppStorage(SharedMessage.remindTimeBeforeClassKey, store: Storage.defaults) private var remindTime = 0
    
    var body: some View {
        VStack{
            NavigationBar(center: {Text("设置")})
            
            ScrollView{
                //MARK: the first section
                HeaderView(headerName: "通用")
                    .padding(.top)
                
                
                NavigationLink(destination: AcChangeColorView()){
                    StListView(title: "调色板", caption: "给课表、GPA以及黄页自定义喜欢的颜色")
                }
                
                StToggleView(title: "首页显示GPA", caption: nil, isOn: $isShowGPA)
                
                StToggleView(title: "开启夜猫子模式", caption: "晚上9:00以后首页课表将展示第二天课程安排", isOn: $isNightKitty)
                
                //MARK: the second section
                HeaderView(headerName: "课程表")
                    .padding(.top)
                
                NavigationLink(
                    destination: AcSetShowDayView(),
                    label: {
                        StListView(title: "每周显示天数", caption: String(showCourseNum))
                    })
                
                StToggleView(title: "课表显示非本周课程", caption: "课表中将会显示当周并未开课的课程", isOn: $showFullCourse)
                
                
                VStack(spacing: 0) {
                    let isRemindBeforeClassBinding = Binding<Bool> {
                        self.isRemindBeforeClass
                    } set: { (b) in
                        if b {
                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                               if success {
                                   log("获取通知权限")
                               } else if let error = error {
                                   log(error)
                              }
                            }
                        } else {
                            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        }
                        withAnimation {
                            self.isRemindBeforeClass = b
                        }
                    }

                    
                    Toggle(isOn: isRemindBeforeClassBinding) {
                        Text("课前提醒")
                            .foregroundColor(Color.init(red: 98/255, green: 103/255, blue: 122/255))
                    }
                        .toggleStyle(SwitchToggleStyle(tint: Color.init(red: 105/255, green: 109/255, blue: 127/255)))
                        .padding()
                        .frame(width: screen.width * 0.9, height: screen.height / 15, alignment: .center)
                    
                    if isRemindBeforeClass {
                        Color.init(red: 172/255, green: 174/255, blue: 186/255)
                            .frame(width: screen.width * 0.8, height: 1, alignment: .center)
                            .opacity(0.8)
                        
                        HStack{
                            Text("提前时间")
                                .foregroundColor(Color.init(red: 98/255, green: 103/255, blue: 122/255))
                            Spacer()
                            Picker(selection: $remindTime, label: Text("提前时间"), content: {
                                ForEach(0 ..< remindTimes.count) {
                                    Text(remindTimes[$0].description)
                                }
                            })
                            .foregroundColor(Color.init(red: 205/255, green: 206/255, blue: 212/255))
                            .font(.caption)
                            .frame(width: screen.width / 2)
                            .clipped()
                            .onChange(of: remindTime, perform: { value in
                                // TODO: 加入提醒功能
                                Storage.defaults.setValue(remindTimes[value], forKey: "courseTableOffsetMinute")
                                let courseTable = Storage.courseTable.object
                                guard !courseTable.courseArray.isEmpty else { return }
                                NotificationHelper.setNotification(for: courseTable) { (err) in
                                    log(err)
                                }
                            })
                        }
                        .padding(.horizontal)
                        .frame(width: screen.width * 0.9)
                    }
                    
                }
                .background(Color.white)
                .cornerRadius(screen.height / 60)
                
                //: VSTACK the last cell
                
                
            }
            
        }
        .navigationBarHidden(true)
        .background(Color.init(red: 247/255, green: 247/255, blue: 248/255).ignoresSafeArea().frame(width: screen.width, height: screen.height, alignment: .center)
        )
        .addAnalytics(className: "AccountSettingView")
    }
    
    private func sendNotificationToCenter(_ value: Int) {
        let courseTable = Storage.courseTable.object
        guard !courseTable.courseArray.isEmpty else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "上课提醒"
        content.body = "还有\(value)分钟有下一节课"
        content.sound = .default
        
        for course in courseTable.courseArray {
            for arrange in course.arrangeArray {
                print(arrange)
            }
        }
        
        var dateComponents = DateComponents()
        dateComponents.weekday = 1
        dateComponents.hour = 19
        dateComponents.minute = 4
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (err) in
            if let err = err {
                print(err)
            } else {
                print("创建成功")
            }
        })
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        AcSettingView()
    }
}

fileprivate struct HeaderView: View {
    var headerName: String
    var body: some View {
        HStack{
            Text(headerName)
                .font(.custom("Avenir-Heavy", size: 15))
                .foregroundColor(Color.init(red: 177/255, green: 180/255, blue: 186/255))
            Spacer()
        }
        .frame(width: screen.width * 0.9)
    }
}


fileprivate struct StListView: View {
    let titleColor = Color.init(red: 98/255, green: 103/255, blue: 122/255)
    let captionColor = Color.init(red: 205/255, green: 206/255, blue: 212/255)
    var title, caption: String
    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 5.0) {
                Text(title)
                    .foregroundColor(titleColor)
                Text(caption)
                    .foregroundColor(captionColor)
                    .font(.caption)
            }
            Spacer()
            Image("right")
        }
        .padding()
        .frame(width: screen.width * 0.9, height: screen.height / 15, alignment: .center)
        .background(Color.white)
        .cornerRadius(screen.height / 60)
    }
}

fileprivate struct StToggleView: View {
    let titleColor = Color.init(red: 98/255, green: 103/255, blue: 122/255)
    let captionColor = Color.init(red: 205/255, green: 206/255, blue: 212/255)
    var title: String
    var caption: String?
    
    @Binding var isOn: Bool
    
    var body: some View {
        Toggle(isOn: $isOn) {
            HStack{
                if(caption == nil) {
                    VStack(alignment: .leading, spacing: 5.0) {
                        Text(title)
                            .foregroundColor(titleColor)
                    }
                }
                else {
                    VStack(alignment: .leading, spacing: 5.0) {
                        Text(title)
                            .foregroundColor(titleColor)
                        Text(caption!)
                            .foregroundColor(captionColor)
                            .font(.caption)
                    }
                }
            }
        }
        .toggleStyle(SwitchToggleStyle(tint: Color.init(red: 105/255, green: 109/255, blue: 127/255)))
        .padding()
        .frame(width: screen.width * 0.9, height: screen.height / 15, alignment: .center)
        .background(Color.white)
        .cornerRadius(screen.height / 60)
    }
}
