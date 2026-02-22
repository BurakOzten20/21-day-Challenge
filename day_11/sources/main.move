/// DAY 11: TaskBoard & Address Type
/// 
/// Today you will:
/// 1. Learn about the address type
/// 2. Create a TaskBoard that tracks ownership
/// 3. Understand ownership in practice

module challenge::day_11 {
    use std::vector;
    use std::string::String;

    // Day 10'dan gelen yapılar (İleriye dönük 'store' yetenekleri korundu)
    public enum TaskStatus has copy, drop, store {
        Open,
        Completed,
    }

    public struct Task has copy, drop, store {
        title: String,
        reward: u64,
        status: TaskStatus,
    }

    public fun new_task(title: String, reward: u64): Task {
        Task {
            title,
            reward,
            status: TaskStatus::Open,
        }
    }

    public fun complete_task(task: &mut Task) {
        task.status = TaskStatus::Completed;
    }

    // --- DAY 11 GÖREVLERİ ---

    // GÖREV 1: 'TaskBoard' adında yeni bir yapı oluşturuyoruz.
    // Bu pano bir cüzdan adresine (owner) ve bir görev listesine (tasks) sahip.
    public struct TaskBoard has drop {
        owner: address,
        tasks: vector<Task>,
    }

    // GÖREV 2: Yeni ve içi boş bir görev panosu (TaskBoard) oluşturan fonksiyon.
    public fun new_board(owner: address): TaskBoard {
        TaskBoard {
            owner,                   // Panonun sahibini kaydediyoruz
            tasks: vector::empty(),  // Başlangıçta görev listesi boş bir vektör
        }
    }

    // GÖREV 3: Panoya yeni bir görev (Task) ekleyen fonksiyon.
    public fun add_task(board: &mut TaskBoard, task: Task) {
        // vector::push_back ile 'task' objesini 'board.tasks' listesinin sonuna ekliyoruz.
        vector::push_back(&mut board.tasks, task);
    }
}