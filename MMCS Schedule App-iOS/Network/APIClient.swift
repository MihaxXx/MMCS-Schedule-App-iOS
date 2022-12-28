//
//  APIClient.swift
//  TheNews
//
//  Created by Михаил on 09.11.2022.

import Foundation

class APIClient {
    let urlSession = URLSession.shared
    
    func getGroupList(_ gradeID: Int, completion: @escaping (Result<[Group]>) -> ()) {
        let request = Request().makeRequest(for: .grouplist(gradeID: gradeID))
        urlSession.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, let data = data {
                let result = Response.handleResponse(for: response)
                switch result {
                case .success:
                    let result = try? JSONDecoder().decode([Group].self, from: data)
                    DispatchQueue.main.async {
                        completion(Result.success(result!))
                    }
                case .failure:
                    completion(Result.failure(NetworkError.decodingFailed))
                }
            }
        }.resume()
    }
    func getGradeList(completion: @escaping (Result<[Grade]>) -> ()) {
        let request = Request().makeRequest(for: .gradelist)
        urlSession.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, let data = data {
                let result = Response.handleResponse(for: response)
                switch result {
                case .success:
                    let result = try? JSONDecoder().decode([Grade].self, from: data)
                    DispatchQueue.main.async {
                        completion(Result.success(result!))
                    }
                case .failure:
                    completion(Result.failure(NetworkError.decodingFailed))
                }
            }
        }.resume()
    }
    func getTeacherList(completion: @escaping (Result<[Teacher]>) -> ()) {
        let request = Request().makeRequest(for: .teacherlist)
        urlSession.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, let data = data {
                let result = Response.handleResponse(for: response)
                switch result {
                case .success:
                    let result = try? JSONDecoder().decode([Teacher].self, from: data)
                    DispatchQueue.main.async {
                        completion(Result.success(result!))
                    }
                case .failure:
                    completion(Result.failure(NetworkError.decodingFailed))
                }
            }
        }.resume()
    }
    func getGroupSchedule(_ groupID: Int, completion: @escaping (Result<SchOfGroup>) -> ()) {
        let request = Request().makeRequest(for: .groupschedule(groupID: groupID))
        urlSession.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, let data = data {
                let result = Response.handleResponse(for: response)
                switch result {
                case .success:
                    let result = try? JSONDecoder().decode(SchOfGroup.self, from: data)
                    DispatchQueue.main.async {
                        completion(Result.success(result!))
                    }
                case .failure:
                    completion(Result.failure(NetworkError.decodingFailed))
                }
            }
        }.resume()
    }
}
