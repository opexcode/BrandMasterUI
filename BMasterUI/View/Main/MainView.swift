//
//  Main.swift
//  BMaster
//
//  Created by Алексей on 26.02.2021.
//

import SwiftUI

struct MainView: View {
    
    @Environment(\.colorScheme) var colorScheme
    let darkColor = Color(red: 28/255, green: 28/255, blue: 30/255)
    var backColor: some View {
        colorScheme == .dark ? darkColor : Color.white
    }
    var keyboardType: UIKeyboardType {
        return vm.appSettings.measureType == .kgc ? .numberPad : .decimalPad
    }
    
    @ObservedObject var vm: Parameters
    @State private var showFullSolution: Bool = false
    @State private var showSimpleSoution: Bool = false
    
    @State private var workConditions = (fireStatus: false,
                                         hardWork: false,
                                         startTime: Date(),
                                         fireTime: Date(),
                                         startPressure: ["300", "300", "300", "300", "300"],
                                         firePressure: ["250", "250", "250", "250", "250"],
                                         minValue: "300",
                                         teamSize: 3)
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        
                        // MARK: - Очаг
                        ZStack {
                            backColor
                            
                            VStack {
                                HStack {
                                    Image(systemName: workConditions.fireStatus ? "flame.fill" : "flame")
                                        .foregroundColor(workConditions.fireStatus ? .red : .gray)
                                        .frame(width: 26, height: 26, alignment: .center)
                                    
                                    Text("Очаг")
                                } //HStack
                                .font(.headline)
                                
                                MySwitcher(binding: $workConditions.fireStatus, leftText: "ПОИСК", rightText: "У ОЧАГА")
                                    .onChange(of: workConditions.fireStatus) { newValue in
                                        vm.setFireStatus(status: newValue)
                                    }
                            } //VStack
                            .padding(5)
                        } //ZStack
                        .cornerRadius(8.0)
                        .shadow(color: Color.gray, radius: 3)
                        .padding(.trailing, 2.5)
                        
                        
                        
