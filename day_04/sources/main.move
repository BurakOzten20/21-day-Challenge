/// DAY 4: Vector + Ownership Basics
/// 
/// Today you will:
/// 1. Learn about vectors
/// 2. Create a list of habits
/// 3. Understand basic ownership concepts

module challenge::day_04 {
    // Standart kütüphaneden vector aracını çağırıyoruz
    use std::vector;

    // --- Day 3'ten gelen yapımız ---
    public struct Habit has copy, drop {
        name: vector<u8>,
        completed: bool,
    }

    public fun new_habit(name: vector<u8>): Habit {
        Habit {
            name: name,
            completed: false,
        }
    }

    // --- DAY 4 GÖREVLERİ ---

    // 1. GÖREV: Alışkanlık listesini (Vector) tutan yapı
    // 'drop' yeteneği ekledik ki işimiz bitince silinebilsin.
    public struct HabitList has drop {
        habits: vector<Habit>,
    }

    // 2. GÖREV: Boş bir liste oluşturan fonksiyon
    public fun empty_list(): HabitList {
        HabitList {
            habits: vector::empty(), // İçine henüz hiçbir şey koymadık
        }
    }

    // 3. GÖREV: Listeye eleman ekleme fonksiyonu
    // list: &mut HabitList -> '&mut' demek "bu listeyi değiştirebilirim" demektir.
    // habit: Habit -> Eklenecek veri
    public fun add_habit(list: &mut HabitList, habit: Habit) {
        // vector::push_back komutu listeye yeni eleman ekler
        vector::push_back(&mut list.habits, habit);
    }
}