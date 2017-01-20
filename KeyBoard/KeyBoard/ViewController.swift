//
//  ViewController.swift
//  KeyBoard
//
//  Created by choice on 2017/1/19.
//  Copyright © 2017年 choice. All rights reserved.
//

import UIKit

class MainCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
}

class ViewController: UIViewController {

    @IBOutlet weak var keyBaordView: UIView!
    @IBOutlet weak var textFeild: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        textFeild.placeholder = "输入消息内容"
        textFeild.returnKeyType = UIReturnKeyType.send
        textFeild.enablesReturnKeyAutomatically  = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(KeyBoardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyBoardWillHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func KeyBoardWillShow(_ note: Notification) {
        
        if let userInfo = note.userInfo {
            if let bounds = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let keyBoardBounds = bounds.cgRectValue
                
                if let durationInfo = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
                    let duration = durationInfo.doubleValue
                    let deltaY = keyBoardBounds.size.height
                    let animations:(() -> Void) = {
//                        self.view.transform = CGAffineTransform(translationX: 0, y: -deltaY)
                        self.keyBaordView.transform = CGAffineTransform(translationX: 0, y: -deltaY)
                    }
                    
                    if duration > 0 {
                        if let curveInfo = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber {
                            let options = UIViewAnimationOptions(rawValue: UInt(curveInfo.intValue << 16))
                            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
                        }
                    } else {
                        animations()
                    }
                }
            }
        }
    }
    
    func KeyBoardWillHide(_ note: Notification) {
        
        
        if let userInfo  = note.userInfo {
            if let durationInfo = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
                let duration = durationInfo.doubleValue
                
                let animations:(() -> Void) = {
//                    self.view.transform = CGAffineTransform.identity
                    self.keyBaordView.transform = CGAffineTransform.identity
                }
                
                if duration > 0 {
                    if let curveInfo = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber {
                        let options = UIViewAnimationOptions(rawValue: UInt(curveInfo.intValue << 16))
                        UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
                    }
                } else {
                    animations()
                }
            }
        }
    }
}

extension ViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? MainCell {
            cell.titleLabel.text = "\(indexPath.row)"
//            cell.textField.delegate = self
            return cell
        }
        return UITableViewCell()
    }
}

