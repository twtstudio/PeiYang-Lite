//
//  StudySearchView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/27.
//

import SwiftUI

struct StudySearchView: View {
    let color = Color.init(red: 98/255, green: 103/255, blue: 124/255)
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    // 搜索string和搜索历史
    @State var searchString: String = ""
    @State var studyRoomHistory: [String] = []
    @State var isSearched: Bool = false
    enum method {
        case buildings
        case sections
        case rooms
        case wrong
    }
    @State var selectedMethod = method.buildings
    
    @State var brokenString: [String] = []
    
    var body: some View {
        VStack{
            HStack {
                Button(action: {
                    studyRoomHistory.insert(searchString, at: 0)
                    chooseMethod()
                    isSearched = true
                }, label: {
                    Image("search")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width / 20)
                })
                .disabled(searchString == "")
                TextField("", text: $searchString)
                    .font(.callout)
                    .padding()
                Button(action: {
                    if(searchString == "") {
                        self.mode.wrappedValue.dismiss()
                    } else {
                        searchString = ""
                        isSearched = false
                    }
                }, label: {
                    Text("取消")
                        .fontWeight(.heavy)
                        .foregroundColor(color)
                })
            }
            .frame(height: UIScreen.main.bounds.height / 20)
            Color.gray
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 1, alignment: .center)
                .padding(.top, 0)
            if(!isSearched){
                SchHistorySectionView(searchString: $searchString, searchHistory: $studyRoomHistory)
            }
            ScrollView(.vertical, showsIndicators: false){
                switch selectedMethod {
                case .buildings:
                    Text("building")
                case .sections:
                    SearchBuildingView(title: "45教", section: "A")
                case .rooms:
                    SearchBuildingAndClassView(title: "45教A102", isFree: true)
                case .wrong:
                    Text("ERROR")
                }
               
                
                
                
            }
            .padding(.top)
            
            Spacer()
        }
        .navigationBarHidden(true)
        .frame(width: UIScreen.main.bounds.width * 0.9)
        .background(Color(#colorLiteral(red: 0.9352087975, green: 0.9502342343, blue: 0.9600060582, alpha: 1)).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center).ignoresSafeArea())
        .onDisappear(perform: {
            save()
        })
        .onAppear(perform: {
            load()
        })
        
    }
    
    func save() {
        let queue = DispatchQueue.global()
        queue.async {
            DataStorage.store(studyRoomHistory, in: .caches, as: "studyroom/history.json")
        }
    }
    
    func load() {
        DispatchQueue.global().sync {
            if let saveStudyRoomHistory = DataStorage.retreive("studyroom/history.json", from: .caches, as: [String].self) {
                studyRoomHistory = saveStudyRoomHistory
            }
        }
    }
    
    func chooseMethod() {
        //先看看是否有空格，教，楼
        if (searchString.findString("教") != -1) {
            brokenString = searchString.components(separatedBy: "教")
        }
        else if searchString.findString("楼") != -1 {
            brokenString = searchString.components(separatedBy: "楼")
        }
        else {
            brokenString = searchString.components(separatedBy: " ")
        }

        ///eg: "13教", "13", "13楼" --> buildings
        if (brokenString.count == 1 &&
            brokenString[0].count == 2 &&
            brokenString[0].findString("A") == -1 &&
            brokenString[0].findString("B") == -1 &&
            brokenString[0].findString("C") == -1) {
            selectedMethod = .buildings
        }
        
        /// eg: "13A", "14B" --> sections 
        else if (brokenString.count == 1 &&
            brokenString[0].count == 3 &&
            (brokenString[0].findString("A") != -1 ||
            brokenString[0].findString("B") != -1 ||
            brokenString[0].findString("C") != -1)) {
            selectedMethod = .sections
        }
        /// eg: "313", "413", "102" --> rooms
        else if brokenString.count == 1 &&
                brokenString[0].count == 3 &&
                brokenString[0].findString("A") == -1 &&
                brokenString[0].findString("B") == -1 &&
                brokenString[0].findString("C") == -1{
            selectedMethod = .rooms
        }
        /// eg: "A312", "B312" --> rooms
        else if brokenString.count == 1 &&
                brokenString[0].count == 4 {
            selectedMethod = .rooms
        }
        /// eg: "36楼A", "36 A" --> sections
        else if brokenString.count != 1 &&
                (brokenString[1] == "A" ||
                brokenString[1] == "B" ||
                brokenString[1] == "C") {
            selectedMethod = .sections
        }
        /// eg: "36 A103", "36 103" --> rooms
        else if brokenString.count != 1 {selectedMethod = .rooms}
        else {selectedMethod = .wrong}
    }
}

struct StudySearchView_Previews: PreviewProvider {
    static var previews: some View {
        StudySearchView()
    }
}



