//
//  RoomCardView.swift
//  PeiYangLiteWidgetExtension
//
//  Created by 游奕桁 on 2021/1/29.
//

import SwiftUI

struct RoomCardView: View {
    var buildingName: String
    var className: String
    var isFree: Bool
    var body: some View {
            VStack {
                Text("\(buildingName)\n\(className)")
                    .font(.system(size: 10))
                    .foregroundColor(Color(#colorLiteral(red: 0.1279886365, green: 0.1797681153, blue: 0.2823780477, alpha: 1)))
                    .padding(.bottom, 10)
                
                Text(isFree ? "空闲" : "占用")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(isFree ? Color(#colorLiteral(red: 0.1279886365, green: 0.1797681153, blue: 0.2823780477, alpha: 1)) : Color(#colorLiteral(red: 0.8519811034, green: 0.8703891039, blue: 0.9223362803, alpha: 1)))
            }
//        }
    }
}

//struct RoomCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        RoomCardView()
//    }
//}
