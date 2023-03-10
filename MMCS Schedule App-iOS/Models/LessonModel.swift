//
//  Models.swift
//  mmcsShed
//
//  Created by Danya on 10.05.17.
//  Copyright © 2017 Danya. All rights reserved.
//

import Foundation

class LessonModel: Codable {
	var dayOfWeek: Int
    let timeSince: String
    let timeBefore: String
    let isUpper: Int
    let room: String
    let teacherName: String
    let subjectName: String
    
    init(dayOfWeek: Int, timeSince: String, timeBefore: String, room: String, teacherName: String, subjectName: String, isUp: Int) {
        self.dayOfWeek = dayOfWeek
        self.timeSince = timeSince
        self.timeBefore = timeBefore
        self.room = room
        self.isUpper = isUp
        self.teacherName = teacherName
        self.subjectName = subjectName
    }
}
