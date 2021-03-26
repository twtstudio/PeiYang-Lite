//
//  ECardCardView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/26/20.
//

import SwiftUI

struct ECardCardView: View {
    @ObservedObject var store = Storage.ecard
    private var overview: ECardOverview { store.object.overview }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text(Localizable.ecard.rawValue)
                    .font(.title)
                
                Spacer()
                
                Text(overview.state)
                    .font(.subheadline)
                    .foregroundColor(overview.state == "正常" ? .green : .red)
            }
            
            Text("balance: \(overview.balance)")
                .font(.largeTitle)
                .bold()
                .frame(maxHeight: .infinity)
            
            Text("ecardNO: \(overview.no)")
                .foregroundColor(.secondary)
        }
    }
}

struct ECardCardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            GeometryReader{ geometry in
                ECardCardView()
            }
            .frame(width: 300, height: 180)
            .environment(\.colorScheme, .dark)
        }
    }
}
