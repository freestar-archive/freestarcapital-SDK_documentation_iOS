//
//  SPM_TestApp.swift
//  SPM-Test
//
//  Created by Dean Chang on 8/9/22.
//

import SwiftUI
import UIKit

@main
struct FreestarSwiftUISampleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
        
    @ViewBuilder
      var body: some Scene {
        WindowGroup {
            ContentView(appDelegate: appDelegate)
        }
      }
}
