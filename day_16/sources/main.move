module challenge::day_16 {
    // GÖREV 1: Sui Object kütüphanelerini ekliyoruz
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;
    use std::vector;

    // SABİTLER
    const MAX_PLOTS: u64 = 20;
    const E_PLOT_NOT_FOUND: u64 = 1;
    const E_PLOT_LIMIT_EXCEEDED: u64 = 2;
    const E_PLOT_ALREADY_EXISTS: u64 = 4;

    // STRUCTS
    
    // Bu bizim veri paketimiz (Store yeteneği var, çünkü Farm objesinin içine koyacağız)
    public struct FarmCounters has copy, drop, store {
        planted: u64,
        harvested: u64,
        plots: vector<u8>,
    }

    // GÖREV 2: Gerçek SUI OBJESİ (Farm)
    // 'key' yeteneği bunun bir obje olduğunu ve global storage'da saklanabileceğini söyler.
    public struct Farm has key {
        id: UID,                 // Objenin benzersiz kimliği
        counters: FarmCounters,  // İçindeki veriler
    }

    // FONKSİYONLAR

    // Yardımcı fonksiyon (Private)
    fun new_counters(): FarmCounters {
        FarmCounters {
            planted: 0,
            harvested: 0,
            plots: vector::empty(),
        }
    }

    // GÖREV 3: Farm Objesi Olusturucu (Constructor)
    // Yeni bir UID oluşturmak için 'ctx' (Transaction Context) gerekir.
    public fun new_farm(ctx: &mut TxContext): Farm {
        Farm {
            id: object::new(ctx), // Benzersiz ID oluşturur
            counters: new_counters(),
        }
    }

    // MANTIK FONKSİYONLARI
    
    public fun plant(counters: &mut FarmCounters, plot_id: u8) {
        // Kapasite kontrolü
        assert!(vector::length(&counters.plots) < MAX_PLOTS, E_PLOT_LIMIT_EXCEEDED);
        
        // Zaten ekili mi kontrolü
        let (exists, _) = vector::index_of(&counters.plots, &plot_id);
        assert!(!exists, E_PLOT_ALREADY_EXISTS);
        
        counters.planted = counters.planted + 1;
        vector::push_back(&mut counters.plots, plot_id);
    }

    public fun harvest(counters: &mut FarmCounters, plot_id: u8) {
        // Tarlayı bul
        let (exists, index) = vector::index_of(&counters.plots, &plot_id);
        assert!(exists, E_PLOT_NOT_FOUND);
        
        counters.harvested = counters.harvested + 1;
        vector::remove(&mut counters.plots, index);
    }
}