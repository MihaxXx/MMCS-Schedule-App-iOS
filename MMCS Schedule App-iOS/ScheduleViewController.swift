//
//  ScheduleViewController.swift
//  MMCS Schedule App-iOS
//
//  Created by Михаил on 27.12.2022.
//

import UIKit

class ScheduleViewController: UIViewController {

    var header: String = ""
    var id: Int!
    var role: String!
    
    var lessonmodels = [LessonModel]()
    var daysOfWeek = [Int]()
    
   var network: APIClient!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            let nib = UINib(nibName: "SubjectCollectionCell", bundle: Bundle.main)
            collectionView.register(nib, forCellWithReuseIdentifier: "subjectCell")
            collectionView.contentInset = UIEdgeInsets(top: 20, left: 10, bottom: 5, right: 10)
        }
    }
    
    fileprivate func convertSchOfGroup(_ schedule: SchOfGroup) -> [LessonModel]{
        var lesmodels = [LessonModel]()
        for item in schedule.lessons {
            item.timeslot.remove(at: item.timeslot.index(before: item.timeslot.endIndex))
            item.timeslot.remove(at: item.timeslot.startIndex)
            let timeslotArray = item.timeslot.components(separatedBy: ",")
            guard timeslotArray.count == 4 else { continue }
            var timeSince = timeslotArray[1]
            let dayOfWeek = timeslotArray[0]
            var timeUntil = timeslotArray[2]
            let upperLowerWeek = timeslotArray[3]
            var teacherName: String!
            var subjectName: String!
            var roomName: String!
            for cur in schedule.curricula {
                if item.id == cur.lessonId {
                    teacherName = cur.teacherName
                    subjectName = cur.subjectName
                    roomName = cur.roomName
                }
            }
            let timeSinceArray = timeSince.components(separatedBy: ":")
            timeSince = timeSinceArray[0] + ":" + timeSinceArray[1]
            let timeUntilArray = timeUntil.components(separatedBy: ":")
            timeUntil = timeUntilArray[0] + ":" + timeUntilArray[1]
            var isUp: Int?
            switch upperLowerWeek {
            case "full":
                isUp = 2
            case "upper":
                isUp = 0
            case "lower":
                isUp = 1
            default:
                break
            }
            let sheduleLesson = LessonModel(dayOfWeek: Int(dayOfWeek)!,
                                            timeSince: timeSince ?? "",
                                            timeBefore: timeUntil ?? "",
                                            room: roomName ?? "",
                                            teacherName: teacherName ?? "",
                                            subjectName: subjectName ?? "",
                                            isUp: isUp ?? 2)
            lesmodels.append(sheduleLesson)
        }
        return lesmodels
    }
    
    fileprivate func convertSchOfTeacher(_ schedule: SchOfTeacher) -> [LessonModel]{
        var lessons = [LessonModel]()
        for item in schedule.lessons {
            item.timeslot.remove(at: item.timeslot.index(before: item.timeslot.endIndex))
            item.timeslot.remove(at: item.timeslot.startIndex)
            let timeslotArray = item.timeslot.components(separatedBy: ",")
            guard timeslotArray.count == 4 else { continue }
            var timeSince = timeslotArray[1]
            let dayOfWeek = timeslotArray[0]
            var timeUntil = timeslotArray[2]
            let upperLowerWeek = timeslotArray[3]
            var groups: String = ""
            var subjectName: String = ""
            var roomName: String = ""
            for cur in schedule.curricula {
                if item.id == cur.lessonId {
                    subjectName = cur.subjectName
                    roomName = cur.roomName
                }
            }
            groups = schedule.groups.filter {(group) -> Bool in group.uberid == item.uberId}.map {(group) -> String in "\(group.degree.prefix(4)) \(String(group.gradenum)) \(group.name)-\(String(group.groupnum))"}.joined(separator: ", ")
            let timeSinceArray = timeSince.components(separatedBy: ":")
            timeSince = timeSinceArray[0] + ":" + timeSinceArray[1]
            let timeUntilArray = timeUntil.components(separatedBy: ":")
            timeUntil = timeUntilArray[0] + ":" + timeUntilArray[1]
            var isUp: Int?
            switch upperLowerWeek {
            case "full":
                isUp = 2
            case "upper":
                isUp = 0
            case "lower":
                isUp = 1
            default:
                break
            }
            let sheduleLesson = LessonModel(dayOfWeek: Int(dayOfWeek)!,
                                            timeSince: timeSince,
                                                   timeBefore: timeUntil,
                                                   room: roomName,
                                                   teacherName: groups,
                                                   subjectName: subjectName,
                                                   isUp: isUp!)
            lessons.append(sheduleLesson)
        }
        return lessons
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = header
        
        /*let shedJSON = """
        {"lessons":[{"id":11214,"uberid":1166,"subcount":1,"timeslot":"(0,08:00:00,09:35:00,full)"},{"id":11215,"uberid":1165,"subcount":1,"timeslot":"(0,13:45:00,15:20:00,full)"},{"id":11236,"uberid":1165,"subcount":1,"timeslot":"(1,08:00:00,09:35:00,lower)"},{"id":11241,"uberid":1165,"subcount":1,"timeslot":"(1,09:50:00,11:25:00,full)"},{"id":11246,"uberid":1180,"subcount":1,"timeslot":"(1,11:55:00,13:30:00,full)"},{"id":11260,"uberid":1180,"subcount":1,"timeslot":"(1,13:45:00,15:20:00,lower)"},{"id":11265,"uberid":1165,"subcount":1,"timeslot":"(0,11:55:00,13:30:00,full)"},{"id":11294,"uberid":1180,"subcount":2,"timeslot":"(3,08:00:00,09:35:00,full)"},{"id":11308,"uberid":1180,"subcount":1,"timeslot":"(3,09:50:00,11:25:00,full)"},{"id":11325,"uberid":1165,"subcount":1,"timeslot":"(4,08:00:00,09:35:00,lower)"},{"id":11330,"uberid":1165,"subcount":1,"timeslot":"(4,09:50:00,11:25:00,full)"},{"id":11335,"uberid":1180,"subcount":1,"timeslot":"(4,11:55:00,13:30:00,full)"},{"id":11348,"uberid":1190,"subcount":1,"timeslot":"(2,08:00:00,09:35:00,full)"},{"id":11352,"uberid":1190,"subcount":1,"timeslot":"(2,09:50:00,11:25:00,full)"},{"id":11357,"uberid":1190,"subcount":1,"timeslot":"(2,11:55:00,13:30:00,full)"},{"id":11370,"uberid":1180,"subcount":2,"timeslot":"(5,08:00:00,09:35:00,full)"},{"id":11374,"uberid":1180,"subcount":1,"timeslot":"(5,09:50:00,11:25:00,full)"}],"curricula":[{"id":13831,"lessonid":11214,"subnum":1,"subjectid":140,"subjectname":"Физическая культура и спорт","subjectabbr":"ФК и спорт","teacherid":251,"teachername":"","teacherdegree":"","roomid":135,"roomname":"Online(Teams)"},{"id":13832,"lessonid":11215,"subnum":1,"subjectid":481,"subjectname":"Непрерывная математика","subjectabbr":"","teacherid":4,"teachername":"Абрамян Анна Владимировна","teacherdegree":"Доцент","roomid":10,"roomname":"120"},{"id":13856,"lessonid":11236,"subnum":1,"subjectid":477,"subjectname":"Алгебра и геометрия","subjectabbr":"АиГ","teacherid":48,"teachername":"Ерусалимский Яков Михайлович","teacherdegree":"Профессор","roomid":10,"roomname":"120"},{"id":13862,"lessonid":11241,"subnum":1,"subjectid":66,"subjectname":"Дискретная математика и математическая логика","subjectabbr":"ДМ и МЛ","teacherid":48,"teachername":"Ерусалимский Яков Михайлович","teacherdegree":"Профессор","roomid":10,"roomname":"120"},{"id":13867,"lessonid":11246,"subnum":1,"subjectid":477,"subjectname":"Алгебра и геометрия","subjectabbr":"АиГ","teacherid":185,"teachername":"Чернявская Ирина Алексеевна","teacherdegree":"Доцент","roomid":31,"roomname":"304"},{"id":13883,"lessonid":11260,"subnum":1,"subjectid":481,"subjectname":"Непрерывная математика","subjectabbr":"","teacherid":329,"teachername":"Зеленина Анастасия А.","teacherdegree":"","roomid":15,"roomname":"206"},{"id":13889,"lessonid":11265,"subnum":1,"subjectid":477,"subjectname":"Алгебра и геометрия","subjectabbr":"АиГ","teacherid":48,"teachername":"Ерусалимский Яков Михайлович","teacherdegree":"Профессор","roomid":10,"roomname":"120"},{"id":13923,"lessonid":11294,"subnum":1,"subjectid":252,"subjectname":"Основы программирования","subjectabbr":"Основы прогр.","teacherid":362,"teachername":"Кобзарь Д.В","teacherdegree":"","roomid":12,"roomname":"202"},{"id":13924,"lessonid":11294,"subnum":2,"subjectid":252,"subjectname":"Основы программирования","subjectabbr":"Основы прогр.","teacherid":363,"teachername":"Николаев А.В.","teacherdegree":"","roomid":12,"roomname":"202"},{"id":13938,"lessonid":11308,"subnum":1,"subjectid":140,"subjectname":"Физическая культура и спорт","subjectabbr":"ФК и спорт","teacherid":251,"teachername":"","teacherdegree":"","roomid":42,"roomname":"315"},{"id":13962,"lessonid":11325,"subnum":1,"subjectid":252,"subjectname":"Основы программирования","subjectabbr":"Основы прогр.","teacherid":109,"teachername":"Михалкович Станислав Станиславович","teacherdegree":"Доцент","roomid":10,"roomname":"120"},{"id":13967,"lessonid":11330,"subnum":1,"subjectid":252,"subjectname":"Основы программирования","subjectabbr":"Основы прогр.","teacherid":109,"teachername":"Михалкович Станислав Станиславович","teacherdegree":"Доцент","roomid":10,"roomname":"120"},{"id":13972,"lessonid":11335,"subnum":1,"subjectid":481,"subjectname":"Непрерывная математика","subjectabbr":"","teacherid":329,"teachername":"Зеленина Анастасия А.","teacherdegree":"","roomid":16,"roomname":"207"},{"id":13985,"lessonid":11348,"subnum":1,"subjectid":89,"subjectname":"Иностранный язык","subjectabbr":"Ин. яз.","teacherid":251,"teachername":"","teacherdegree":"","roomid":97,"roomname":""},{"id":13989,"lessonid":11352,"subnum":1,"subjectid":89,"subjectname":"Иностранный язык","subjectabbr":"Ин. яз.","teacherid":251,"teachername":"","teacherdegree":"","roomid":97,"roomname":""},{"id":13995,"lessonid":11357,"subnum":1,"subjectid":89,"subjectname":"Иностранный язык","subjectabbr":"Ин. яз.","teacherid":251,"teachername":"","teacherdegree":"","roomid":97,"roomname":""},{"id":14008,"lessonid":11370,"subnum":1,"subjectid":252,"subjectname":"Основы программирования","subjectabbr":"Основы прогр.","teacherid":362,"teachername":"Кобзарь Д.В","teacherdegree":"","roomid":12,"roomname":"202"},{"id":14009,"lessonid":11370,"subnum":2,"subjectid":252,"subjectname":"Основы программирования","subjectabbr":"Основы прогр.","teacherid":363,"teachername":"Николаев А.В.","teacherdegree":"","roomid":12,"roomname":"202"},{"id":14014,"lessonid":11374,"subnum":1,"subjectid":520,"subjectname":"Математическая логика и дискретная математика","subjectabbr":"МЛиДМ","teacherid":251,"teachername":"","teacherdegree":"","roomid":17,"roomname":"208"}]}
        """.data(using: .utf8)!
        
        let jsonDecoder = JSONDecoder()
        let schedule = try! jsonDecoder.decode(SchOfGroup.self, from: shedJSON)
         
         lessonmodels = convertSchOfGroup(schedule).sorted(by: {($0.dayOfWeek,$0.timeSince) < ($1.dayOfWeek,$1.timeSince)})
         
         daysOfWeek = Array(Set(lessonmodels.map { (les) -> Int in les.dayOfWeek })).sorted()
         self.collectionView.reloadData()
         */
        switch role {
        case "Student":
            network.getGroupSchedule(id) { result in
                switch result {
                case let .success(schedule):
                    self.lessonmodels = self.convertSchOfGroup(schedule).sorted(by: {($0.dayOfWeek,$0.timeSince) < ($1.dayOfWeek,$1.timeSince)})
                    self.daysOfWeek = Array(Set(self.lessonmodels.map { (les) -> Int in les.dayOfWeek })).sorted()
                    self.collectionView.reloadData()
                case let .failure(error):
                    print(error)
                }
            }
        case "Teacher":
            network.getTeacherSchedule(id) { result in
                switch result {
                case let .success(schedule):
                    self.lessonmodels = self.convertSchOfTeacher(schedule).sorted(by: {($0.dayOfWeek,$0.timeSince) < ($1.dayOfWeek,$1.timeSince)})
                    self.daysOfWeek = Array(Set(self.lessonmodels.map { (les) -> Int in les.dayOfWeek })).sorted()
                    self.collectionView.reloadData()
                case let .failure(error):
                    print(error)
                }
            }
        default:
            print("Error: unknown role")
        }

        
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let scheduleSectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ScheduleSectionHeader", for: indexPath) as! ScheduleSectionHeader
        scheduleSectionHeader.Header = String(daysOfWeek[indexPath.section])
        return scheduleSectionHeader
    }
}

extension ScheduleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return daysOfWeek.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let day = daysOfWeek[section]
        return lessonmodels.filter { (les) -> Bool in les.dayOfWeek == day}.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentlessons = lessonmodels.filter( {$0.dayOfWeek == daysOfWeek[indexPath.section]})
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subjectCell", for: indexPath) as! SubjectCollectionCell
            cell.configure(timeS: currentlessons[indexPath.row].timeSince,
                           timeU: currentlessons[indexPath.row].timeBefore,
                           sbjName: currentlessons[indexPath.row].subjectName,
                           tchName: currentlessons[indexPath.row].teacherName,
                           roomS: currentlessons[indexPath.row].room + " к.")
        return cell

    }
}

extension ScheduleViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 20, height: 60)
    }
    
}

class ScheduleSectionHeader : UICollectionReusableView{
    @IBOutlet weak var HeaderLabel: UILabel!
    var Header: String! {
        didSet {
            HeaderLabel.text = Header
        }
    }
}
