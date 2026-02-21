/// DAY 10: Visibility Modifiers (Public vs Private Functions)
/// 
/// Today you will:
/// 1. Learn about visibility modifiers (public vs private)
/// 2. Design a public API
/// 3. Write a function to complete tasks

module challenge::day_10 {
    // String modülünü ve utf8 çevirisi için 'Self' fonksiyonlarını ekliyoruz
    use std::string::{Self, String};

    // TODO: Copy from day_09: TaskStatus enum and Task struct
    // İleriye dönük olarak objelerin blockchain'de saklanabilmesi için 'store' yeteneğini ekledik!
    public enum TaskStatus has copy, drop, store {
        Open,
        Completed,
    }

    public struct Task has copy, drop, store {
        title: String,
        reward: u64,
        status: TaskStatus,
    }

    // Yeni görev oluşturan ana fonksiyonumuz
    public fun new_task(title: String, reward: u64): Task {
        Task {
            title,
            reward,
            status: TaskStatus::Open, // Varsayılan olarak açık başlar
        }
    }

    // Ekstra Yardımcı: Dışarıdan gelen ham bayt verisini (vector<u8>) String'e çeviren fonksiyon
    public fun create_task(title_bytes: vector<u8>, reward: u64): Task {
        let title_str = string::utf8(title_bytes);
        new_task(title_str, reward)
    }

    public fun is_open(task: &Task): bool {
        task.status == TaskStatus::Open
    }

    // TODO: Write a public function 'complete_task'
    // Kullanıcıların dışarıdan çağırıp görevleri tamamlayabilmesi için 'public' yaptık
    public fun complete_task(task: &mut Task) {
        task.status = TaskStatus::Completed;
    }

    // TODO: (Optional) Write a private helper function
    // Güvenlik kontrolü yapan GİZLİ (private) fonksiyon. Sadece 'fun' yazılıdır.
    // Dışarıdan kimse çağıramaz, sadece bu modül içinden erişilebilir.
    fun check_reward_limit(reward: u64): bool {
        reward > 0 // Ödül miktarı sıfırdan büyük olmalı
    }

    // BONUS: Add a public function that calls your private helper
    // Dışarıya açık (public) bir fonksiyon ama arka planda bizim gizli fonksiyonu çalıştırıyor.
    public fun has_valid_reward(task: &Task): bool {
        check_reward_limit(task.reward)
    }
}