//
//  StringProtocol+Index.swift
//  runumbers
//
//  Created by Максим Скрябин on 15/05/2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import Foundation

extension StringProtocol {
  func index(of string: Self, options: String.CompareOptions = []) -> Index? {
    return range(of: string, options: options)?.lowerBound
  }
  
  func endIndex(of string: Self, options: String.CompareOptions = []) -> Index? {
    return range(of: string, options: options)?.upperBound
  }
  
  func indexes(of string: Self, options: String.CompareOptions = []) -> [Index] {
    var result: [Index] = []
    var startIndex = self.startIndex
    while startIndex < endIndex,
      let range = self[startIndex...].range(of: string, options: options) {
        result.append(range.lowerBound)
        startIndex = range.lowerBound < range.upperBound ? range.upperBound :
          index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
    }
    return result
  }
  
  func ranges(of string: Self, options: String.CompareOptions = []) -> [Range<Index>] {
    var result: [Range<Index>] = []
    var startIndex = self.startIndex
    while startIndex < endIndex,
      let range = self[startIndex...].range(of: string, options: options) {
        result.append(range)
        startIndex = range.lowerBound < range.upperBound ? range.upperBound :
          index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
    }
    return result
  }
  
  var onlyNumbers: Bool {
    let numbers: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
    for c in self {
      if !numbers.contains("\(c)") {
        return false
      }
    }
    return true
  }
}
