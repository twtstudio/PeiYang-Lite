//
//  GPACellListView.swift
//  PeiYang Lite
//
//  Created by 游奕桁 on 2020/11/2.
//

import SwiftUI

struct GPACellListView: View {
    let activeSemesterGPA: SemesterGPA
    @AppStorage(SharedMessage.GPABackgroundColorKey, store: Storage.defaults) private var gpaBackgroundColor = 0x7f8b59
    @AppStorage(SharedMessage.GPATextColorKey, store: Storage.defaults) private var gpaTextColor = 0xFFFFFF
    var body: some View {
        VStack {
            ForEach(activeSemesterGPA.gpaArray.indices, id: \.self) { i in
                let singleGPA = activeSemesterGPA.gpaArray[i]
                HStack {
                    Image(systemName: "book.fill")
                        .font(.title)
                        .foregroundColor(Color.init(hex: gpaTextColor).opacity(0.7))
                        .padding(10)
                    VStack(alignment: .leading) {
                        Text(singleGPA.name)
                            .font(.body)
                            .foregroundColor(Color.init(hex: gpaTextColor).opacity(0.7))
                            .padding(.bottom, 2)
                        Text("\(singleGPA.credit.decimal) credits")
                            .font(.footnote)
                            .foregroundColor(Color.init(hex: gpaTextColor).opacity(0.7))
                    }
                    .padding(5)
                    
                    Spacer()
                    
                    Text(singleGPA.score.decimal == 0.description ? singleGPA.scoreProperty : singleGPA.score.decimal)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.init(hex: gpaTextColor).opacity(0.7))
                        .padding(.trailing, 10)
                }
                .frame(width: screen.width - 40, height: screen.width/5)
                .background(Color.init(hex: gpaTextColor).opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(8)
            }
        }
        .frame(maxHeight: .infinity)
    }
}

struct GPACellListView_Previews: PreviewProvider {
    static var previews: some View {
        GPACellListView(activeSemesterGPA: SemesterGPA())
    }
}
