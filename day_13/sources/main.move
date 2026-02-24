/// DAY 13: Simple Aggregations (Total Reward, Completed Count)
/// 
/// Today you will:
/// 1. Write functions that iterate over vectors
/// 2. Calculate totals and counts
/// 3. Practice with control flow

module challenge::day_13 {
    use std::string::String;
    // Sarı uyarı vermemesi için 'vector' ve 'option' kütüphanelerini sildik, Move 2024 bunları otomatik tanır.

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

    public fun find_task_by_title(board: &TaskBoard, title: String): Option<u64> {
        let len = board.tasks.length();
        let mut i = 0;
        while (i < len) {
            let task = board.tasks.borrow(i);
            if (task.title == title) {
                return option::some(i)
            };
            i = i + 1;
        };
        option::none()
    }

    // TODO: Write a function 'total_reward' that:
    // - Takes board: &TaskBoard
    // - Returns u64 (sum of all task rewards)
    // - Loops through all tasks and sums their rewards
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

    // TODO: Write a function 'completed_count' that:
    // - Takes board: &TaskBoard
    // - Returns u64 (count of completed tasks)
    // - Loops through tasks and counts those with status == Completed
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
}