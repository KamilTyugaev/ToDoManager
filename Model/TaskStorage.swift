//
//  TaskStorage.swift
//  ToDoManager
//
//  Created by IosDeveloper on 18.12.2021.
//

import UIKit

// Протокол, описывающий сущность "Хранилище задач"
protocol TasksStorageProtocol {
    func loadTasks() -> [TaskProtocol]
    func saveTasks(_ tasks:[TaskProtocol])
}

// Сущность "Хранилище задач"
class TasksStorage: TasksStorageProtocol {
    func loadTasks() -> [TaskProtocol] {
            let testTask:[TaskProtocol] = [
                Task(title: "write dz popsix", type: .important, status: .planned),
                Task(title: "Change my", type: .normal, status: .planned),
                Task(title: "work IOS", type: .normal, status: .planned),
                Task(title: "Help family", type: .important, status: .planned),
                Task(title: "Lern English", type: .important, status: .planned),
                Task(title: "write k\r", type: .important, status: .completed),
                Task(title: "eat apple", type: .normal, status: .planned)
            ]
            return testTask
        }
    
    func saveTasks(_ tasks: [TaskProtocol]) {}
}
