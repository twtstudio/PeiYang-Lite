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
    
    @EnvironmentObject var sharedMessage: SharedMessage
    @State var isSelected: Bool = false

    var body: some View {
        Button(action:{
            if !isSelected {
                sharedMessage.studyRoomSelectPeriod.append(timePeriod)
                isSelected = true
            } else {
                sharedMessage.studyRoomSelectPeriod = sharedMessage.studyRoomSelectPeriod.filter{$0 != timePeriod}
                isSelected = false
            }
        }){
            Text(timePeriod)
                .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height/20, alignment: .center)
                .foregroundColor((isSelected) ? .white : themeColor)
                .background((isSelected) ? themeColor : .white)
                .cornerRadius(UIScreen.main.bounds.height/40)
                .overlay(
                    RoundedRectangle(cornerRadius: UIScreen.main.bounds.height/40)
                        .stroke(Color.black, lineWidth: 1)
                )
            
        }
        .onAppear(perform: {
            for period in sharedMessage.studyRoomSelectPeriod {
                if timePeriod == period {
                    isSelected = true
                }
            }
        })
        
    }
}
struct TimeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        TimeSelectionView(timePeriod: "11:00")
            .environmentObject(SharedMessage())
    }
}

