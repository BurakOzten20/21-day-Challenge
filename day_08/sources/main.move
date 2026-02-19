/// DAY 8: New Module & Simple Task Struct
/// 
/// Today you will:
/// 1. Start a new project: Task Bounty Board
/// 2. Create a Task struct
/// 3. Write a constructor function

module challenge::day_08 {
    use std::string::String;

    // GÖREV 1: 'Task' adında bir yapı oluşturuyoruz
    public struct Task has copy, drop {
        title: String, // Görevin adı (örn: "Sistem Açığını Bul")
        reward: u64,   // Verilecek ödül miktarı
        done: bool,    // Tamamlandı mı?
    }

    // GÖREV 2: Yeni bir görev oluşturan fonksiyon
    public fun new_task(title: String, reward: u64): Task {
        Task {
            title,           // Parametreden gelen isim
            reward,          // Parametreden gelen ödül
            done: false,     // Yeni görev başta her zaman 'tamamlanmamış' olur
        }
    }
}