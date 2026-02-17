/// DAY 6: String Type for Habit Names
/// 
/// Today you will:
/// 1. Learn about the String type
/// 2. Convert vector<u8> to String
/// 3. Update Habit to use String instead of vector<u8>

module challenge::day_06 {
    use std::vector;
    // String kütüphanesini içeri alıyoruz
    use std::string::{Self, String};

    // GÖREV 1: Habit yapısını String kullanacak şekilde güncelledik
    public struct Habit has copy, drop {
        name: String, // Artık vector<u8> değil, String!
        completed: bool,
    }

    public struct HabitList has drop {
        habits: vector<Habit>,
    }

    // GÖREV 2: Fonksiyon artık String kabul ediyor
    public fun new_habit(name: String): Habit {
        Habit {
            name,
            completed: false,
        }
    }

    // GÖREV 3: Yardımcı fonksiyon (Helper)
    // Dışarıdan gelen ham veriyi (vector<u8>) alıp String'e çevirir.
    public fun make_habit(name_bytes: vector<u8>): Habit {
        // string::utf8() komutu byte dizisini String'e dönüştürür
        let name_str = string::utf8(name_bytes);
        new_habit(name_str)
    }

    public fun empty_list(): HabitList {
        HabitList {
            habits: vector::empty(),
        }
    }

    public fun add_habit(list: &mut HabitList, habit: Habit) {
        vector::push_back(&mut list.habits, habit);
    }

    public fun complete_habit(list: &mut HabitList, index: u64) {
        let len = vector::length(&list.habits);
        if (index < len) {
            let habit = vector::borrow_mut(&mut list.habits, index);
            habit.completed = true;
        };
    }
}