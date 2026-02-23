/// DAY 12: Option for Task Lookup
/// 
/// Today you will:
/// 1. Learn about Option<T> type
/// 2. Write a function to find tasks by title
/// 3. Handle the case when task is not found

module challenge::day_12 {
    use std::vector;
    use std::string::String;
    // Option modülünü içeri aktarıyoruz
    use std::option::{Self, Option};

    // --- Önceki Günlerden Gelen Yapılar (Store yeteneği korundu) ---
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
        vector::push_back(&mut board.tasks, task);
    }

    // --- DAY 12 GÖREVİ ---

    // TODO: Write a function 'find_task_by_title' that:
    // - Takes board: &TaskBoard and title: String
    // - Returns Option<u64> (the index if found, None if not found)
    // - Loops through tasks and compares titles
    
    // Yeni Fonksiyon: Görev Bulucu (Modern yazım kullanıldı)
    public fun find_task_by_title(board: &TaskBoard, title: String): Option<u64> {
        let len = board.tasks.length(); // Panoda toplam kac gorev var?
        let mut i = 0;                  // Su an kacinci goreve bakiyorum
        
        // Klasik while dongusu, bastan sona kadar gez
        while (i < len) {
            let task = board.tasks.borrow(i); // i. siradaki goreve bak
            
            // Eger basliklar ayniysa
            if (task.title == title) {
                return option::some(i) // Buldum indeksi paketle ve don
            };
            
            i = i + 1; // Bir sonrakine gec
        };
        
        // Dongu bitti, hala buradaysak bulamamisiz demektir
        option::none() // Bos don
    }

    // --- DAY 12 TEST BLOKLARI ---
    #[test]
    fun test_search_task() {
        let owner_addr = @0xCAFE; // Örnek bir cüzdan adresi
        let mut board = new_board(owner_addr);

        // Panoya 2 gorev ekleyelim
        let task1 = new_task(b"Gorev 1".to_string(), 100);
        let task2 = new_task(b"Gorev 2".to_string(), 200);
        add_task(&mut board, task1);
        add_task(&mut board, task2);

        // 1. Senaryo: Var olan bir görevi arayalım ("Gorev 2")
        let found = find_task_by_title(&board, b"Gorev 2".to_string());
        // Sonuç 'some' (dolu) dönmeli
        assert!(option::is_some(&found), 0); 
        
        // 2. Senaryo: Olmayan bir görevi arayalım ("Gorev 3")
        let not_found = find_task_by_title(&board, b"Gorev 3".to_string());
        // Sonuç 'none' (boş) dönmeli
        assert!(option::is_none(&not_found), 1);
    }
}