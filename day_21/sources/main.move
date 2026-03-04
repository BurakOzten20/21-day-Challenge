module challenge::day_21 {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::TxContext;
    use sui::event;
    use std::vector;

    // --- SABİTLER VE HATA KODLARI ---
    const MAX_PLOTS: u64 = 20;
    const E_PLOT_NOT_FOUND: u64 = 1;
    const E_PLOT_LIMIT_EXCEEDED: u64 = 2;
    const E_INVALID_PLOT_ID: u64 = 3;
    const E_PLOT_ALREADY_EXISTS: u64 = 4;

    // --- YAPILAR ---
    public struct FarmCounters has copy, drop, store {
        planted: u64,
        harvested: u64,
        plots: vector<u8>,
    }

    public struct Farm has key {
        id: UID,
        counters: FarmCounters,
    }

    public struct PlantEvent has copy, drop {
        planted_after: u64,
    }

    // --- YARDIMCI FONKSİYONLAR ---
    fun new_counters(): FarmCounters {
        FarmCounters {
            planted: 0,
            harvested: 0,
            plots: vector::empty(),
        }
    }

    fun new_farm(ctx: &mut TxContext): Farm {
        Farm {
            id: object::new(ctx),
            counters: new_counters(),
        }
    }

    fun plant(counters: &mut FarmCounters, plotId: u8) {
        assert!(plotId >= 1 && plotId <= (MAX_PLOTS as u8), E_INVALID_PLOT_ID);
        
        let len = vector::length(&counters.plots);
        assert!(len < MAX_PLOTS, E_PLOT_LIMIT_EXCEEDED);
        
        let mut i = 0;
        while (i < len) {
            let existing_plot = vector::borrow(&counters.plots, i);
            assert!(*existing_plot != plotId, E_PLOT_ALREADY_EXISTS);
            i = i + 1;
        };
        
        counters.planted = counters.planted + 1;
        vector::push_back(&mut counters.plots, plotId);
    }

    fun harvest(counters: &mut FarmCounters, plotId: u8) {
        let len = vector::length(&counters.plots);
                
        let mut i = 0;
        let mut found_index = len; 
        while (i < len) {
            let existing_plot = vector::borrow(&counters.plots, i);
            if (*existing_plot == plotId) {
                found_index = i;
            };
            i = i + 1;
        };
        
        assert!(found_index < len, E_PLOT_NOT_FOUND);
        
        vector::remove(&mut counters.plots, found_index);
        counters.harvested = counters.harvested + 1;
    }

    fun plant_on_farm(farm: &mut Farm, plotId: u8) {
        plant(&mut farm.counters, plotId);
    }

    fun harvest_from_farm(farm: &mut Farm, plotId: u8) {
        harvest(&mut farm.counters, plotId);
    }

    public fun total_planted(farm: &Farm): u64 {
        farm.counters.planted
    }

    public fun total_harvested(farm: &Farm): u64 {
        farm.counters.harvested
    }

    // --- DIŞARIYA AÇIK (ENTRY) FONKSİYONLAR ---
    public entry fun create_farm(ctx: &mut TxContext) {
        let farm = new_farm(ctx);
        transfer::share_object(farm);
    }

    public entry fun plant_on_farm_entry(farm: &mut Farm, plotId: u8) {
        plant_on_farm(farm, plotId);
        let planted_count = total_planted(farm);
        event::emit(PlantEvent {
            planted_after: planted_count,
        });
    }

    public entry fun harvest_from_farm_entry(farm: &mut Farm, plotId: u8) {
        harvest_from_farm(farm, plotId);
    }

    // --- KAPSAMLI TESTLER (FINAL DAY) ---
    #[test_only]
    use sui::test_scenario;

    #[test]
    fun test_create_farm() {
        let mut scenario = test_scenario::begin(@0xA);
        create_farm(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, @0xA);
        
        let farm = test_scenario::take_shared<Farm>(&scenario);
        assert!(total_planted(&farm) == 0, 0);
        assert!(total_harvested(&farm) == 0, 1);
        
        test_scenario::return_shared(farm);
        test_scenario::end(scenario);
    }

    #[test]
    fun test_planting_increases_counter() {
        let mut scenario = test_scenario::begin(@0xA);
        create_farm(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, @0xA);
        
        let mut farm = test_scenario::take_shared<Farm>(&scenario);
        plant_on_farm_entry(&mut farm, 1);
        assert!(total_planted(&farm) == 1, 0);
        
        test_scenario::return_shared(farm);
        test_scenario::end(scenario);
    }

    #[test]
    fun test_harvesting_increases_counter() {
        let mut scenario = test_scenario::begin(@0xA);
        create_farm(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, @0xA);
        
        let mut farm = test_scenario::take_shared<Farm>(&scenario);
        plant_on_farm_entry(&mut farm, 1);
        harvest_from_farm_entry(&mut farm, 1);
        
        assert!(total_planted(&farm) == 1, 0);
        assert!(total_harvested(&farm) == 1, 1);
        
        test_scenario::return_shared(farm);
        test_scenario::end(scenario);
    }

    #[test]
    fun test_multiple_operations() {
        let mut scenario = test_scenario::begin(@0xA);
        create_farm(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, @0xA);
        
        let mut farm = test_scenario::take_shared<Farm>(&scenario);
        plant_on_farm_entry(&mut farm, 3);
        plant_on_farm_entry(&mut farm, 5);
        plant_on_farm_entry(&mut farm, 18);
        harvest_from_farm_entry(&mut farm, 5);
        
        assert!(total_planted(&farm) == 3, 0);
        assert!(total_harvested(&farm) == 1, 1);
        
        test_scenario::return_shared(farm);
        test_scenario::end(scenario);
    }

    #[test]
    #[expected_failure(abort_code = challenge::day_21::E_INVALID_PLOT_ID)]
    fun test_invalid_plot_id() {
        let mut scenario = test_scenario::begin(@0xA);
        create_farm(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, @0xA);
        
        let mut farm = test_scenario::take_shared<Farm>(&scenario);
        // 21 geçerli bir tarla ID'si değil, burada abort (hata) vermesini bekliyoruz
        plant_on_farm_entry(&mut farm, 21); 
        
        test_scenario::return_shared(farm);
        test_scenario::end(scenario);
    }

    #[test]
    #[expected_failure(abort_code = challenge::day_21::E_PLOT_ALREADY_EXISTS)]
    fun test_duplicate_plot() {
        let mut scenario = test_scenario::begin(@0xA);
        create_farm(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, @0xA);
        
        let mut farm = test_scenario::take_shared<Farm>(&scenario);
        plant_on_farm_entry(&mut farm, 1);
        // Aynı tarlaya tekrar ekim yapmaya çalışıyoruz, abort vermeli
        plant_on_farm_entry(&mut farm, 1); 
        
        test_scenario::return_shared(farm);
        test_scenario::end(scenario);
    }

    #[test]
    #[expected_failure(abort_code = challenge::day_21::E_PLOT_LIMIT_EXCEEDED)]
    fun test_plot_limit() {
        let mut scenario = test_scenario::begin(@0xA);
        create_farm(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, @0xA);
        
        let mut farm = test_scenario::take_shared<Farm>(&scenario);
        
        let mut i = 1;
        while (i <= 20) {
            plant_on_farm_entry(&mut farm, i);
            i = i + 1;
        };
        // 20 kapasite doldu, 21. ekim denemesi sınırı aşmaktan abort vermeli
        // (Geçerli bir ID olan 1'i tekrar ekmeyi deniyoruz ki E_INVALID'e takılmasın)
        plant_on_farm_entry(&mut farm, 1); 
        
        test_scenario::return_shared(farm);
        test_scenario::end(scenario);
    }

    #[test]
    #[expected_failure(abort_code = challenge::day_21::E_PLOT_NOT_FOUND)]
    fun test_harvest_nonexistent_plot() {
        let mut scenario = test_scenario::begin(@0xA);
        create_farm(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, @0xA);
        
        let mut farm = test_scenario::take_shared<Farm>(&scenario);
        // Ekilmemiş 5 numaralı tarlayı hasat etmeye çalışıyoruz, abort vermeli
        harvest_from_farm_entry(&mut farm, 5); 
        
        test_scenario::return_shared(farm);
        test_scenario::end(scenario);
    }
}