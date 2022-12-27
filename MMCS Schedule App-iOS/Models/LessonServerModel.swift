//
//  LessonServerModel.swift
//  mmcsShed
//
//  Created by Danya on 10.05.17.
//  Copyright © 2017 Danya. All rights reserved.
//
import Foundation

class LessonServerModel: Codable {
	
	var id: Int
	var subcount: Int
	var uberId: Int
	var timeslot: String
    
    enum CodingKeys : String, CodingKey {
        case uberId = "uberid"
        case id
        case subcount
        case timeslot
    }
}
