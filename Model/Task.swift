//
//  Task.swift
//  ToDoManager
//
//  Created by IosDeveloper on 18.12.2021.
//

import UIKit

//тип задачи
enum TaskPriority{
    //текущая
    case normal
    //важнaя
    case important
}

//состояние задачи
enum TaskStatus:Int{
    //запланированная
    case planned
    //выполненная
    case completed
    
}

// требования к типу, описывающему сущность "Задача"
protocol TaskProtocol {
    var title: String { get set }
    var type: TaskPriority { get set }
    var status: TaskStatus { get set }
}
// сущность "Задача"
struct Task: TaskProtocol {
    var title: String
    var type: TaskPriority
    var status: TaskStatus
}


