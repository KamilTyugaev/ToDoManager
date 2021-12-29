//
//  TaskEditController.swift
//  ToDoManager
//
//  Created by IosDeveloper on 25.12.2021.
//
//
//  TaskEditController.swift
//  To-Do Manager
//
//  Created by Vasily Usov on 06.03.2021.
//

import UIKit

class TaskEditController: UITableViewController {
    
    
    // параметры задачи
    var taskText: String = ""
    var taskType: TaskPriority = .normal
    var taskStatus: TaskStatus = .planned
    
    // обработчик создания/редактирования задачи
    var doAfterEdit: ((String, TaskPriority, TaskStatus) -> Void)?
    
    // Название типов задач
    private var taskTitles: [TaskPriority:String] = [
        .important: "Важная",
        .normal: "Текущая"
    ]
    
    // текстовое поле с названием задачи
    @IBOutlet var taskTitle: UITextField!
    // выбранная задача
    @IBOutlet var taskTypeLabel: UILabel!
    // переключатель статуса
    @IBOutlet var taskStatusSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        // обновление текстового поля с названием задачи
        taskTitle?.text = taskText
        // обновляем метку с текущим типом
        taskTypeLabel?.text = taskTitles[taskType]
        // обновляем статус задачи
        if taskStatus == .completed {
            taskStatusSwitch.isOn = true
        }
    }
    
    @IBAction func saveTask(_ sender: UIBarButtonItem) {
        // получаем актуальные значения
        let title = taskTitle?.text ?? ""
        let type = taskType
        let status: TaskStatus = taskStatusSwitch.isOn ? .completed : .planned
        // вызываем обработчик
        doAfterEdit?(title, type, status)
        // возвращаемся к предыдущему экрану
        navigationController?.popViewController(animated: true)
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTaskTypeScreen" {
            // ссылка на контроллер назначения
            let destination = segue.destination as! TaskTypeController
            // передача выбранного типа
            destination.selectedType = taskType
            // передача обработчика выбора типа
            destination.doAfterTypeSelected = { [self] selectedType in
                taskType = selectedType
                // обновляем метку с текущим типом
                taskTypeLabel?.text = taskTitles[taskType]
            }
        }
    }





//import UIKit
//
//class TaskEditController: UITableViewController {
//    var taskText: String = ""
//    var taskType: TaskPriority = .normal
//    var taskStatus: TaskStatus = .planned
//
//    //замыкание для передачи измененных данных из editContrlller in ListController
//    var doAfterEdit: ((String,TaskPriority,TaskStatus) -> Void)?
//
//    private var taskTitles:[TaskPriority:String] = [
//        .important:"important",
//        .normal:"current"
//    ]
//    @IBOutlet weak var taskTitle: UITextField!
//    @IBOutlet weak var taskTypeLabel: UILabel!
//    @IBOutlet weak var taskStatusSwitch: UISwitch!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        taskTitle?.text = taskText
//        taskTypeLabel?.text = taskTitles[taskType]
//        //обнавляем статаус задачи
//        if  taskStatus == .completed{
//            taskStatusSwitch.isOn = true
//        }
//        //         Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//    }
//
//
//    @IBAction func saveTask(_ sender: UIBarButtonItem) {
//        // получаем актуальные значения
//
//        let title = (taskTitle?.text) ?? ""
//        if title.isEmpty {
//            let alert = UIAlertController(title: "Error", message: "You don't write a task title.", preferredStyle: .alert)
//            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler:nil)
//            alert.addAction(alertAction)
//            self.present(alert, animated: true, completion: nil)
//            return
//        }
//        let type = taskType
//        let status: TaskStatus = taskStatusSwitch.isOn ? .completed : .planned
//        //вызываем обработчик
//        doAfterEdit?(title,type,status)
//
//        // возвращаемся к предыдущему экрану
//        navigationController?.popViewController(animated: true)
//    }
//    // MARK: - Table view data source
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 3
//    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toTaskTypeScreen"{
//            // ссылка на контроллер назначения
//            let destination = segue.destination as! TaskTypeController
//            //передача выбранного типа
//            destination.selectedType = taskType
//            // передача обработчика выбора типа
//            destination.doAfterTypeSelected = { [self] selectedType in
//                taskType = selectedType
//                //обновляем метку с текущим типом
//                taskTypeLabel?.text = taskTitles[taskType]
//            }
//        }
//    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
