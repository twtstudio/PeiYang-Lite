//
//  AcAboutTwTView.swift
//  PeiYang-Lite
//
//  Created by phoenix Dai on 2021/5/27.
//

import SwiftUI

struct AcAboutTwTView: View {
    var body: some View {
        VStack{
            NavigationBar(center: {
                Text("关于天外天")
                    .font(.title2)
            })
            AcWebView(url: URL(string: "https://i.twt.edu.cn/#/about"))
        }
        .edgesIgnoringSafeArea(.bottom)
       
        
    }
}

struct AcAboutTwTView_Previews: PreviewProvider {
    static var previews: some View {
        AcAboutTwTView()
    }
}
