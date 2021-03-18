//
//  Localizable.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/5/20.
//

import SwiftUI

enum Localizable: LocalizedStringKey, CaseIterable {
    case urlError, requestFailed, loginFailed, unknownError
    
    case notificationError, notificationErrorMessage
    case biometryNotEnrolled, biometryNotAvailable, biometryNotAvailableMessage, userCancel, faceIDUsageDescription
    
    
    case login, ok
    case captcha
    case classesUsername, classesPassword
    case ecardUsername, ecardPassword
    case wlanUsername, wlanPassword
    
//    case fullCourse, onlyThisWeek
    case account
    case classes, online, offline
    case logout, logoutMessage, confirm
    
    case safety
    case needUnlock
    
    case home
    case beforeDawn, dawn, morning, beforeNoon, noon, noonSoon, afternoon, dusk, evening, night
    
    case courseTable, emptyCourseMeesage, nextDayEmptyCourse
    
    case term, score, gpa, credit, emptyGPAMeesage
    case totalScore, totalGPA, totalCredit
    
    case ecard, ecardNO, state, balance, expire, subsidy
    case period, transaction, dailyConsume, siteConsume, siteRecharge
    
    case wlan, detail
}

struct Localizable_Previews: PreviewProvider {
    static let localization = ["en", "zh-Hans", "zh-Hant"]
    
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            List {
                ForEach(Localizable.allCases, id: \.self) { key in
                    HStack {
                        ForEach(localization, id: \.self) { id in
                            Text(key.rawValue)
                                .environment(\.locale, .init(identifier: id))
                        }
                    }
                }
            }
            .environment(\.colorScheme, .dark)
        }
    }
}
