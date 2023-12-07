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
            RoundedRectangle(cornerRadius: 10)
                .padding(10)
                .frame(height: 150)
            VStack {
                HStack {
                    Text("\(vm.hourlyForecasts.first?.temperature ?? 0, specifier: "%.1f")°C")
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 40))
                        .padding()
                    Text("\(vm.currentCity)")
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                }
                Text(String(localized: "WheaterSubtitle"))
                    .foregroundColor(.white)
                    .font(.subheadline)
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
