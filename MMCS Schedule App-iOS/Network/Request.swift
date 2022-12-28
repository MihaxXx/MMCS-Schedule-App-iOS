//
//  Request.swift
//  TheNews
//
//  Created by Михаил on 09.11.2022.

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

struct Request {
    static let headers = [
        "Accept": "application/json",
        "Content-Type": "application/json",
    ]
    var baseURL = "https://schedule.sfedu.ru/"
    
    enum EndPoints {
        case groupschedule(groupID: Int)
        case teacherlist
        case teacherschedule(teacherID: Int)
        case gradelist
        case grouplist(gradeID: Int)
        
        func getPath() -> String {
            switch self {
            case .groupschedule(let groupID):
                return "APIv1/schedule/group/"+String(groupID)
            case .teacherlist:
                return "APIv1/teacher/list"
            case .teacherschedule(let teacherID):
                return "APIv1/schedule/teacher/"+String(teacherID)
            case .gradelist:
                return "APIv1/grade/list"
            case .grouplist(let gradeID):
                return "APIv1/group/forGrade/"+String(gradeID)
            }
        }
        
        func getHeaders() -> [String: String] {
            return [
                "Accept": "application/json",
                "Content-Type": "application/json",
                "Host": "schedule.sfedu.ru"
            ]
        }
        
        func getParameters() -> [String: String] {
            return [:]
        }
        
        func parametersToString() -> String {
            let parameterArray = getParameters().map { key, value in
                return "\(key)=\(value)"
            }
            return parameterArray.joined(separator: "&")
        }
    }
    
    func makeRequest(for endPoint: EndPoints) -> URLRequest {
        let fullURL = URL(string: baseURL.appending("\(endPoint.getPath())?\(endPoint.parametersToString())"))!
        
        var request = URLRequest(url: fullURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.allHTTPHeaderFields = endPoint.getHeaders()
        
        return request
    }
}
