//
//  WheatherView.swift
//  BeerApp
//
//  Created by Óscar Khergo on 7/12/23.
//

import SwiftUI

struct WheatherView: View {
    @StateObject private var vm = WeatherViewModel()
    var body: some View{
        ZStack {
            //Si hace frío o calor modifica la visualización
            if(vm.hourlyForecasts.first?.temperature ?? 0 > 15){
                CustomWeatherBackground(imageURL: "HotWeather", opacity: 0.4, color: .yellow)
            } else {
                CustomWeatherBackground(imageURL: "ColdWeather", opacity: 0.7, color: .cyan)
            }
            
            //Muestra la temperatura
            VStack {
                HStack {
                    Text("\(vm.hourlyForecasts.first?.temperature ?? 0, specifier: "%.1f")°C")
                        .foregroundColor(.black)
                        .font(.system(size: 40))
                        .padding()
                        .bold()
                    Text("\(vm.currentCity)")
                        .foregroundColor(.black)
                }
                if (vm.hourlyForecasts.first?.temperature ?? 0 > 15){
                    Text(String(localized: "WheaterSubtitle"))
                        .foregroundColor(.white)
                        .font(.subheadline).bold()
                } else {
                    Text(String(localized: "WheaterSubtitleNo"))
                        .foregroundColor(.white)
                        .font(.subheadline).bold()
                }
            }
        }
        //Solicita la ubicación para obtener la temperatura
        .onAppear {
            vm.requestLocation()
        }
    }
}


#Preview {
    WheatherView()
}
