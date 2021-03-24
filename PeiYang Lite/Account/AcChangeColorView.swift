//
//  AcChangeColorView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/3/12.
//

import SwiftUI

struct AcChangeColorView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack(alignment: .center, spacing: 15){
            NavigationBar()
            HStack(alignment: .bottom){
                Text("调色板")
                    .font(.custom("Avenir-Black", size: UIScreen.main.bounds.height / 35))
                    .foregroundColor(.init(red: 48/255, green: 60/255, blue: 102/255))
                Spacer()
            }
            .frame(width: screen.width * 0.9)
            .padding(.bottom)
            HStack{
                Text("给课表、GPA选择喜欢的颜色。")
                    .font(.caption)
                    .foregroundColor(.init(red: 98/255, green: 103/255, blue: 124/255))
                    .padding(.bottom)
                Spacer()
            }
            .frame(width: screen.width * 0.9)
            
            HStack{
                Text("GPA")
                    .fontWeight(.heavy)
                    .foregroundColor(.init(red: 177/255, green: 180/255, blue: 186/255))
                Spacer()
            }
            .frame(width: screen.width * 0.9)
            
            VStack(spacing: 10) {
                //MARK: GPA's Color
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("#7f8b59")
                        .foregroundColor(.white)
                        .frame(width: screen.width * 0.9, height: screen.height / 15)
                        .background(Color.init(red: 127/255, green: 139/255, blue: 89/255))
                        .cornerRadius(10)
                })
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("#9d7b83")
                        .foregroundColor(.init(red: 157/255, green: 123/255, blue: 131/255))
                        .frame(width: screen.width * 0.9, height: screen.height / 15)
                        .background(Color.init(red: 238/255, green: 237/255, blue: 237/255))
                        .cornerRadius(10)
                })
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("#47535f")
                        .foregroundColor(.init(red: 247/255, green: 247/255, blue: 248/255))
                        .frame(width: screen.width * 0.9, height: screen.height / 15)
                        .background(Color.init(red: 173/255, green: 141/255, blue: 146/255))
                        .cornerRadius(10)
                })
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("#7f8b59")
                        .foregroundColor(.init(red: 206/255, green: 198/255, blue: 185/255))
                        .frame(width: screen.width * 0.9, height: screen.height / 15)
                        .background(Color.init(red: 71/255, green: 83/255, blue: 95/255))
                        .cornerRadius(10)
                })
            }
            .frame(width: screen.width * 0.9)
            .padding(.horizontal)
            
            HStack{
                Text("课程表")
                    .fontWeight(.heavy)
                    .foregroundColor(.init(red: 177/255, green: 180/255, blue: 186/255))
                Spacer()
            }
            .frame(width: screen.width * 0.9)
            
            VStack(spacing: 10) {
                //MARK: CourseTable's Color
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("blue ashes")
                        .foregroundColor(.white)
                        .frame(width: screen.width * 0.9, height: screen.height / 15)
                        .background(Color.init(red: 113/255, green: 118/255, blue: 137/255))
                        .cornerRadius(10)
                })
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("sap green")
                        .foregroundColor(.white)
                        .frame(width: screen.width * 0.9, height: screen.height / 15)
                        .background(Color.init(red: 83/255, green: 89/255, blue: 78/255))
                        .cornerRadius(10)
                })
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("earth yellow")
                        .foregroundColor(.white)
                        .frame(width: screen.width * 0.9, height: screen.height / 15)
                        .background(Color.init(red: 196/255, green: 148/255, blue: 125/255))
                        .cornerRadius(10)
                })
            }
            .padding(.horizontal)
            .frame(width: screen.width * 0.9)
            
            Spacer()
        }
        .onAppear(perform: {
            UMAnalyticsSwift.beginLogPageView(pageName: "ColorChangeView")
        })
        .onDisappear(perform: {
            UMAnalyticsSwift.endLogPageView(pageName: "ColorChangeView")
        })
        .navigationBarHidden(true)
        
    }
}

struct AcChangeColorView_Previews: PreviewProvider {
    static var previews: some View {
        AcChangeColorView()
    }
}
