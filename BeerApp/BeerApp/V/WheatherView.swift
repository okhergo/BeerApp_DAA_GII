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
            if(vm.hourlyForecasts.first?.temperature ?? 0 > 15){
                Image("HotWeather")
                    .resizable()
                    .frame(height: 150)
                    .cornerRadius(10)
                    .padding(10)
                Rectangle()
                    .background(.yellow)
                    .opacity(0.2)
                    .frame(height: 150)
                    .cornerRadius(10)
                    .padding(10)
            } else {
                Image("ColdWeather")
                    .resizable()
                    .frame(height: 150)
                    .cornerRadius(10)
                    .padding(10)
                Rectangle()
                    .background(.blue)
                    .opacity(0.4)
                    .frame(height: 150)
                    .cornerRadius(10)
                    .padding(10)
            }
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
        .onAppear {
            vm.requestLocation()
        }
        .alert(isPresented: Binding<Bool>.constant($vm.errorMessage.wrappedValue != nil), content: {
            Alert(title: Text("Error"), message: Text($vm.errorMessage.wrappedValue ?? "Unknown error"), dismissButton: .default(Text("OK")))
        })
    }
}


#Preview {
    WheatherView()
}
