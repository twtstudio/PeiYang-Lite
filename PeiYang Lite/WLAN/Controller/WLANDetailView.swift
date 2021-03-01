//
//  WLANDetailView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 8/7/20.
//

import SwiftUI

struct WLANDetailView: View {
    @ObservedObject var store = Storage.wlan
    private var overview: WLANOverview { store.object.overview }
    private var detailArray: [WLANDetail] { store.object.detailArray }
    
    @State private var isLoading = false
    
    var body: some View {
        VStack(alignment: .leading) {
            // MARK: - Header
            HStack(alignment: .top) {
                Text(Localizable.wlan.rawValue)
                    .font(.title)
                
                Spacer()
                
                Text(overview.state)
                    .font(.subheadline)
                    .foregroundColor(overview.state == "正常" ? .green : .red)
            }
            .padding(.bottom)
            
           Text("availableTraffic: \(overview.traffic)")
                .font(.largeTitle)
                .bold()
                .padding(.vertical)
            
            HStack(alignment: .bottom) {
                Text("balance: \(overview.balance)")
                    .foregroundColor(.secondary)
                
                Spacer()
                
                RefreshButton(isLoading: $isLoading, action: load, color: .white)
            }
            .padding(.vertical)
            
            // MARK: - List
            if !detailArray.isEmpty {
                List {
                    Section(header: Text(Localizable.detail.rawValue)) {
                        ForEach(detailArray, id: \.onlineDate) { detail in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(detail.ip)
                                    
                                    Text(detail.onlineDate)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Text("-\(detail.traffic)")
                                    .font(.title)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
            } else {
                Spacer()
            }
        }
<<<<<<< HEAD
        .onAppear {
            if !Storage.defaults.bool(forKey: WLANManager.isStoreKey) {
                load()
            }
        }
=======
        .onAppear(perform: load)
>>>>>>> e4291697b2a03afcf4cfbf314ae8cf47114102d1
    }
    
    func load() {
        isLoading = true
        WLANManager.wlanGet { result in
            switch result {
<<<<<<< HEAD
            case .success(_): break
//                store.object = wlan
//                store.save()
=======
            case .success(let wlan):
                store.object = wlan
                store.save()
>>>>>>> e4291697b2a03afcf4cfbf314ae8cf47114102d1
            case .failure(let error):
                print(error)
            }
            isLoading = false
        }
    }
}

struct WLANDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            WLANDetailView()
                .environment(\.colorScheme, .dark)
        }
    }
}
