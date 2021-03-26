//
//  AcMessageView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/6.
//
import SwiftUI

struct AcMessageView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var sharedMessage: SharedMessage
    @AppStorage(ClassesManager.isLoginKey, store: Storage.defaults) private var isLogin = false
    
    let themeColor = Color.init(red: 98/255, green: 103/255, blue: 122/255)
    let captionColor = Color.init(red: 205/255, green: 206/255, blue: 212/255)
    
    
    // Alert var
    @State private var AlertMessage: String = "网络出现问题"
    @State private var isShowAlert: Bool = false
    @State private var alertTimer: Timer?
    @State private var alertTime = 2
    
    /// fix the deselect prob. T_T
    @State private var selectedItem: String?
    @State private var listViewId = UUID()
    
    init() {
        UITableView.appearance().backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        UIScrollView.appearance().isScrollEnabled = false
    }
    
    var body: some View {
        VStack {
            NavigationBar(center: {Text("个人信息更改")})
            Form {
                Section() {
                    Button(action:{
                        print("Todo")
                    }){
                        HStack{
                            Text("头像")
                                .foregroundColor(themeColor)
                            Spacer()
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: screen.height / 25, height: screen.height / 25, alignment: .center)
                                .foregroundColor(themeColor)
                                .cornerRadius(screen.height / 50)
                        }
                        .frame(height: screen.height / 15, alignment: .center)
                    }
                    
                    NavigationLink(
                        destination: AcChangeNameView(),
                        tag: "0",
                        selection: $selectedItem,
                        label: {
                            AcListView(title: "用户名", caption: sharedMessage.Account.nickname)
                        })
                    
                    NavigationLink(destination: AcClassesBindingView(),
                                   tag: "1",
                                   selection: $selectedItem){
                        AcListView(title: "办公网", caption: isLogin ? "已绑定" : "未绑定")
                    }
                }
                
                Section() {
                    NavigationLink(destination: AcBindPhoneView(),
                                   tag: "2",
                                   selection: $selectedItem){
                        AcListView2(img: "phone", title: "电话", caption: sharedMessage.isBindPh ? "已绑定" : "未绑定")
                    }
                    
                    NavigationLink(destination: AcBindEmailView(),
                                   tag: "3",
                                   selection: $selectedItem){
                        AcListView2(img: "email", title: "邮箱", caption: sharedMessage.isBindEm ? "已绑定" : "未绑定")
                    }
                    
                }
            }
            .environment(\.horizontalSizeClass, .regular)
            .id(listViewId)
            .onAppear {
                if selectedItem != nil {
                    selectedItem = nil
                    listViewId = UUID()
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear(perform: {
            if(sharedMessage.Account.email != nil) {
                sharedMessage.isBindEm = true
            }
            if(sharedMessage.Account.telephone != nil) {
                sharedMessage.isBindPh = true
            }
        })
        .addAnalytics(className: "AccountChangeView")
    }
}

struct AcMessageView_Previews: PreviewProvider {
    static var previews: some View {
        AcMessageView()
            .environmentObject(SharedMessage())
    }
}

fileprivate struct AcListView: View {
    let themeColor = Color.init(red: 98/255, green: 103/255, blue: 122/255)
    let captionColor = Color.init(red: 205/255, green: 206/255, blue: 212/255)
    var title: String
    var caption: String
    var body: some View {
        HStack{
            Text(title)
                .foregroundColor(themeColor)
            Spacer()
            Text(caption)
                .font(.caption)
                .foregroundColor(captionColor)
            
            
        }
        .frame(height: screen.height / 15, alignment: .center)
    }
}

fileprivate struct AcListView2: View {
    let themeColor = Color.init(red: 98/255, green: 103/255, blue: 122/255)
    let captionColor = Color.init(red: 205/255, green: 206/255, blue: 212/255)
    var img: String
    var title: String
    var caption: String
    var body: some View {
        HStack{
            Image(img)
            Text(title)
                .foregroundColor(themeColor)
            Spacer()
            Text(caption)
                .font(.caption)
                .foregroundColor(captionColor)
            
        }
        .frame(height: screen.height / 15, alignment: .center)
    }
}



