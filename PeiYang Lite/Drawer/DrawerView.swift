//
//  DrawerView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/18.
//

import SwiftUI

struct DrawerView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var body: some View {
        
        VStack(spacing: UIScreen.main.bounds.width / 10) {
            HStack {
                NavigationLink(
                    destination: CourseTableDetailView(alertCourse: AlertCourse()),
                    label: {
                        DrawerCellView(imgName: "drawer-course", title: "课程表")
                    })
                Spacer()
                NavigationLink(
                    destination:  GPADetailView(),
                    label: {
                        DrawerCellView(imgName: "drawer-GPA", title: "GPA")
                    })
            }
            .frame(width: UIScreen.main.bounds.width * 0.8)
            HStack {
                DrawerCellView(imgName: "drawer-phone", title: "黄页")
                Spacer()
                NavigationLink(
                    destination: StyTopView(),
                    label: {
                        DrawerCellView(imgName: "drawer-building", title: "自习室")
                    })
                
            }
            .frame(width: UIScreen.main.bounds.width * 0.8)
//            HStack {
//                NavigationLink(
//                    destination: SchView(),
//                    label: {
//                        DrawerCellView(imgName: "drawer-business", title: "校务专区")
//                    })
//
//                Spacer()
//            }
//            .frame(width: UIScreen.main.bounds.width * 0.8)
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(Color(#colorLiteral(red: 0.9352087975, green: 0.9502342343, blue: 0.9600060582, alpha: 1)).ignoresSafeArea())
        
        
    }
}

struct DrawerView_Previews: PreviewProvider {
    static var previews: some View {
        DrawerView()
    }
}

fileprivate struct DrawerCellView: View {
    let themeColor = Color.init(red: 98/255, green: 103/255, blue: 123/255)
    var imgName: String
    var title: String
    var body: some View {
        VStack{
            Image(imgName)
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width / 15, height: UIScreen.main.bounds.width / 15)
            Text(title)
                .foregroundColor(themeColor)
                .font(.custom("HelveticaNeue-Bold", size: UIScreen.main.bounds.height/50))
        }
        .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 4)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: themeColor.opacity(0.3), radius: 10, x: 0.0, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
    }
}
