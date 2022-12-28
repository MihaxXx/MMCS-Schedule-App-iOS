//
//  Grade.swift
//  MMCS Schedule App-iOS
//
//  Created by Михаил on 27.12.2022.
//

import Foundation

class Grade: Codable {
    let id, num: Int
    let degree: String

    init(id: Int, num: Int, degree: String) {
        self.id = id
        self.num = num
        self.degree = degree
    }
}

class Group: Codable {
    let id: Int
    let name: String
    let num, gradeid, grorder: Int

    init(id: Int, name: String, num: Int, gradeid: Int, grorder: Int) {
        self.id = id
        self.name = name
        self.num = num
        self.gradeid = gradeid
        self.grorder = grorder
    }
}

class TechGroup: Codable {
    let degree, name: String
    let uberid, groupnum, gradenum: Int
}

