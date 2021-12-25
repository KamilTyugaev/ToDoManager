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
                Task(title: "write dz popsix", type: .important, status: .completed),
                Task(title: "Change my", type: .normal, status: .planned),
                Task(title: "work IOS", type: .normal, status: .planned),
                Task(title: "Help family", type: .important, status: .planned),
                Task(title: "Lern English", type: .important, status: .planned),
                Task(title: "write k", type: .important, status: .completed),
                Task(title: "eat apple", type: .normal, status: .completed),
                Task(title: "do clear all tasks in App ToDoManager", type:.important , status: .planned),
                Task(title: "Пригласить на вечеринку Дольфа, Джеки, Леонардо, Уилла и Брюса", type: .important, status: .completed)
            ]
            return testTask
        }
    
    func saveTasks(_ tasks: [TaskProtocol]) {}
}
