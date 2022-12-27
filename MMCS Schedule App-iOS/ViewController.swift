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
    @IBOutlet weak var Ok_btn: UIButton!
    
    let roles = ["Student", "Teacher"]
    var NmOrGr: [String]!
    var Groups: [String]!
    var id: Int = -1
    var groups: [Group]!
    
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
        
        //Ok_btn.addTarget(self, action: #selector(Ok_btnClicked), for: .touchUpInside)
        
        let gradesJSON = """
[{"id":1,"num":1,"degree":"bachelor"},{"id":2,"num":2,"degree":"bachelor"},{"id":3,"num":3,"degree":"bachelor"},{"id":4,"num":4,"degree":"bachelor"},{"id":13,"num":5,"degree":"bachelor"},{"id":6,"num":1,"degree":"master"},{"id":7,"num":2,"degree":"master"},{"id":8,"num":1,"degree":"postgraduate"},{"id":9,"num":2,"degree":"postgraduate"}]
""".data(using: .utf8)!
        let groupsJSON = """
[{"id":1,"name":"ПМИ","num":1,"gradeid":1,"grorder":1},{"id":7,"name":"ПМИ","num":2,"gradeid":1,"grorder":2},{"id":14,"name":"ПМИ","num":3,"gradeid":1,"grorder":3},{"id":19,"name":"ПМИ","num":4,"gradeid":1,"grorder":4},{"id":75,"name":"ПМИ","num":5,"gradeid":1,"grorder":5},{"id":99,"name":"ПМИ","num":6,"gradeid":1,"grorder":6},{"id":25,"name":"ММ","num":1,"gradeid":1,"grorder":7},{"id":46,"name":"ФИиИТ","num":1,"gradeid":1,"grorder":8},{"id":51,"name":"ФИиИТ","num":2,"gradeid":1,"grorder":9},{"id":97,"name":"ФИиИТ","num":3,"gradeid":1,"grorder":10},{"id":98,"name":"ФИиИТ","num":4,"gradeid":1,"grorder":11},{"id":133,"name":"ФИиИТ","num":5,"gradeid":1,"grorder":12},{"id":82,"name":"ПОМ","num":1,"gradeid":1,"grorder":13},{"id":92,"name":"ПОМ","num":2,"gradeid":1,"grorder":14},{"id":128,"name":"ПОМИ","num":1,"gradeid":1,"grorder":15},{"id":93,"name":"ПОМИ","num":2,"gradeid":1,"grorder":16}]
""".data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        let grades = try! jsonDecoder.decode([Grade].self, from: gradesJSON)
        groups = try! jsonDecoder.decode([Group].self, from: groupsJSON)
        NmOrGr = grades.map { (gr) -> String in gr.degree + ", " + String(gr.num) }
        Groups = groups.map { (gr) -> String in gr.name + ", " + String(gr.num) }
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
            
            if (row == 0) {
                //TODO: Fill list with grades
                List_NmOrGr.resignFirstResponder()
                List_NmOrGr.isHidden = false
                List_NmOrGr.placeholder = "Курс"
            }
            else{
                //TODO: Fill list with grades
                List_NmOrGr.resignFirstResponder()
                List_NmOrGr.isHidden = false
                List_NmOrGr.placeholder = "ФИО"
            }
        case 2:
            List_NmOrGr.text = NmOrGr[row]
            List_NmOrGr.resignFirstResponder()
            
            //TODO: Fill list with coresponding groups
            if (Role.text=="Student")
            {
                List_Groups.resignFirstResponder()
                List_Groups.isHidden = false
            }
            else
            {
                //Replace row with teacher ID
                id = row
                Ok_btn.isEnabled = true
            }
        case 3:
            List_Groups.text = Groups[row]
            List_Groups.resignFirstResponder()
            
            id = groups[row].id
            Ok_btn.isEnabled = true
        default:
            return
        }
    }
    
    /*@objc func Ok_btnClicked(){
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controller = story.instantiateViewController(identifier: "") as
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "MainToSchedule"{
            let vc = segue.destination as! ScheduleViewController
            vc.id = id
            vc.role = Role.text
            vc.header = (Role.text=="Student") ? List_NmOrGr.text! + " – " + List_Groups.text! : List_NmOrGr.text!
        }
    }
}
