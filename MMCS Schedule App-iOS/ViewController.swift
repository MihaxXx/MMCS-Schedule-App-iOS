//
//  ViewController.swift
//  MMCS Schedule App-iOS
//
//  Created by Михаил on 26.12.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var Role: UITextField!
    @IBOutlet weak var List_NmOrGr: UITextField!
    @IBOutlet weak var List_Groups: UITextField!
    
    let roles = ["Student", "Teacher"]
    var NmOrGr: [String]!
    var Groups: [String]!
    
    var RolePickerView = UIPickerView()
    var NmOrGrPickerView = UIPickerView()
    var GroupsPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Role.inputView = RolePickerView
        List_NmOrGr.inputView = NmOrGrPickerView
        List_Groups.inputView = GroupsPickerView
        
        RolePickerView.delegate = self
        RolePickerView.dataSource = self
        NmOrGrPickerView.delegate = self
        NmOrGrPickerView.dataSource = self
        GroupsPickerView.delegate = self
        GroupsPickerView.dataSource = self
        
        RolePickerView.tag = 1
        NmOrGrPickerView.tag = 2
        GroupsPickerView.tag = 3
        
        let gradesJSON = """
[{"id":1,"num":1,"degree":"bachelor"},{"id":2,"num":2,"degree":"bachelor"},{"id":3,"num":3,"degree":"bachelor"},{"id":4,"num":4,"degree":"bachelor"},{"id":13,"num":5,"degree":"bachelor"},{"id":6,"num":1,"degree":"master"},{"id":7,"num":2,"degree":"master"},{"id":8,"num":1,"degree":"postgraduate"},{"id":9,"num":2,"degree":"postgraduate"}]
""".data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        let grades = try! jsonDecoder.decode([Grade].self, from: gradesJSON)
    }


}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return roles.count
        case 2:
            return NmOrGr.count
        case 3:
            return Groups.count
        default:
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return roles[row]
        case 2:
            return NmOrGr[row]
        case 3:
            return Groups[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            Role.text = roles[row]
            Role.resignFirstResponder()
        case 2:
            List_NmOrGr.text = NmOrGr[row]
            List_NmOrGr.resignFirstResponder()
        case 3:
            List_Groups.text = Groups[row]
            List_Groups.resignFirstResponder()
        default:
            return
        }
    }
}
