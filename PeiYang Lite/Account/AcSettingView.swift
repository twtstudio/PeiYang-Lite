//
//  AcSettingView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/7.
//

import SwiftUI

struct AcSettingView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var sharedMessage: SharedMessage
    @State var isNightKitty = false
    @State var isRemindBeforeClass = false
    let remindTimes = ["15分钟", "30分钟", "45分钟", "60分钟"]
    @State private var remindTime = 0
    
    
    
    @AppStorage(SharedMessage.isShowFullCourseKey, store: Storage.defaults) private var showFullCourse = true
    @AppStorage(ClassesManager.isGPAStoreKey, store: Storage.defaults) private var isNotShowGPA = false
    @AppStorage(SharedMessage.showCourseNumKey, store: Storage.defaults) private var showCourseNum = 5
    
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
               
                StToggleView(title: "首页不显示GPA", caption: nil, isOn: $isNotShowGPA)
                
                StToggleView(title: "开启夜猫子模式", caption: "晚上9:00以后首页课表将展示第二天课程安排", isOn: $isNightKitty)
                
    //MARK: the second section
                HeaderView(headerName: "课程表")
                    .padding(.top)
                
                NavigationLink(
                    destination: AcSetShowDayView(),
                    label: {
                        StListView(title: "每周显示天数", caption: String(showCourseNum + 1))
                    })
                
                StToggleView(title: "课表显示非本周课程", caption: "课表中将会显示当周并未开课的课程", isOn: $showFullCourse)
              
                
                VStack(spacing: 0){
                    Toggle(isOn: $isRemindBeforeClass) {
                        HStack{
                            Text("课前提醒")
                                .foregroundColor(Color.init(red: 98/255, green: 103/255, blue: 122/255))
                        }
                    }
                        .toggleStyle(SwitchToggleStyle(tint: Color.init(red: 105/255, green: 109/255, blue: 127/255)))
                        .padding()
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 15, alignment: .center)
                        .background(Color.white)
                        .cornerRadius(UIScreen.main.bounds.height / 60, corners: .topLeft)
                        .cornerRadius(UIScreen.main.bounds.height / 60, corners: .topRight)
                        .cornerRadius(isRemindBeforeClass ? 0 : UIScreen.main.bounds.height / 60, corners: .bottomLeft)
                        .animation(.easeInOut)
                        .cornerRadius(isRemindBeforeClass ? 0 : UIScreen.main.bounds.height / 60, corners: .bottomRight)
                        .animation(.easeInOut)
                    Color.init(red: 172/255, green: 174/255, blue: 186/255)
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: 1, alignment: .center)
                        .opacity(isRemindBeforeClass ? 0.8 : 0)
                        .animation(.easeInOut)
                   
                    HStack{
                        Text("课前提醒时间")
                            .foregroundColor(Color.init(red: 98/255, green: 103/255, blue: 122/255))
                        Spacer()
                        Picker(remindTimes[remindTime], selection: $remindTime) {
                            ForEach(0 ..< remindTimes.count) {
                                Text(remindTimes[$0])
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .foregroundColor(Color.init(red: 205/255, green: 206/255, blue: 212/255))
                        .font(.caption)
                        .animation(.none)
                    }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .frame(width: UIScreen.main.bounds.width * 0.9)
                        .background(Color.white)
                        .cornerRadius(UIScreen.main.bounds.height / 60, corners: .bottomLeft)
                        .cornerRadius(UIScreen.main.bounds.height / 60, corners: .bottomRight)
                        .opacity(isRemindBeforeClass ? 1 : 0)
                        .animation(.easeInOut)
                    
                   
                    
                   
                }//: VSTACK the last cell
                
             
            }

        }
        .navigationBarHidden(true)
        .background(Color.init(red: 247/255, green: 247/255, blue: 248/255).ignoresSafeArea().frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
        )
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        AcSettingView()
            .environmentObject(SharedMessage())
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
        .frame(width: UIScreen.main.bounds.width * 0.9)
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
        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 15, alignment: .center)
        .background(Color.white)
        .cornerRadius(UIScreen.main.bounds.height / 60)
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
        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 15, alignment: .center)
        .background(Color.white)
        .cornerRadius(UIScreen.main.bounds.height / 60)
    }
}