                        // MARK: - Условия
                        ZStack {
                            backColor
                            
                            VStack {
                                HStack {
                                    Image(systemName: workConditions.hardWork ? "dial.max.fill" : "dial.min.fill")
                                        .foregroundColor(workConditions.hardWork ? .orange : .green)
                                        .frame(width: 26, height: 26, alignment: .center)
                                    
                                    Text("Условия")
                                } //HStack
                                .font(.headline)
                                
                                MySwitcher(binding: $workConditions.hardWork, leftText: "НОРМА", rightText: "СЛОЖН")
                                    .onChange(of: workConditions.hardWork) { newValue in
                                        vm.setWorkType(hard: newValue)
                                    }
                            } //VStack
                            .padding(5)
                        } //ZStack
                        .cornerRadius(8.0)
                        .shadow(color: Color.gray, radius: 3)
                        .padding(.leading, 2.5)
                        
                    } //: HStack
                    
                    
                    // MARK: - Время
                    ZStack {
                        backColor
                        
                        VStack {
                            HStack {
                                Image(systemName: "clock")
                                
                                Text("Время")
                            } //HStack
                            .font(.headline)
                            
                            // Время включения
                            HStack {
                                Text("Включение:")
                                    .font(.headline)
                                
                                Spacer()
                                
                                DatePicker("", selection: $workConditions.startTime,  displayedComponents: .hourAndMinute)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                
                            }
                            .frame(height: 35)
                            
                            // Время у очага
                            if workConditions.fireStatus {
                                Divider()
                                
                                HStack {
                                    Text("У очага:")
                                        .font(.headline)
                                    
                                    Spacer()
                                    
                                    DatePicker("", selection: $workConditions.fireTime, displayedComponents: .hourAndMinute)
                                        .datePickerStyle(GraphicalDatePickerStyle())
                                } //HStack
                                .frame(height: 35)
                            } //if
                        } //VStack
                        .padding()
                    }
                    .cornerRadius(8.0)
                    .shadow(color: Color.gray, radius: 3)
                    .padding(.top, 5)
                    
                    
                    // MARK: - Состав звена
                    ZStack {
                        backColor
                        
                        VStack {
                            HStack {
                                Image(systemName: "person.badge.plus")
                                
                                Stepper("Состав звена", value: $workConditions.teamSize, in: 2...5)
                                    .font(.headline)
                                    .disabled(!workConditions.fireStatus)
                                    .onChange(of: workConditions.teamSize) { newValue in
                                        workConditions.teamSize = newValue
                                    }
                            } //HStack
                            .padding(.bottom, 10)
                            
                            // Поиск очага
                            if !workConditions.fireStatus {
                                HStack(spacing: 15) {
                                    Text("P мин. вкл.")
                                        .font(.custom("Charter-Roman", size: 17))
                                    
                                    CustomTF(text: $workConditions.minValue, keyType: keyboardType, placeholder: "P min.", fontSize: 18)
                                        .frame(width: 90)
                                        .multilineTextAlignment(.center)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .onChange(of: workConditions.minValue) { newValue in
                                            checkTextField(type: vm.appSettings.measureType, value: &workConditions.minValue, newValue: newValue)
                                        }
                                } // HStack
                                .font(.custom("AppleSDGothicNeo-Semibold", size: 17))
                            }
                            
                            // Очаг обнаружен
                            else {
                                HStack {
                                    Text("P вкл.")
                                        .rotationEffect(Angle(degrees: -90))
                                        .font(.custom("Charter-Roman", size: 17))
                                    
                                    VStack {
                                        ForEach(0..<workConditions.teamSize, id: \.self) { i in
                                            PressureItem(vm: vm, num: i+1, enterValue: $workConditions.startPressure[i], fireValue: $workConditions.firePressure[i])
                                        }
                                    }
                                    
                                    Text("P очага")
                                        .rotationEffect(Angle(degrees: -90))
                                        .font(.custom("Charter-Roman", size: 17))
                                }
                                .frame(width: 220)
                            }
                        } //VStack
                        .padding()
                    }
                    .cornerRadius(8.0)
                    .shadow(color: Color.gray, radius: 3)
                    .padding(.top, 5)
                    
                    Spacer()
                } //: VStack
                .padding()
                
                NavigationLink(destination: FullSolutionView(parameters: vm), isActive: $showFullSolution) { EmptyView() }
                NavigationLink(destination: SimpleSolutionView(vm: vm), isActive: $showSimpleSoution) { EmptyView() }
                
            } //ScrollView
            .environment(\.locale, Locale.init(identifier: "ru"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Рассчитать") {
                        print(workConditions.firePressure)
                        vm.writeWorkData(conditions: workConditions)
                        
                        switch vm.appSettings.solutionType {
                            case true: showFullSolution = true
                            case false: showSimpleSoution = true
                        }
                    }
                }
            }
        } //NavigationView
        
        .onAppear() {
            // TODO Подгрузка из UserDefauls
            workConditions = vm.obtainWorkData()
        }
        .onDisappear() {
            vm.writeWorkData(conditions: workConditions)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
            vm.writeWorkData(conditions: workConditions)
        }
    }
}


struct PressureItem: View {
    //    @EnvironmentObject var vm: Parameters
    @ObservedObject var vm: Parameters
    
    var num: Int
    @Binding var enterValue: String
    @Binding var fireValue: String
    @State private var alert: Bool = false
    
    let fontSize: CGFloat = 20
    
    var keyboardType: UIKeyboardType {
        return vm.appSettings.measureType == .kgc ? .numberPad : .decimalPad
    }
    
    var body: some View {
        
        HStack(spacing: 10) {
            CustomTF(text: $enterValue, keyType: keyboardType, placeholder: "P вкл.", fontSize: fontSize)
                .onChange(of: enterValue) { newValue in
                    checkTextField(type: vm.appSettings.measureType, value: &enterValue, newValue: newValue)
                }
            
            Text("\(num)")
                .font(Font.body.bold())
            
            CustomTF(text: $fireValue, keyType: keyboardType, placeholder: "P очага.", fontSize: fontSize)
                .onChange(of: fireValue) { newValue in
                    checkTextField(type: vm.appSettings.measureType, value: &fireValue, newValue: newValue)
                }
            
        } // HStack
    }
}


