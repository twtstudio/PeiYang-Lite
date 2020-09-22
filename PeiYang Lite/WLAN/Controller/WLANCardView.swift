//
//  WLANCardView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 8/7/20.
//

import SwiftUI

struct WLANCardView: View {
    @ObservedObject var store = Storage.wlan
    private var overview: WLANOverview { store.object.overview }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text(Localizable.wlan.rawValue)
                    .font(.title2)
                
                Spacer()
                
                Text(overview.state)
                    .font(.subheadline)
                    .foregroundColor(overview.state == "正常" ? .green : .red)
            }
            
            Spacer()
            
            Text("availableTraffic: \(overview.traffic)")
                .font(.title)
                .bold()
                .frame(maxHeight: .infinity)
            
            Text("balance: \(overview.balance)")
                .foregroundColor(.secondary)
        }
    }
}

struct WLANCardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            GeometryReader{ geometry in
                WLANCardView()
            }
            .frame(width: 300, height: 180)
            .environment(\.colorScheme, .dark)
        }
    }
}
