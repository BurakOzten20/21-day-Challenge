/// DAY 7: Unit Tests for Habit Tracker
///
/// Today you will:
/// 1. Learn how to write tests in Move
/// 2. Write tests for your habit tracker
/// 3. Use assert! macro

module challenge::day_07 {
    use std::vector;
    use std::string::{Self, String};

    // --- Day 6'dan gelen yapılar ---
    public struct Habit has copy, drop {
        name: String,
        completed: bool,
    }

    public struct HabitList has drop {
        habits: vector<Habit>,
    }

    public fun new_habit(name: String): Habit {
        Habit {
            name,
            completed: false,
        }
    }

    public fun make_habit(name_bytes: vector<u8>): Habit {
        let name = string::utf8(name_bytes);
        new_habit(name)
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
        }
    }

    // --- DAY 7 GÖREVİ: TESTLER ---

    // Test 1: Listeye ekleme testi
    #[test]
    fun test_add_habits() {
        // 1. Boş bir liste oluştur (değiştirilebilir olması için 'mut' ekledik)
        let mut list = empty_list();

        // 2. Bir alışkanlık oluştur
        let habit = make_habit(b"Kod Yaz");

        // 3. Listeye ekle
        add_habit(&mut list, habit);

        // 4. Kontrol et: Liste uzunluğu 1 olmalı
        // assert!(DURUM, HATA_KODU) -> Durum doğru değilse program durur.
        assert!(vector::length(&list.habits) == 1, 0);
    }

    // Test 2: Tamamlama testi
    #[test]
    fun test_complete_habit() {
        // 1. Liste oluştur ve eleman ekle
        let mut list = empty_list();
        let habit = make_habit(b"Spor Yap");
        add_habit(&mut list, habit);

        // 2. İlk elemanı (