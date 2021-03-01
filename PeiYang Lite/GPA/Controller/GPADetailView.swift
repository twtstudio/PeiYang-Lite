//
//  GPADetailView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/5/20.
//

import SwiftUI

struct GPADetailView: View {
    @ObservedObject var store = Storage.gpa
    private var gpa: GPA { store.object }
    
    @State private var isLoading = false
    
    @State private var activeIndex = -1
    
    @State private var showLogin = false
    
    @State private var isError = false
    @State private var errorMessage: LocalizedStringKey = ""
    
    var body: some View {
        GeometryReader { full in
            VStack {
                // MARK: - Header
                HStack {
                    Text(Localizable.gpa.rawValue)
                        .font(.title)
                    
                    Spacer()
                    
                    RefreshButton(isLoading: $isLoading, action: load)
                }
                
                // MARK: - Chart
                GeometryReader { geo in
                    CurveDetailView(
                        data: ChartData(points: gpa.semesterGPAArray.map(\.score)),
                        size: .constant(CGSize(width: geo.size.width, height: geo.size.width * 0.5)),
                        minDataValue: .constant(nil),
                        maxDataValue: .constant(nil),
                        activeIndex: $activeIndex,
                        showIndicator: .constant(true),
                        pathGradient: Gradient(colors: [Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)), Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1))]),
                        backgroundGradient: Gradient(colors: [Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)), .background]),
                        indicatorColor: Color(#colorLiteral(red: 1, green: 0.3411764706, blue: 0.6509803922, alpha: 1))
                    )
                }
                .padding()
                .frame(width: full.size.width, height: full.size.width * 0.5)
                
                // MARK: - List
                if activeIndex == -1 {
                    HStack {
                        GPATitleView(value: gpa.score.decimal, title: .totalScore)
                        GPATitleView(value: gpa.gpa.decimal, title: .totalGPA)
                        GPATitleView(value: gpa.credit.decimal, title: .totalCredit)
                    }
                } else {
                    GPAListView(activeSemesterGPA: gpa.semesterGPAArray[activeIndex])
                }
            }
            .sheet(isPresented: $showLogin) {
                HomeLoginView(module: .gpa)
            }
            .alert(isPresented: $isError) {
                Alert(title: Text(errorMessage),
                      dismissButton: .default(Text(Localizable.ok.rawValue)))
            }
        }
<<<<<<< HEAD
        .onAppear {
            if !Storage.defaults.bool(forKey: ClassesManager.isGPAStoreKey) {
                load()
            }
        }
=======
        .onAppear(perform: load)
>>>>>>> e4291697b2a03afcf4cfbf314ae8cf47114102d1
    }
    
    func load() {
        isLoading = true
        
        ClassesManager.checkLogin { result in
            switch result {
            case .success:
                return
            case .failure(let error):
                if error == .requestFailed {
                    isError = true
                    errorMessage = error.localizedStringKey
                } else {
                    showLogin = true
                }
            }
        }
        
        ClassesManager.gpaGet { result in
            switch result {
<<<<<<< HEAD
            case .success(_): break
//                store.object = gpa
//                store.save()
=======
            case .success(let gpa):
                store.object = gpa
                store.save()
>>>>>>> e4291697b2a03afcf4cfbf314ae8cf47114102d1
            case .failure(let error):
                print(error)
            }
            isLoading = false
        }
    }
}

struct GPATitleView: View {
    let value: String
    let title: Localizable
    
    var body: some View {
        VStack {
            Text(value)
                .font(.title)
            Text(title.rawValue)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct GPADetailView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            GPADetailView()
                .environment(\.colorScheme, .dark)
        }
    }
}
