//
//  ECardDailyAmountView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/27/20.
//

import SwiftUI

struct ECardDailyAmountView: View {
    let dailyAmountArray: [DailyAmount]
    
    @Binding var activeDailyAmountIndex: Int
    @Binding var showDailyAmount: Bool
    
    let geo: GeometryProxy
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("date: \(dailyAmountArray[activeDailyAmountIndex].formatDate)")
                    Text("amount: \(dailyAmountArray[activeDailyAmountIndex].amount.decimal)")
                }
                .opacity(showDailyAmount ? 1 : 0)
            }
            
            GeometryReader { geo in
                CurveCardView(
                    data: ChartData(points: dailyAmountArray.map(\.amount)),
                    size: .constant(geo.size),
                    minDataValue: .constant(nil),
                    maxDataValue: .constant(nil),
                    activeIndex: $activeDailyAmountIndex,
                    showIndicator: $showDailyAmount,
                    pathGradient: Gradient(colors: [Color(#colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)), Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))]),
                    indicatorColor: Color(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1))
                )
            }
            .frame(width: geo.size.width * 0.9, height: geo.size.width * 0.45)
        }
        .padding(.vertical)
    }
}

struct ECardDailyAmountView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            GeometryReader { geo in
                ECardDailyAmountView(
                    dailyAmountArray: [DailyAmount](),
                    activeDailyAmountIndex: .constant(-1),
                    showDailyAmount: .constant(false),
                    geo: geo
                )
            }
            .environment(\.colorScheme, .dark)
        }
    }
}
