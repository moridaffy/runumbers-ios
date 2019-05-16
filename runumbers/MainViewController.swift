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
  @IBOutlet private weak var tableView: UITableView!
  
  private var number: Number?
  private weak var copiedToast: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Склонялка"
    
    let aboutBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_info"), style: .plain, target: self, action: #selector(aboutButtonTapped))
    navigationItem.rightBarButtonItem = aboutBarButtonItem
    
    startButton.backgroundColor = UIColor.blue
    startButton.layer.cornerRadius = startButton.frame.height / 2.0
    startButton.layer.masksToBounds = true
    startButton.setTitleColor(UIColor.white, for: .normal)
    tableView.tableFooterView = UIView()
    tableView.separatorInset = UIEdgeInsets(top: 0.0, left: tableView.frame.width, bottom: 0.0, right: 0.0)
    tableView.delegate = self
    tableView.dataSource = self
    numberField.delegate = self
    
    setupResultLabel()
    
  }
  
  private func setupResultLabel(result: Number? = nil) {
    number = result
    tableView.reloadData()
  }
  
  private func displayToast() {
    if copiedToast == nil {
      let label = UILabel(frame: CGRect(x: 16.0,
                                    y: view.frame.height -  50.0 - 32.0,
                                    width: view.frame.width - 32.0,
                                    height: 50.0))
      label.layer.cornerRadius = 25.0
      label.layer.masksToBounds = true
      label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
      label.textColor = UIColor.white
      label.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
      label.text = "Числительное скопировано!"
      label.numberOfLines = 0
      label.textAlignment = .center
      label.alpha = 0.0
      view.addSubview(label)
      self.copiedToast = label
    } else {
      return
    }
    
    UIView.animate(withDuration: 0.5, animations: {
      self.copiedToast.alpha = 1.0
    }) { (_) in
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
        UIView.animate(withDuration: 0.5, animations: {
          self.copiedToast.alpha = 0.0
        }, completion: { (_) in
          self.copiedToast.removeFromSuperview()
          self.copiedToast = nil
        })
      })
    }
    
  }
  
  @IBAction private func startButtonTapped() {
    guard let value = Int(numberField.text ?? "") else { return }
    view.endEditing(true)
    startButton.setTitle("Склоняем...", for: .normal)
    APIManager.shared.loadCases(for: value) { [weak self] (number, error) in
      self?.startButton.setTitle("Просклонять", for: .normal)
      self?.setupResultLabel(result: number)
    }
  }
  
  @objc private func aboutButtonTapped() {
    let alert = UIAlertController(title: "О приложении",
                                  message: "Приложение работает на основе бесплатного веб-сервиса. При вводе любого числа Вы получаете числительное, написанное прописью, а также просклоненное по всем падежам.",
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Веб-сервис", style: .default) { (_) in
      UIApplication.shared.open(URL(string: "https://numeralonline.ru/")!, options: [:], completionHandler: nil)
    })
    alert.addAction(UIAlertAction(title: "Разработчик", style: .default) { (_) in
      UIApplication.shared.open(URL(string: "http://mskr.name")!, options: [:], completionHandler: nil)
    })
    alert.addAction(UIAlertAction(title: "Отмена", style: .cancel) { (_) in
      alert.dismiss(animated: true, completion: nil)
    })
    present(alert, animated: true, completion: nil)
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

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 44.0
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (number != nil) ? 6 : 0
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let number = number,
          let cell = tableView.dequeueReusableCell(withIdentifier: "NumberCell"),
          let label = cell.viewWithTag(1) as? UILabel else {
            fatalError()
    }
    
    let index = indexPath.row + 1
    let text = NSMutableAttributedString()
    text.append(NSAttributedString(string: Number.caseNames[index],
                                   attributes: [.font: UIFont.systemFont(ofSize: 12.0, weight: .regular),
                                                .foregroundColor: UIColor.black.withAlphaComponent(0.75)]))
    if !Number.caseQuestions[index].isEmpty {
      text.append(NSAttributedString(string: " (\(Number.caseQuestions[index]))",
        attributes: [.font: UIFont.systemFont(ofSize: 12.0, weight: .regular),
                     .foregroundColor: UIColor.black.withAlphaComponent(0.75)]))
    }
    text.append(NSAttributedString(string: "\n" + number.cases[index],
                                   attributes: [.font: UIFont.systemFont(ofSize: 14.0, weight: .regular),
                                                .foregroundColor: UIColor.black]))
    label.attributedText = text
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    UIPasteboard.general.string = number?.cases[indexPath.row + 1]
    tableView.deselectRow(at: indexPath, animated: true)
    displayToast()
  }
}
