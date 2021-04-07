//
//  AcChangeColorView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/3/12.
//

import SwiftUI

struct AcChangeColorView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @AppStorage(SharedMessage.GPABackgroundColorKey, store: Storage.defaults) private var gpaBackgroundColor = 0x7f8b59
    @AppStorage(SharedMessage.GPATextColorKey, store: Storage.defaults) private var gpaTextColor = 0xFFFFFF
    
    var body: some View {
        VStack(alignment: .center, spacing: 15){
            NavigationBar()
            HStack(alignment: .bottom){
                Text("调色板")
                    .font(.custom("Avenir-Black", size: screen.height / 35))
                    .foregroundColor(.init(red: 48/255, green: 60/255, blue: 102/255))
                    
                Spacer()
            }
            .frame(width: screen.width * 0.9)
            .padding(.bottom)
            HStack{
                Text("给课表、GPA选择喜欢的颜色。")
                    .font(.caption)
                    .foregroundColor(.init(red: 98/255, green: 103/255, blue: 124/255))
                    .padding(.bottom)
                Spacer()
            }
            .frame(width: screen.width * 0.9)
            
            HStack{
                Text("GPA")
                    .fontWeight(.heavy)
                    .foregroundColor(.init(red: 177/255, green: 180/255, blue: 186/255))
                Spacer()
            }
            .frame(width: screen.width * 0.9)
            
            VStack(spacing: 10) {
                //MARK: GPA's Color
                Button(action: {
                    changeColorHex(background: 0x7f8b59, text: 0xFFFFFF)
                }, label: {
                    Text("#7f8b59"+(gpaTextColor == 0xFFFFFF ? "(已选)" : ""))
                        .foregroundColor(.init(hex: 0xFFFFFF))
                        .frame(width: screen.width * 0.9, height: screen.height / 15)
                        .background(Color.init(hex: 0x7f8b59))
                        .cornerRadius(10)
                })
                
                Button(action: {
                    changeColorHex(background: 0xEEEDED, text: 0x9D7B83)
                }, label: {
                    Text("#9d7b83"+(gpaTextColor == 0x9D7B83 ? "(已选)" : ""))
                        .foregroundColor(.init(hex: 0x9D7B83))
                        .frame(width: screen.width * 0.9, height: screen.height / 15)
                        .background(Color.init(hex: 0xEEEDED))
                        .cornerRadius(10)
                })
                
                Button(action: {
                    changeColorHex(background: 0xAD8D92, text: 0xF7F7F8)
                }, label: {
                    Text("#ad8d92"+(gpaTextColor == 0xF7F7F8 ? "(已选)" : ""))
                        .foregroundColor(.init(hex: 0xF7F7F8))
                        .frame(width: screen.width * 0.9, height: screen.height / 15)
                        .background(Color.init(hex: 0xAD8D92))
                        .cornerRadius(10)
                })
                
                Button(action: {
                    changeColorHex(background: 0x47535F, text: 0xCEC6B9)
                }, label: {
                    Text("#47535f"+(gpaTextColor == 0xCEC6B9 ? "(已选)" : ""))
                        .foregroundColor(.init(hex: 0xCEC6B9))
                        .frame(width: screen.width * 0.9, height: screen.height / 15)
                        .background(Color.init(hexString: "47535f"))
                        .cornerRadius(10)
                })
            }
            .frame(width: screen.width * 0.9)
            .padding(.horizontal)
            
            HStack{
                Text("课程表")
                    .fontWeight(.heavy)
                    .foregroundColor(.init(red: 177/255, green: 180/255, blue: 186/255))
                Spacer()
            }
            .frame(width: screen.width * 0.9)
            
            VStack(spacing: 10) {
                //MARK: CourseTable's Color
                Button(action: {}, label: {
                    Text("blue ashes")
                        .foregroundColor(.white)
                        .frame(width: screen.width * 0.9, height: screen.height / 15)
                        .background(Color.init(red: 113/255, green: 118/255, blue: 137/255))
                        .cornerRadius(10)
                })
                
                Button(action: {}, label: {
                    Text("sap green")
                        .foregroundColor(.white)
                        .frame(width: screen.width * 0.9, height: screen.height / 15)
                        .background(Color.init(red: 83/255, green: 89/255, blue: 78/255))
                        .cornerRadius(10)
                })
                
                Button(action: {}, label: {
                    Text("earth yellow")
                        .foregroundColor(.white)
                        .frame(width: screen.width * 0.9, height: screen.height / 15)
                        .background(Color.init(red: 196/255, green: 148/255, blue: 125/255))
                        .cornerRadius(10)
                })
            }
            .padding(.horizontal)
            .frame(width: screen.width * 0.9)
            
            Spacer()
        }
        .addAnalytics(className: "ColorChangeView")
        .navigationBarHidden(true)
        
    }
    
    private func changeColorHex(background: Int, text: Int) {
        gpaBackgroundColor = background
        gpaTextColor = text
    }
}

struct AcChangeColorView_Previews: PreviewProvider {
    static var previews: some View {
        AcChangeColorView()
    }
}

extension Color {
    init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        self.init(
            .sRGB,
            red: components.R,
            green: components.G,
            blue: components.B,
            opacity: alpha
        )
    }
}

extension Color {
    init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
