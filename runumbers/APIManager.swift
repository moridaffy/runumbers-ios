//
//  APIManager.swift
//  runumbers
//
//  Created by Максим Скрябин on 15/05/2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import Foundation

class APIManager {
  
  static let shared = APIManager()
  
  private let sesstion = URLSession(configuration: .default)
  private var requestInProgress: Bool = false {
    didSet {
      print("🔥 request in progress: \(requestInProgress)")
    }
  }
  
  private enum Keys: String {
    case start1Key = "есть что?</td><td>"
    case end1Key = "</span></td><tr><td>Родительный"
    case start2Key = "нет чего?</td><td>"
    case end2Key = "</span></td><tr><td>Дательный"
    case start3Key = "рад чему?</td><td>"
    case end3Key = "</span></td><tr><td>Винительный"
    case start4Key = "вижу что?</td><td>"
    case end4Key = "</span></td><tr><td>Творительный"
    case start5Key = "оплачу чем?</td><td>"
    case end5Key = "</span></td><tr><td>Предложный"
    case start6Key = "думаю о чём?</td><td>"
    case end6Key = "</span></td></tbody></table>"
  }
  
  private func extractCaseValue(input: String) -> String {
    if let end = input.index(of: "  <span class=\"small text-muted\">") {
      return String(input[input.startIndex..<end])
    } else {
      return "Ошибка"
    }
  }
  
  func loadCases(for number: Int, completion: @escaping (Number?, Error?) -> Void) {
    guard !requestInProgress else { return }
    requestInProgress = true
    
    guard let url = URL(string: "https://numeralonline.ru/\(number)") else { completion(nil, nil); return }
    sesstion.dataTask(with: url) { (data, response, error) in
      guard let data = data, let pageCode = String(data: data, encoding: .utf8) else { completion(nil, error); return }
      var cases: [String] = ["\(number)"]
      var errorOccured = false
      
      // Именительный падеж
      if let keyStart = pageCode.index(of: Keys.start1Key.rawValue), let end = pageCode.index(of: Keys.end1Key.rawValue) {
        let start = pageCode.index(keyStart, offsetBy: Keys.start1Key.rawValue.count)
        let block = String(pageCode[start..<end])
        cases.append(self.extractCaseValue(input: block))
      } else {
        cases.append("Ошибка")
        errorOccured = true
      }
      
      // Родительный падеж
      if let keyStart = pageCode.index(of: Keys.start2Key.rawValue), let end = pageCode.index(of: Keys.end2Key.rawValue) {
        let start = pageCode.index(keyStart, offsetBy: Keys.start2Key.rawValue.count)
        let block = String(pageCode[start..<end])
        cases.append(self.extractCaseValue(input: block))
      } else {
        cases.append("Ошибка")
        errorOccured = true
      }

      // Дательный падеж
      if let keyStart = pageCode.index(of: Keys.start3Key.rawValue), let end = pageCode.index(of: Keys.end3Key.rawValue) {
        let start = pageCode.index(keyStart, offsetBy: Keys.start3Key.rawValue.count)
        let block = String(pageCode[start..<end])
        cases.append(self.extractCaseValue(input: block))
      } else {
        cases.append("Ошибка")
        errorOccured = true
      }

      // Винительный падеж
      if let keyStart = pageCode.index(of: Keys.start4Key.rawValue), let end = pageCode.index(of: Keys.end4Key.rawValue) {
        let start = pageCode.index(keyStart, offsetBy: Keys.start4Key.rawValue.count)
        let block = String(pageCode[start..<end])
        cases.append(self.extractCaseValue(input: block))
      } else {
        cases.append("Ошибка")
        errorOccured = true
      }

      // Творительный падеж
      if let keyStart = pageCode.index(of: Keys.start5Key.rawValue), let end = pageCode.index(of: Keys.end5Key.rawValue) {
        let start = pageCode.index(keyStart, offsetBy: Keys.start5Key.rawValue.count)
        let block = String(pageCode[start..<end])
        cases.append(self.extractCaseValue(input: block))
      } else {
        cases.append("Ошибка")
        errorOccured = true
      }

      // Предложный падеж
      if let keyStart = pageCode.index(of: Keys.start6Key.rawValue), let end = pageCode.index(of: Keys.end6Key.rawValue) {
        let start = pageCode.index(keyStart, offsetBy: Keys.start6Key.rawValue.count)
        let block = String(pageCode[start..<end])
        cases.append(self.extractCaseValue(input: block))
      } else {
        cases.append("Ошибка")
        errorOccured = true
      }
      
      if errorOccured {
        print("🔥 pageCode:\n\(pageCode)")
      }
      
      self.requestInProgress = false
      DispatchQueue.main.async {
        completion(Number(cases: cases), error)
      }
    }.resume()
  }
  
}
