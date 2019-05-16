//
//  MainViewController.swift
//  runumbers
//
//  Created by Максим Скрябин on 15/05/2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  
  @IBOutlet private weak var numberLabel: UILabel!
  @IBOutlet private weak var numberField: UITextField!
  @IBOutlet private weak var startButton: UIButton!
  @IBOutlet private weak var resultLabelStackView: UIStackView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    numberField.delegate = self
    startButton.backgroundColor = UIColor.blue
    startButton.layer.cornerRadius = startButton.frame.height / 2.0
    startButton.layer.masksToBounds = true
    startButton.setTitleColor(UIColor.white, for: .normal)
    
    setupResultLabel()
  }
  
  private func setupResultLabel(result: Number? = nil) {
    guard let result = result else {
      for i in 1...6 {
        if let label = resultLabelStackView.viewWithTag(i) as? UILabel {
          label.text = ""
        }
      }
      return
    }
    
    for i in 1...6 {
      if let label = resultLabelStackView.viewWithTag(i) as? UILabel {
        let text = NSMutableAttributedString()
        text.append(NSAttributedString(string: Number.caseNames[i], attributes: [.font: UIFont.systemFont(ofSize: 12.0, weight: .regular),
                                                                                 .foregroundColor: UIColor.black.withAlphaComponent(0.75)]))
        if !Number.caseQuestions[i].isEmpty {
          text.append(NSAttributedString(string: " (\(Number.caseQuestions[i]))", attributes: [.font: UIFont.systemFont(ofSize: 12.0, weight: .regular),
                                                                                               .foregroundColor: UIColor.black.withAlphaComponent(0.75)]))
        }
        text.append(NSAttributedString(string: "\n" + result.cases[i], attributes: [.font: UIFont.systemFont(ofSize: 14.0, weight: .regular),
                                                                                    .foregroundColor: UIColor.black]))
        label.attributedText = text
      }
    }
  }
  
  @IBAction private func startButtonTapped() {
    guard let value = Int(numberField.text ?? "") else { return }
    view.endEditing(true)
    APIManager.shared.loadCases(for: value) { [weak self] (number, error) in
      self?.setupResultLabel(result: number)
    }
  }
}

extension MainViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    var newText: String {
      if string == "" {
        return String((textField.text ?? "").dropLast(1))
      } else {
        return (textField.text ?? "") + string
      }
    }
    return newText.onlyNumbers
  }
}
