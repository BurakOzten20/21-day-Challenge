module challenge::day_17 {
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;
    use sui::transfer; // Obje transferi ve paylaşımı için gerekli kütüphane
    use std::vector;

    const MAX_PLOTS: u64 = 20;
    const E_PLOT_NOT_FOUND: u64 = 1;
    const E_PLOT_LIMIT_EXCEEDED: u64 = 2;
    const E_INVALID_PLOT_ID: u64 = 3;
    const E_PLOT_ALREADY_EXISTS: u64 = 4;

    public struct FarmCounters has copy, drop, store {
        planted: u64,
        harvested: u64,
        plots: vector<u8>,
    }

    fun new_counters(): FarmCounters {
        FarmCounters {
            planted: 0,
            harvested: 0,
            plots: vector::empty(),
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

    public struct Farm has key {
        id: UID,
        counters: FarmCounters,
    }

    fun new_farm(ctx: &mut TxContext): Farm {
        Farm {
            id: object::new(ctx),
            counters: new_counters(),
        }
    }

    // --- DAY 17 GÖREVLERİ (TAMAMLANDI) ---

    // 1. Dışarıdan çağrılabilen, Çiftlik yaratma ve paylaşma fonksiyonu
    public entry fun create_farm(ctx: &mut TxContext) {
        let farm = new_farm(ctx);
        // Obgeyi ağdaki herkesin etkileşime girebileceği "shared" (paylaşımlı) objeye çeviriyoruz
        transfer::share_object(farm);
    }

    // 2. Çiftliğe tohum ekme fonksiyonu
    public fun plant_on_farm(farm: &mut Farm, plotId: u8) {
        // Farm objesinin içindeki sayaca (counters) referans göndererek işlemi yapıyoruz
        plant(&mut farm.counters, plotId);
    }

    // 3. Çiftlikten hasat yapma fonksiyonu
    public fun harvest_from_farm(farm: &mut Farm, plotId: u8) {
        // Aynı şekilde Farm objesinin içindeki sayaca erişiyoruz
        harvest(&mut farm.counters, plotId);
    }
}