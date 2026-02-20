/// DAY 9: Enums & TaskStatus
/// 
/// Today you will:
/// 1. Learn about enums
/// 2. Replace bool with an enum
/// 3. Use match expressions

module challenge::day_09 {
    use std::string::String;

    // GÖREV 1: 'TaskStatus' adında yeni bir enum oluşturduk
    public enum TaskStatus has copy, drop {
        Open,
        Completed,
    }

    // GÖREV 2: Task yapısını güncelledik (bool yerine TaskStatus kullanıyor)
    public struct Task has copy, drop {
        title: String,
        reward: u64,
        status: TaskStatus, 
    }

    // GÖREV 3: Yeni görev oluştururken durumu başlangıçta 'Open' (Açık) yapıyoruz
    public fun new_task(title: String, reward: u64): Task {
        Task {
            title,
            reward,
            status: TaskStatus::Open, // Burada enum'dan Open'ı seçtik
        }
    }

    // GÖREV 4: Görevin açık olup olmadığını kontrol eden fonksiyon
    public fun is_open(task: &Task): bool {
        // Eğer statüs Open ise 'true', değilse 'false' döner
        task.status == TaskStatus::Open
    }
}