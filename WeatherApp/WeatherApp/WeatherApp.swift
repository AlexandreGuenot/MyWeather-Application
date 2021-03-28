//
//  WeatherApp.swift
//  WeatherApp
//
//  Created by Alexandre on 28/03/2021.
//

import SwiftUI

@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            let weatherService = WeatherService()
            let viewModel = WeatherViewModel(weatherService: weatherService)
            ContentView(viewModel : viewModel)
        }
    }
}
