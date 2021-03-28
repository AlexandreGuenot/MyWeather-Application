//
//  ContentView.swift
//  WeatherApp
//
//  Created by Alexandre Genot on 28/03/2021.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel : WeatherViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.cityName)
                .font(.largeTitle)
                .padding()
            Text(viewModel.temperature)
                .font(.system(size: 70))
                .bold()
            Text(viewModel.weatherIcon)
                .font(.largeTitle)
                .padding()
            Text(viewModel.weatherDescription)
        }.onAppear(perform: viewModel.refresh)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: WeatherViewModel(weatherService : WeatherService()))
    }
}
