//
//  Number.swift
//  runumbers
//
//  Created by Максим Скрябин on 15/05/2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import Foundation

class Number {
  static let caseNames: [String] = ["Число",
                                    "Именительный",
                                    "Родительный",
                                    "Дательный",
                                    "Винительный",
                                    "Творительный",
                                    "Предложный"]
  
  static let caseQuestions: [String] = ["",
                                        "есть что?",
                                        "нет чего?",
                                        "рад чему?",
                                        "вижу что?",
                                        "оплачу чем?",
                                        "думаю о чём?"]
  
  private(set) var cases: [String] = []
  
  init?(cases: [String]) {
    if cases.count == Number.caseNames.count {
      self.cases = cases
    } else {
      return nil
    }
  }
}
