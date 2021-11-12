//
//  ViewController.swift
//  TimerCountUp
//
//  Created by 윤병일 on 2021/11/12.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

  //MARK: - Properties
  let timerLabel : UILabel = {
    let lb = UILabel()
    lb.text = "00:00:00"
    lb.textColor = .white
    lb.font = UIFont.systemFont(ofSize: 44)
    return lb
  }()
  
  let startAndStopButton : UIButton = {
    let bt = UIButton()
    bt.setTitle("Start", for: .normal)
    bt.addTarget(self, action: #selector(startAndStopBtnTap), for: .touchUpInside)
    return bt
  }()
  
  let resetButton : UIButton = {
    let bt = UIButton()
    bt.setTitle("Reset", for: .normal)
    bt.addTarget(self, action: #selector(resetBtnTap), for: .touchUpInside)
    return bt
  }()
  
  var timer : Timer = Timer()
  var count : Int = 0
  var timerCounting : Bool = false
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  //MARK: - Functions
  private func configureUI() {
    startAndStopButton.setTitleColor(.green, for: .normal)
    
    [timerLabel, startAndStopButton, resetButton].forEach {
      view.addSubview($0)
    }
    
    timerLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaInsets).offset(50)
      $0.centerX.equalToSuperview()
    }
    
    startAndStopButton.snp.makeConstraints {
      $0.top.equalTo(timerLabel.snp.bottom).offset(20)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(200)
      $0.height.equalTo(50)
    }
    
    resetButton.snp.makeConstraints {
      $0.top.equalTo(startAndStopButton.snp.bottom).offset(20)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(200)
      $0.height.equalTo(50)
    }
  }
  
  func secondsHoursMinutesSeconds(seconds : Int) -> (Int, Int, Int) {
    return ((seconds / 3600), ((seconds % 3600) / 60), ((seconds % 3600) % 60))
  }
  
  func makeTimeString(hours : Int, minutes : Int, seconds : Int) -> String {
    var timeString = ""
    timeString += String(format: "%02d", hours)
    timeString += " : "
    timeString += String(format: "%02d", minutes)
    timeString += " : "
    timeString += String(format: "%02d", seconds)
    return timeString
  }
  
  //MARK: - @objc func
  @objc private func startAndStopBtnTap() {
    if timerCounting {
      timerCounting = false
      timer.invalidate()
      startAndStopButton.setTitle("Start", for: .normal)
      startAndStopButton.setTitleColor(UIColor.green, for: .normal)
    } else {
      timerCounting = true
      startAndStopButton.setTitle("Stop", for: .normal)
      startAndStopButton.setTitleColor(UIColor.red, for: .normal)
      timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
    }
  }

  @objc private func resetBtnTap() {
    let alert = UIAlertController(title: "Reset Timer?", message: "Are you sure you yould like to reset the Timer?", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
      // do nothing
    }))
    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
      self.count = 0
      self.timer.invalidate()
      self.timerLabel.text = self.makeTimeString(hours: 0, minutes: 0, seconds: 0)
      self.startAndStopButton.setTitle("Start", for: .normal)
      self.startAndStopButton.setTitleColor(UIColor.green, for: .normal)
      
    }))
    self.present(alert, animated: true, completion: nil)
  }
  
  @objc private func timerCounter() {
    count = count +  1
    let time = secondsHoursMinutesSeconds(seconds: count)
    let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
    timerLabel.text = timeString
  }
  
  
}

