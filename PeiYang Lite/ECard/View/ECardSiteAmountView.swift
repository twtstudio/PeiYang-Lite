//
//  ECardSiteAmountView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/27/20.
//

import SwiftUI

struct ECardSiteAmountView: View {
    let siteAmountArray: [SiteAmount]
    var totalAmount: Double {
        siteAmountArray.map(\.amount).reduce(0, +)
    }
    
    @Binding var activeSiteAmountIndex: Int
    @Binding var showSiteAmount: Bool
    
    let geo: GeometryProxy
    
    var body: some View {
        HStack {
            PieChartView(
                activeIndex: $activeSiteAmountIndex,
                show: $showSiteAmount,
                data: siteAmountArray.map(\.amount),
                backgroundColor: .background,
                accentColor: Color(#colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)),
                activeColor: Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
            )
            .frame(width: geo.size.width * 0.5, height: geo.size.width * 0.5)
            
            Spacer()
            
            
            VStack(alignment: .trailing) {
                if activeSiteAmountIndex != -1 {
                    VStack(alignment: .leading) {
                        Text("site: \(siteAmountArray[activeSiteAmountIndex].name)")
                        Text("amount: \(siteAmountArray[activeSiteAmountIndex].amount.decimal)")
                    }
                    .opacity(showSiteAmount ? 1 : 0)
                }
                    
                Spacer()
                
                Text("totalAmount: \(totalAmount.decimal)")
                    .font(.title)
            }
        }
        .padding(.vertical)
    }
}

struct ECardSiteAmountView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            GeometryReader { geo in
                ECardSiteAmountView(
                    siteAmountArray: [SiteAmount](),
                    activeSiteAmountIndex: .constant(-1),
                    showSiteAmount: .constant(false),
                    geo: geo
                )
            }
            .environment(\.colorScheme, .dark)
        }
    }
}
