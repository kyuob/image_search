//
//  imagesearchApp.swift
//  imagesearch
//
//  Created by ekyu on 3/22/26.
//

import SwiftUI

@main
struct imagesearchApp: App {
    private let environment = DIContainer.shared.makeEnvironment()

    var body: some Scene {
        WindowGroup {
            HomeView(environment: environment)
        }
    }
}
