//
//  ECardOverviewView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/27/20.
//

import SwiftUI

struct ECardOverviewView: View {
    let overview: ECardOverview
    
    var body: some View {
        HStack(alignment: .top) {
            Text(Localizable.ecard.rawValue)
                .font(.title)
            
            Spacer()
            
            Text(overview.state)
                .font(.subheadline)
                .foregroundColor(overview.state == "正常" ? .green : .red)
        }
        .padding(.bottom)
        
        HStack {
            Text("balance: \(overview.balance)")
                .font(.largeTitle)
                .bold()
            
            Spacer()
            
            Text("subsidy: \(overview.subsidy)")
                .bold()
        }
        .padding(.vertical)
        
        HStack(alignment: .bottom) {
            Text("ecardNO: \(overview.no)")
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text("expire: \(overview.expire)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical)
    }
}

struct ECardOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            ECardOverviewView(overview: ECardOverview())
                .environment(\.colorScheme, .dark)
        }
    }
}
