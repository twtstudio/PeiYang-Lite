//
//  ECardtransactionView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/27/20.
//

import SwiftUI

struct ECardtransactionView: View {
    let transactionArray: [Transaction]
    
    var body: some View {
        ForEach(transactionArray, id: \.time) { transaction in
            HStack {
                VStack(alignment: .leading) {
                    Text(transaction.device)
                    
                    Text(transaction.dateTime)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(transaction.signedAmount)
                    .font(.title)
                    .foregroundColor(transaction.qtype == "1" ? .red : .green)
            }
        }
    }
}

struct ECardtransactionView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            ECardtransactionView(transactionArray: [Transaction]())
                .environment(\.colorScheme, .dark)
        }
    }
}
