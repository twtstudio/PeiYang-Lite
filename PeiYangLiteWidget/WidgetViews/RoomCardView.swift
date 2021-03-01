//
//  RoomCardView.swift
//  PeiYangLiteWidgetExtension
//
//  Created by 游奕桁 on 2021/1/29.
//

import SwiftUI

struct RoomCardView: View {
    var body: some View {
        ZStack {
            Image("空闲背景")
            
            VStack {
                Text("46教\nA108")
                    .font(.system(size: 10))
                    .foregroundColor(Color(#colorLiteral(red: 0.1279886365, green: 0.1797681153, blue: 0.2823780477, alpha: 1)))
                    .padding(.bottom, 10)
                
                Text("空闲")
                    .font(.footnote)
                    .bold()
                    .foregroundColor(Color(#colorLiteral(red: 0.1279886365, green: 0.1797681153, blue: 0.2823780477, alpha: 1)))
            }
        }
    }
}

//struct RoomCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        RoomCardView()
//    }
//}
