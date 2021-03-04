//
//  SchView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/23.
//

import SwiftUI

struct SchView: View {
    @Environment(\.presentationMode) var mode
    @State private var isRefreshing: Bool = false
    @State var Array = ["1111","1111","1111","1111","1111","1111","1111"]
    
    private var refreshListener: some View {
        // 一个任意视图，我们将把它添置在滚动列表的尾部
        Color.black
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.1)
            .ignoresSafeArea()// height: 如果有加载动画就设置，没有设置为0就可以
            .onAppear(perform: {
                Array.append("222")
            })
    }
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    NavigationLink(
                        destination: SchSearchTableView(),
                        label: {
                            SchSearchView()
                        })
                    Spacer()
                    NavigationLink(
                        destination: SchAccountView(),
                        label: {
                            Image("SchAccount")
                        })
                    
                }
                .frame(width: UIScreen.main.bounds.width * 0.9)
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 10) {
                        SchQuestionCellView(title: "微北洋课表是不是出问题了？", bodyText: "同学您好。IOS应用商店、安卓平台华为、小米、应用宝等应用商店均已上线新版微北洋，请更新后使", likes: "123", comments: "123", date: "2019-01-30   23：33", imgName: "Text", isSettled: true)
                        
                        SchQuestionCellView(title: "微北洋课表是不是出问题了？", bodyText: "同学您好。IOS应用商店、安卓平台华为、小米、应用宝等应用商店均已上线新版微北洋，请更新后使", likes: "123", comments: "123", date: "2019-01-30   23：33", isSettled: true)
                        
                        SchQuestionCellView(title: "微北洋课表是不是出问题了？", bodyText: "不知道", likes: "123", comments: "123", date: "2019-01-30   23：33", isSettled: false)
                        SchQuestionCellView(title: "微北洋课表是不是出问题了？", bodyText: "不知道", likes: "123", comments: "123", date: "2019-01-30   23：33", isSettled: false)
                    }
                    .ignoresSafeArea(edges: .all)
                    
                }
                
                .padding()
                .frame(width: UIScreen.main.bounds.width)
                Spacer()
            }
            .ignoresSafeArea(edges: .bottom)
            .background(
                Color.init(red: 247/255, green: 247/255, blue: 248/255).ignoresSafeArea().frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
            )
            .navigationBarHidden(true)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink(
                        destination: SchNewQuestionView(),
                        label: {
                            Image("SchAdd")
                                .resizable()
                                .frame(width: screen.width * 0.2, height: screen.width * 0.2)
                        })
                    
                }
                .padding()
            }
            .frame(height: UIScreen.main.bounds.height * 0.8)
        }
        
    }
}

struct SchView_Previews: PreviewProvider {
    static var previews: some View {
        SchView()
    }
}

struct SchSearchView: View {
    var body: some View {
        HStack {
            Image("search")
            Text("搜索问题...").foregroundColor(.init(red: 207/255, green: 208/255, blue: 213/255))
            Spacer()
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height / 20, alignment: .center)
        .background(Color.init(red: 236/255, green: 237/255, blue: 239/255))
        .cornerRadius(UIScreen.main.bounds.height / 40)
    }
}
