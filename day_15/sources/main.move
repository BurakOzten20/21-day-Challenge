module challenge::day_15 {

    // --- SABİTLER (HATA KODLARI VE LİMİTLER) ---
    const MAX_PLOTS: u64 = 20;
    const E_PLOT_NOT_FOUND: u64 = 1;
    const E_PLOT_LIMIT_EXCEEDED: u64 = 2;
    const E_INVALID_PLOT_ID: u64 = 3;
    const E_PLOT_ALREADY_EXISTS: u64 = 4;

    // --- YAPILAR (STRUCT) ---
    public struct FarmCounters has copy, drop, store {
        planted: u64,
        harvested: u64,
        plots: vector<u8>,
    }

    // --- FONKSİYONLAR ---

    // 1. Yeni, sıfırlanmış çiftlik sayacı oluşturur
    public fun new_counters(): FarmCounters {
        FarmCounters {
            planted: 0,
            harvested: 0,
            plots: vector::empty(),
        }
    }

    // 2. Tarlaya tohum eker
    public fun plant(counters: &mut FarmCounters, plotId: u8) {
        // Güvenlik kontrolleri (Geçerli ID mi? Kapasite doldu mu? Zaten ekili mi?)
        assert!((plotId as u64) <= MAX_PLOTS, E_INVALID_PLOT_ID);
        assert!(counters.plots.length() < MAX_PLOTS, E_PLOT_LIMIT_EXCEEDED);
        assert!(!counters.plots.contains(&plotId), E_PLOT_ALREADY_EXISTS);
        
        counters.plots.push_back(plotId);
        counters.planted = counters.planted + 1;
    }

    // 3. Tarlayı hasat eder
    public fun harvest(counters: &mut FarmCounters, plotId: u8) {
        // Tarla listede var mı kontrol et, varsa indeksini al
        let (exists, index) = counters.plots.index_of(&plotId);
        assert!(exists, E_PLOT_NOT_FOUND);
        
        counters.plots.remove(index);
        counters.harvested = counters.harvested + 1;
    }
}