//
//  UpdateView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/3/25.
//

import SwiftUI

struct UpdateView: View {
    @Binding var showUpdateView: Bool
    
    var updateTitle: String
    let FontColor = Color.init(red: 79/255, green: 88/255, blue: 107/255)
    var body: some View {
        ZStack {
            Image("UpdateIcon")
                .resizable()
                .scaledToFit()
                .frame(width: screen.width * 0.2)
            
            VStack(spacing: 15){
                Text("版本更新")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(FontColor)
                Text(updateTitle)
                    .font(.body)
                    .foregroundColor(FontColor)
                    .frame(width: screen.width * 0.5)
                Color.init(red: 172/255, green: 174/255, blue: 186/255)
                    .frame(width: screen.width * 0.5, height: 1, alignment: .center)
                Button(action: {
                    let appid = String(1542905353)
                    let updateUrl:URL = URL(string: "itms-apps://itunes.apple.com/app/id" + appid)!
                    UIApplication.shared.open(updateUrl, options: [:], completionHandler: nil)
                }, label: {
                    Text("点击更新")
                        .font(.headline)
                        .foregroundColor(FontColor)
                })
            }
            
            VStack{
                HStack{
                    Spacer()
                    Button(action: {
                        showUpdateView = false
                    }, label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                            .font(.title2)
                    })
                }
                Spacer()
            }
        }
        .frame(width: screen.width * 0.7, height: screen.height * 0.3, alignment: .center)
        .padding()
        .background(Color.white)
        .cornerRadius(15)
    }
}

struct UpdateView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            UpdateView(showUpdateView: .constant(true), updateTitle: "更新内容：\n1.修复已知问题，提升稳定性\n2.提升稳定性\n3.修复已知问题\n版本：V6.13.2→V4.0")
        }
       
    }
}

fileprivate struct ShowUpdateViewModifier: ViewModifier {
    @Binding var showUpdateView: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if showUpdateView {
                BlurView()
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            showUpdateView = false
                        }
                    }
                UpdateView(showUpdateView: $showUpdateView, updateTitle: "更新内容：\n1.修复已知问题，提升稳定性\n2.提升稳定性\n3.修复已知问题\n版本：V6.13.2→V4.0")
            }
        }
    }
}

extension View {
    func showUpdateView(_ showUpdateView: Binding<Bool>) -> some View {
        self.modifier(ShowUpdateViewModifier(showUpdateView: showUpdateView))
    }
}
