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
    
    var body: some View {
        VStack{
            HStack {
                Button(action: {
                    studyRoomHistory.insert(searchString, at: 0)
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
//                SearchBuildingAndClassView(title: "45教A102", isFree: true)
//                SearchBuildingView(title: "45教", section: "A")
//                SearchBuildingView(title: "45教", section: "B")
                
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
}

struct StudySearchView_Previews: PreviewProvider {
    static var previews: some View {
        StudySearchView()
    }
}



