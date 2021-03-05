//
//  HomeHeaderView.swift
//  PeiYang Lite
//
//  Created by Zrzz on 2020/12/25.
//

import SwiftUI

struct HomeHeaderView: View {
    var AccountName: String
    @State private var weather = Weather()
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Hello")
                    .font(.title)
                    .fontWeight(.heavy)
                    .padding(.bottom, 5)
                
                HStack {
                    Image(systemName: weather.weatherIconString1)
                    
                    Text(weather.wStatus)
                        .fontWeight(.heavy)
                    
                    Text(weather.weatherString)
                        .fontWeight(.heavy)
                }
                .font(.body)
                
            }
            Spacer()
            Text(AccountName)
                .padding()
            NavigationLink(destination: AcMessageView()) {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            }
            
        }
        .onAppear(perform: loadWeather)
        .foregroundColor(Color(#colorLiteral(red: 0.3803921569, green: 0.3960784314, blue: 0.4862745098, alpha: 1)))
        
    }
    
    private func loadWeather() {
        WeatherManager().weatherGet { (result) in
            switch result {
            case .success(let todayWeather):
                weather = todayWeather
            case .failure(let error):
                weather = Weather()
                print(error)
            }
        }
    }
}

struct HomeHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HomeHeaderView(AccountName: "我是谁？")
    }
}
