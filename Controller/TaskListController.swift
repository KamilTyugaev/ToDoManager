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
    var tasks: [TaskPriority:[TaskProtocol]] = [:]{
        didSet {
            for (tasksGroupPriority, tasksGroup) in tasks {
                tasks[tasksGroupPriority] = tasksGroup.sorted{ task1, task2  in
                    let task1position = tasksStatusPosition.firstIndex(of: task1.status) ?? 0
                    let task2position = tasksStatusPosition.firstIndex(of: task2.status) ?? 0
                    return task1position < task2position
                    
                }
            }
        }
    }
    // порядок отображения секций по типам
    // индекс в массиве соответствует индексу секции в таблице
    var sectionTypesPosition:[TaskPriority] = [.important, .normal]
    var tasksStatusPosition: [TaskStatus] = [.planned, .completed]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //загрузка задач
        loadTasks()
        // self.clearsSelectionOnViewWillAppear = false
        // кнопка активации режима редактирования
         self.navigationItem.leftBarButtonItem = self.editButtonItem
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
        return getConfiguredTaskCell_constraints(for: indexPath)
        // ячейка на основе стэка
//        return getConfiguredTaskCell_stack(for: indexPath)
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
            title = "Important"
        } else if tasksType == .normal {
            title = "Current"
        }
        return title
    }
    
    //Разрабатываем функционал(для изменения с "планированного" на "выполнено") при нажатии на cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1. Проверяем существование задачи
        let tasksType = sectionTypesPosition[indexPath.section]
        guard let _ = tasks[tasksType]?[indexPath.row] else {
            return
        }
        //2 Убеждаемся что задача является невыполненной
        guard tasks[tasksType]?[indexPath.row].status == .planned else {
            //снимаем выделение строки
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        //отмечаем задачу как выполненную
        tasks[tasksType]![indexPath.row].status = .completed
        //перезагружаем секцию таблицы
        tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
    }
    //Разрабатываем функционал(для изменения с "выполнено" на "планированно") при свайпе направо
     override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // 1. Проверяем существование задачи
        let tasksType = sectionTypesPosition[indexPath.section]
        guard let _ = tasks[tasksType]?[indexPath.row] else {
            return nil
        }
        //2 Убеждаемся что задача является выполненной
        guard tasks[tasksType]![indexPath.row].status == .completed  else {
            //снимаем выделение строки
            return nil
        }
        
        let actionSwipeInstance = UIContextualAction(style: .destructive, title: "Cancel completed") { _, _,_  in
            self.tasks[tasksType]![indexPath.row].status = .planned
            self.tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
        }
        return UISwipeActionsConfiguration(actions: [actionSwipeInstance])
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0{
            return false
        }
        return true
    }
    // Первая строка каждой секции таблицы имеет стиль .insert, а остальные .delete:
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.row == 0{
            return .insert
        }
        return.delete
    }
    //item Edit при нажатии позволяет изменять данные таблицы(здесь мы удаляем задачу)
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let taskType = sectionTypesPosition[indexPath.section]
        // удаляем задачу
        tasks[taskType]?.remove(at: indexPath.row)
        // удаляем строку, соответствующую задаче
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    //item Edit при нажатии позволяет изменять данные таблицы(здесь мы сортируем задачу куда хотим)
   // Разрешить перемещать все строки, кроме первой в первой секции.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 && indexPath.row == 0{ // это условие для первой строки а  просто return true
           return false
        }
        return true
    }
//    Метод UITableViewDataSource.tableView(_:moveRowAt:to:)
//    Вызывается при изменении позиции строки с moveRowAt на to.
   // ● to: IndexPath – конечная позиция строки.
    
    // ручная сортировка списка задач
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        // секция, из которой происходит перемещение
        let taskTypeFrom = sectionTypesPosition[sourceIndexPath.section]
        // секция, в которую происходит перемещение
        let taskTypeTo = sectionTypesPosition[destinationIndexPath.section]
        //безопасно извлекаем задачу, тем самым копируем ее
        guard let moveTask = tasks[taskTypeFrom]?[sourceIndexPath.row] else {
            return
        }
        
        tasks[taskTypeFrom]!.remove(at: sourceIndexPath.row)
        // вставляем задачу на новую позицию
        tasks[taskTypeTo]!.insert(moveTask, at: destinationIndexPath.row)
        // если секция изменилась, изменяем тип задачи в соответствии с новой позицией
        if taskTypeFrom != taskTypeTo{
            tasks[taskTypeTo]?[destinationIndexPath.row].type = taskTypeTo
        }
        // обновляем данные
        tableView.reloadData()
    }
 

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCreateScreen"{
            let destination = segue.destination as! TaskEditController
            destination.doAfterEdit = { [unowned self] title, type, status in
                let newTask = Task(title: title, type: type, status: status)
                self.tasks[type]?.append(newTask)
                tableView.reloadData()
            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
