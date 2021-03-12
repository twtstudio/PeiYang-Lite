//
//  AcChangeColorView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/3/12.
//

import SwiftUI

struct AcChangeColorView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack{
            HStack(alignment: .bottom){
                Text("调色板")
                    .font(.custom("Avenir-Black", size: UIScreen.main.bounds.height / 35))
                    .foregroundColor(.init(red: 48/255, green: 60/255, blue: 102/255))
                Spacer()
            }
        }
        .frame(width: screen.width * 0.9)
    }
}

struct AcChangeColorView_Previews: PreviewProvider {
    static var previews: some View {
        AcChangeColorView()
    }
}
