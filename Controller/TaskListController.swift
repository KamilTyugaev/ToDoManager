//
//  TaskListController.swift
//  ToDoManager
//
//  Created by IosDeveloper on 18.12.2021.
//

import UIKit

class TaskListController: UITableViewController {
    // хранилище задач
    var tasksStorage:TasksStorageProtocol = TasksStorage()
    //коллекция задач
    var tasks: [TaskPriority:[TaskProtocol]] = [:]
    // порядок отображения секций по типам
    // индекс в массиве соответствует индексу секции в таблице
    var sectionTypesPosition:[TaskPriority] = [.important, .normal]
    var tasksStatusPosition: [TaskStatus] = [.planned, .completed]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //загрузка задач
        loadTasks()
        // self.clearsSelectionOnViewWillAppear = false

        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    private func loadTasks(){
        // подготовка коллекции с задачами
        // будем использовать только те задачи, для которых определена секция в таблице
        sectionTypesPosition.forEach { taskType in
            tasks[taskType] = []
        }
        // загрузка и разбор задач из хранилища
        tasksStorage.loadTasks().forEach { task in
            tasks[task.type]?.append(task)
        }
        for (taskGroupPriority, taskGroup) in tasks {
            tasks[taskGroupPriority] = taskGroup.sorted(by: { (task1, task2)  in
                let task1positoon = tasksStatusPosition.firstIndex(of: task1.status) ?? 0
                let task2position = tasksStatusPosition.firstIndex(of: task2.status) ?? 0
                return task1positoon < task2position
            })
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // определяем приоритет задач, соответствующий текущей секции
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // определяем приоритет задач, соответствующий текущей секции
        let taskType = sectionTypesPosition[section]
        guard let currentTasksType = tasks[taskType] else {
            return 0
        }
        return currentTasksType.count
    }

    // ячейка для строки таблицы
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // ячейка на основе констрейтов
        //        return getConfiguredTaskCell_constraints(for: indexPath)
        // ячейка на основе стэка
        return getConfiguredTaskCell_stack(for: indexPath)
    }
    //use prototype with constraints
    private func getConfiguredTaskCell_constraints(for indexPath:IndexPath) -> UITableViewCell{
        //загружаем прототип ячейки по идентификатору
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellConstraints", for: indexPath)
        // получаем данные о задаче, которую необходимо вывести в ячейке
        let taskType = sectionTypesPosition[indexPath.section]
        guard let currentTask = tasks[taskType]?[indexPath.row] else {
            return cell
        }
        //текстовая метка символа
        let symbolLabel = cell.viewWithTag(1) as? UILabel
        //текстовая метка названия задачи
        let textLabel = cell.viewWithTag(2) as? UILabel
        
        //change(изменяем) символ в ячейку
        symbolLabel?.text = getSymbolForTask(with: currentTask.status)
        //change text in cell
        textLabel?.text = currentTask.title
        
        //изменяем цвет текста и символа
        if currentTask.status == .planned{
            textLabel?.textColor = .black
            symbolLabel?.textColor = .black
        }else{
            textLabel?.textColor = .lightGray
            symbolLabel?.textColor = .lightGray
        }
        return cell
    }
    //use prototype with stack
    private func getConfiguredTaskCell_stack(for indexPath:IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellStack", for:indexPath) as! TaskCell
        let taskType = sectionTypesPosition[indexPath.section]
        guard let currentTask = tasks[taskType]?[indexPath.row] else {
            return cell
        }
        cell.title.text = currentTask.title
        cell.symbol.text = getSymbolForTask(with: currentTask.status)
        
        if currentTask.status == .planned{
            cell.title.textColor = .black
            cell.symbol.textColor = .black
        }else{
            cell.title.textColor = .lightGray
            cell.symbol.textColor = .lightGray
        }
        return cell
    }

    // возвращаем символ для соответствующего типа задачи
    private func getSymbolForTask(with status: TaskStatus) -> String{
        var resultSymbol: String
        if status == .planned {
            resultSymbol = "\u{25CB}"
        }else if status == .completed {
            resultSymbol = "\u{25C9}"
        }else{
            resultSymbol = ""
        }
        return resultSymbol
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String?
        let tasksType = sectionTypesPosition[section]
        if tasksType == .important {
            title = "Важные"
        } else if tasksType == .normal {
            title = "Текущие"
        }
        return title
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
