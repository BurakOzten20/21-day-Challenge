module challenge::day_14 {
    use std::string::{Self, String};

    // --- YAPILAR (STRUCTS) & ENUMLAR ---

    public enum TaskStatus has copy, drop, store {
        Open,
        Completed,
    }

    public struct Task has copy, drop, store {
        title: String,
        reward: u64,
        status: TaskStatus,
    }

    public struct TaskBoard has drop {
        owner: address,
        tasks: vector<Task>,
    }

    // --- ANA FONKSİYONLAR ---

    public fun new_task(title: String, reward: u64): Task {
        Task {
            title,
            reward,
            status: TaskStatus::Open,
        }
    }

    public fun new_board(owner: address): TaskBoard {
        TaskBoard {
            owner,
            tasks: vector::empty(),
        }
    }

    public fun add_task(board: &mut TaskBoard, task: Task) {
        board.tasks.push_back(task);
    }

    public fun complete_task(task: &mut Task) {
        task.status = TaskStatus::Completed;
    }

    public fun total_reward(board: &TaskBoard): u64 {
        let len = board.tasks.length();
        let mut total = 0;
        let mut i = 0;
        while (i < len) {
            let task = board.tasks.borrow(i);
            total = total + task.reward;
            i = i + 1;
        };
        total
    }

    public fun completed_count(board: &TaskBoard): u64 {
        let len = board.tasks.length();
        let mut count = 0;
        let mut i = 0;
        while (i < len) {
            let task = board.tasks.borrow(i);
            if (task.status == TaskStatus::Completed) {
                count = count + 1;
            };
            i = i + 1;
        };
        count
    }

    // --- TESTLER ---

    // Test 1: Pano oluşturma ve görev ekleme testi
    #[test]
    fun test_create_board_and_add_task() {
        let owner = @0x1;
        let mut board = new_board(owner);
        let task = new_task(string::utf8(b"Siber Guvenlik Gorevi"), 500);
        
        add_task(&mut board, task);
        
        // Görev başarıyla eklendi mi kontrolü
        assert!(board.tasks.length() == 1, 0);
    }

    // Test 2: Görev tamamlama testi
    #[test]
    fun test_complete_task() {
        let owner = @0x1;
        let mut board = new_board(owner);
        
        let mut task1 = new_task(string::utf8(b"Gorev 1"), 100);
        let task2 = new_task(string::utf8(b"Gorev 2"), 200);
        
        complete_task(&mut task1);
        
        add_task(&mut board, task1);
        add_task(&mut board, task2);
        
        // Sadece 1 görev tamamlandığı için sonuç 1 olmalı
        assert!(completed_count(&board) == 1, 1);
    }

    // Test 3: Toplam ödül hesaplama testi
    #[test]
    fun test_total_reward() {
        let owner = @0x1;
        let mut board = new_board(owner);
        
        let task1 = new_task(string::utf8(b"Gorev 1"), 150);
        let task2 = new_task(string::utf8(b"Gorev 2"), 350);
        
        add_task(&mut board, task1);
        add_task(&mut board, task2);
        
        // Toplam ödül 150 + 350 = 500 olmalı
        assert!(total_reward(&board) == 500, 2);
    }
}