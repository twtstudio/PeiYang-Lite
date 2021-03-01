//
//  GPACellListView.swift
//  PeiYang Lite
//
//  Created by 游奕桁 on 2020/11/2.
//

import SwiftUI

struct GPACellListView: View {
    let activeSemesterGPA: SemesterGPA
    var body: some View {
        VStack {
            ForEach(activeSemesterGPA.gpaArray, id: \.no) { singleGPA in
                HStack {
                    Image(systemName: "book.fill")
                        .font(.title)
                        .foregroundColor(Color(#colorLiteral(red: 0.6932368875, green: 0.7368911505, blue: 0.5718635321, alpha: 1)))
                        .padding(10)
                    VStack(alignment: .leading) {
                        Text(singleGPA.name)
                            .font(.body)
                            .foregroundColor(.white)
                            .padding(.bottom, 2)
                        Text("\(singleGPA.credit.decimal) credits")
                            .font(.footnote)
                            .foregroundColor(Color(#colorLiteral(red: 0.6932368875, green: 0.7368911505, blue: 0.5718635321, alpha: 1)))
                    }
                    .padding(5)
                    
                    Spacer()
                    
                    Text(singleGPA.score.decimal)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.trailing, 10)
                }
                .frame(width: screen.width - 40, height: screen.width/5)
                .background(Color(#colorLiteral(red: 0.5362423062, green: 0.5800756216, blue: 0.4005104303, alpha: 1)))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding()
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
