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
   
   @EnvironmentObject var parameters: Parameters
   
   @State private var startPressure = ["300", "300", "300", "300", "300"]
   @State private var firePressure = ["250", "250", "250", "250", "250"]
   @State private var minValue = "300"
   @State private var showFullSolution: Bool = false
   @State private var showSimpleSoution: Bool = false
   @State private var teamSize = 3
   
   @State private var hardWork: Bool = false
   @State private var fireStatus: Bool = false
   
   var backColor: some View {
      colorScheme == .dark ? darkColor : Color.white
   }
   
   
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
                           Image(systemName: fireStatus ? "flame.fill" : "flame")
                              .foregroundColor(fireStatus ? .red : .gray)
                              .frame(width: 26, height: 26, alignment: .center)
                           
                           Text("Очаг")
                        } //HStack
                        .font(.headline)
                        
                        MySwitcher(binding: $fireStatus, leftText: "ПОИСК", rightText: "У ОЧАГА")
                           .onChange(of: fireStatus) { newValue in
                              parameters.setFireStatus(status: newValue)
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
                           Image(systemName: hardWork ? "dial.max.fill" : "dial.min.fill")
                              .foregroundColor(hardWork ? .orange : .green)
                              .frame(width: 26, height: 26, alignment: .center)
                           
                           Text("Условия")
                        } //HStack
                        .font(.headline)
                        
                        MySwitcher(binding: $hardWork, leftText: "НОРМА", rightText: "СЛОЖН")
                           .onChange(of: hardWork) { newValue in
                              parameters.setWorkType(hard: newValue)
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
                        
                        DatePicker("", selection: $parameters.workConditions.startTime,  displayedComponents: .hourAndMinute)
                           .datePickerStyle(GraphicalDatePickerStyle())
                        
                     }
                     .frame(height: 35)
                     
                     // Время у очага
                     if parameters.workConditions.fireStatus {
                        Divider()
                        
                        HStack {
                           Text("У очага:")
                              .font(.headline)
                           
                           Spacer()
                           
                           DatePicker("", selection: $parameters.workConditions.fireTime, displayedComponents: .hourAndMinute)
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
                        
                        Stepper("Состав звена", value: $teamSize, in: 2...5)
                           .font(.headline)
                           .disabled(!parameters.workConditions.fireStatus)
                           .onChange(of: teamSize) { newValue in
                              parameters.workConditions.teamSize = newValue
                           }
                     } //HStack
                     .padding(.bottom, 10)
                     
                     // Поиск очага
                     if !parameters.workConditions.fireStatus {
                        HStack(spacing: 20) {
                           Text("P мин. вкл.")
                           
                           TextField("P min.", text: $minValue)
                              .frame(width: 90)
                              .multilineTextAlignment(.center)
                              .textFieldStyle(RoundedBorderTextFieldStyle())
                              .keyboardType(parameters.appSettings.measureType == .kgc ? .numberPad : .decimalPad)
                              .onChange(of: minValue) { newValue in
                                 checkTextField(type: parameters.appSettings.measureType, value: &minValue, newValue: newValue)
                              }
                        } // HStack
                        .font(.custom("AppleSDGothicNeo-Semibold", size: 17))
                     }
                     
                     // Очаг обнаружен
                     else {
                        VStack {
                           HStack(spacing: 70) {
                              Text("P вкл.")
                              Text("P очага")
                           }
                           
                           ForEach(0..<teamSize, id: \.self) { i in
                              PressureItem(num: i+1, enterValue: $startPressure[i], fireValue: $firePressure[i])
                           }
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
            
            NavigationLink(destination: FullSolutionView(parameters: parameters), isActive: $showFullSolution) { EmptyView() }
            NavigationLink(destination: SimpleSolutionView(), isActive: $showSimpleSoution) { EmptyView() }
            
         } //ScrollView
         .environment(\.locale, Locale.init(identifier: "ru"))
         .navigationBarTitle("", displayMode: .inline)
         .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
               Button("Рассчитать") {
                  calculate()
                  
                  switch parameters.appSettings.solutionType {
                     case true: self.showFullSolution = true
                     case false: self.showSimpleSoution = true
                  }
               }
            }
         }
      } //NavigationView
      
      .onAppear() {
         // TODO Подгрузка из UserDefauls
         getParametersFromModel()
      }
   }
   
   
   // MARK: - METHODS
   /// Получаем данные из модели при загрузке экрана
   private func getParametersFromModel() {
      print("getParametersFromModel")
      
      switch parameters.appSettings.measureType {
         case .kgc:
            self.startPressure = parameters.workConditions.startPressure.map({ String(Int($0)) })
            self.firePressure = parameters.workConditions.firePressure.map({ String(Int($0)) })
            self.minValue = String(Int(parameters.workConditions.minValue))
            
         case .mpa:
            self.startPressure = parameters.workConditions.startPressure.map({ String($0) })
            self.firePressure = parameters.workConditions.firePressure.map({ String($0) })
            self.minValue = String(parameters.workConditions.minValue)
      }
      
      self.fireStatus = parameters.workConditions.fireStatus
      self.hardWork = parameters.workConditions.hardWork
   }
   
   /// 
   private func calculate() {
      print("Calculate!")
      
      parameters.workConditions.minValue = Double(self.minValue)!
      parameters.workConditions.startPressure = self.startPressure.map({ $0.doubleValue })
      parameters.workConditions.firePressure = self.firePressure.map({ $0.doubleValue })
      
   }
}


struct PressureItem: View {
   @EnvironmentObject var parameters: Parameters
   
   var num: Int
   @Binding var enterValue: String
   @Binding var fireValue: String
   @State private var alert: Bool = false
   
   var keyType: UIKeyboardType {
      return parameters.appSettings.measureType == .kgc ? .numberPad : .decimalPad
   }
   
   var body: some View {
      
      HStack(spacing: 10) {
                  TextField("P вкл.", text: $enterValue)
//         InputTextfield(text: $enterValue, keyType: parameters.appSettings.measureType == .kgc ? .numberPad : .decimalPad)
            .onChange(of: enterValue) { newValue in
               checkTextField(type: parameters.appSettings.measureType, value: &enterValue, newValue: newValue)
//               print(newValue)
            }
         
         
         Text("\(num)")
            .font(Font.body.bold())
         
         TextField("P очага.", text: $fireValue)
            .onChange(of: fireValue) { newValue in
               checkTextField(type: parameters.appSettings.measureType, value: &fireValue, newValue: newValue)
            }
         
      } // HStack
      .textFieldStyle(RoundedBorderTextFieldStyle())
      .font(.custom("AppleSDGothicNeo-Semibold", size: 17))
      .multilineTextAlignment(.center)
//      .keyboardType(parameters.appSettings.measureType == .kgc ? .numberPad : .decimalPad)
   }
}

