//
//  ScreenOrientationDelegate.swift
//  SleuthVision
//
//  Created by mac.bernanda on 27/04/24.
//

import Foundation
import SwiftUI

class ScreenOrientationDelegate: NSObject, UIApplicationDelegate {
        
    static var orientationLock = UIInterfaceOrientationMask.all //By default you want all your views to rotate freely

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return ScreenOrientationDelegate.orientationLock
    }
}
