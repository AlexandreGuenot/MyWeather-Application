//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Alexandre on 28/03/2021.
//
import CoreLocation
import Foundation

public final class WeatherService : NSObject {
    private let locationManager = CLLocationManager()
    private let API_KEY = "0634b2cdcddb1cb661ab7d0f664055d8"
    private var completionHandler: ((Weather) -> Void)?
    
    public override init() {
        super.init()
        locationManager.delegate = self
    }
    
    public func loadWeatherData(_ completionHandler: @escaping((Weather) -> Void)) {
        
        self.completionHandler = completionHandler
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    // https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}

    private func MakeDataRequest(forCoordinates coordinates : CLLocationCoordinate2D) {
        guard let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(API_KEY)&units=metric"
                . addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data else {return}
            if let response = try? JSONDecoder().decode(APIResponse.self, from : data) {
                self.completionHandler?(Weather(response: response))
            }
        }.resume()
    }
}

extension WeatherService : CLLocationManagerDelegate {
    public func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations : [CLLocation]
    ) {
        guard let location = locations.first else {return}
        MakeDataRequest(forCoordinates: location.coordinate)
    }
    
    public func locationManager(
        _ manage: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("Something went Wrong: \(error.localizedDescription)")
    }
}
struct APIResponse: Decodable {
    let name: String
    let main: APIMain
    let weather: [APIWeather]
    
    
}

struct APIMain : Decodable{
    let temp : Double
}

struct APIWeather : Decodable{
    let description: String
    let iconName: String
    
    enum CodingKeys : String, CodingKey {
        case description
        case iconName = "main"
    }
}
