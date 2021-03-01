//
//  TimeSelectionView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/1/31.
//

import SwiftUI

struct TimeSelectionView: View {
    let themeColor = Color.init(red: 98/255, green: 103/255, blue: 123/255)
    var timePeriod: String
    
//    @Binding var selectedTimePeriod: String
    @EnvironmentObject var sharedMessage: SharedMessage
//    var isSelected: Bool {
//        if(selectedTimePeriod == timePeriod) {
//            return true
//        } else {
//            return false
//        }
//    }
    var body: some View {
        Button(action:{
            sharedMessage.studyRoomSelectTime = timePeriod
        }){
            ZStack {
                Color.black
                    .frame(width: UIScreen.main.bounds.width * 0.3 + 1, height: UIScreen.main.bounds.height/20 + 1, alignment: .center)
                    .cornerRadius(UIScreen.main.bounds.height/40)
                Text(timePeriod)
                    .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height/20, alignment: .center)
                    .foregroundColor((sharedMessage.studyRoomSelectTime == timePeriod) ? .white : themeColor)
                    .background((sharedMessage.studyRoomSelectTime == timePeriod) ? themeColor : .white)
                    .cornerRadius(UIScreen.main.bounds.height/40)
            }
        }
       
        
    }
}
