/// DAY 3: Structs (Habit Model Skeleton)
///
/// Today you will:
/// 1. Learn about structs
/// 2. Create a Habit struct
/// 3. Write a constructor function

module challenge::day_03 {
    // 1. GÖREV: 'Habit' adında bir yapısı (struct) 
    public struct Habit has copy, drop {
        name: vector<u8>, 
        completed: bool,  
    }

    // Yeni alışkanlık oluşturan fonksiyon
    public fun new_habit(name: vector<u8>): Habit {
        Habit {
            name: name,
            completed: false,
        }
    }
}