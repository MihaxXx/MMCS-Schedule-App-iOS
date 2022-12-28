//
//  CurriculaServerModel.swift
//  mmcsShed
//
//  Created by Danya on 10.05.17.
//  Copyright © 2017 Danya. All rights reserved.
//
import Foundation

struct SchOfGroup: Codable{
    var lessons: [LessonServerModel]
    var curricula: [CurriculaServerModel]
}

struct SchOfTeacher: Codable {
    var lessons: [LessonServerModel]
    var curricula: [CurriculaServerModel]
    var groups: [TechGroup]
}

struct CurriculaServerModel: Codable {
	
	var roomid: Int
	var teacherDegree: String
	var id: Int
	var subjectId: Int
	var roomName: String
	var lessonId: Int
	var teacherId: Int
	var subjectAbbr: String
	var teacherName: String
	var subjectName: String
    
    enum CodingKeys : String, CodingKey {
        case roomid
        case teacherDegree = "teacherdegree"
        case id
        case subjectId = "subjectid"
        case roomName = "roomname"
        case lessonId = "lessonid"
        case teacherId = "teacherid"
        case subjectAbbr = "subjectabbr"
        case teacherName = "teachername"
        case subjectName = "subjectname"
    }
}
