//
//  TaskEditController.swift
//  ToDoManager
//
//  Created by IosDeveloper on 25.12.2021.


import UIKit

class TaskEditController: UITableViewController {
    var taskText: String = ""
    var taskType: TaskPriority = .normal
    var taskStatus: TaskStatus = .planned

    //замыкание для передачи измененных данных из editContrlller in ListController
    var doAfterEdit: ((String,TaskPriority,TaskStatus) -> Void)?

    private var taskTitles:[TaskPriority:String] = [
        .important:"important",
        .normal:"current"
    ]
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var taskTypeLabel: UILabel!
    @IBOutlet weak var taskStatusSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        taskTitle?.text = taskText
        taskTypeLabel?.text = taskTitles[taskType]
        //обнавляем статаус задачи
        if  taskStatus == .completed{
            taskStatusSwitch.isOn = true
        }
        //         Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }
   

    @IBAction func saveTask(_ sender: UIBarButtonItem) {
        // получаем актуальные значения

        let title = (taskTitle?.text) ?? ""
        if title.isEmpty {
            let alert = UIAlertController(title: "Error", message: "You don't write a task title.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler:nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        let type = taskType
        let status: TaskStatus = taskStatusSwitch.isOn ? .completed : .planned
        //вызываем обработчик
        doAfterEdit?(title,type,status)

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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTaskTypeScreen"{
            // ссылка на контроллер назначения
            let destination = segue.destination as! TaskTypeController
            //передача выбранного типа
            destination.selectedType = taskType
            // передача обработчика выбора типа
            destination.doAfterTypeSelected = { [self] selectedType in
                taskType = selectedType
                //обновляем метку с текущим типом
                taskTypeLabel?.text = taskTitles[taskType]
            }
        }
    }
}
extension String {
    func trimWhiteSpaces() -> String {
        let title = NSCharacterSet.whitespaces
        return self.trimmingCharacters(in: title)
    }
}
