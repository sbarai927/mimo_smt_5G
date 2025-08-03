# Hybrid Power Generation System – Design Notes

*Powering a 5 G Base Station (11 kW peak) with Solar PV + Biomass + Grid Backup*

---

## 1  Objective

Design a **reliable, greener power supply** that meets the continuous energy demand of a single 5 G base‑station site while minimizing dependency on the national grid. The base‑station’s **peak electrical load is 11 kW**, estimate for a 200 m² coverage cell.

## 2  Key Assumptions

| Parameter                          | Value                                   | Rationale                                                     |
| ---------------------------------- | --------------------------------------- | ------------------------------------------------------------- |
| Peak load                          | **11 kW**                               | Paper’s daily demand (≈264 kWh day⁻¹) with 100 % utilisation. |
| Average load (24 h)                | **6.5 kW**                              | Load profile in `hybrid_power_simulation.m` (≈156 kWh day⁻¹). |
| Solar resource (Dhaka)             | **5.0 kWh m⁻² day⁻¹** GHI (annual mean) | NASA POWER dataset, tropical latitude.                        |
| PV module efficiency               | 18 % (mono‑Si)                          | Commercially available panels.                                |
| Derate factor                      | 0.75                                    | Accounts for temp, wiring, DC‑AC conversion.                  |
| Biomass fuel (biogas / syngas) LHV | 5.5 kWh kg⁻¹                            | Agricultural residue, animal manure digestion.                |
| Biomass genset efficiency          | 25 % (electrical)                       | Small ICE genset with biogas retrofit.                        |
| Grid availability                  | 99 %                                    | Grid used only to cover rare shortfalls / maintenance.        |

## 3  Component Sizing

### 3.1  Solar PV Array

Required daytime average contribution target: **≈6 kW** during 10 sunlit hours.

Daily energy from PV needed: 6 kW × 10 h ≈ 60 kWh.

Panel area estimate:

```
E_day = GHI × η_panel × derate × Area
Area   = E_day / (GHI × η × derate)
       = 60 / (5 × 0.18 × 0.75) ≈ **88 m²**
```

Peak array capacity @ 1 kW m⁻² irradiance: 0.18 kW m⁻² × 88 m² ≈ **16 kWp**.

> **Selected size:** **15 kWp** PV (≈80 m², 42 × 360 W panels).

### 3.2  Biomass Generator

Night‑time & shoulder‑hour demand after PV: target **5 kW** continuous capability,\
matching the `biomass_max` in simulation.\
• Generator rating: **5 kW** (6 kVA, 0.8 pf).\
• Fuel consumption @ 25 % eff.:

```
Fuel (kg h⁻¹) = P_el / (η × LHV) = 5 / (0.25 × 5.5) ≈ 3.6 kg h⁻¹
Daily (10 h run) ≈ 36 kg; Annual ≈ 13 t.
```

### 3.3  Battery Storage (optional)

For smoothing PV fluctuations & reducing genset cycling.\
• Target autonomy: **2 h at average load** → 6.5 kW × 2 h ≈ 13 kWh usable.\
• Lithium‑iron‑phosphate pack, 80 % DoD → 17 kWh nameplate.

### 3.4  Power Electronics

| Device                          | Rating                     |
| ------------------------------- | -------------------------- |
| PV string inverters             | ≥ 15 kVA (3 × 5 kVA units) |
| Bi‑directional battery inverter | 10 kVA                     |
| AC bus & ATS                    | 20 kVA, 220 V single‑phase |

## 4  Monthly / Annual Energy Budget

Approximate monthly delivery (kWh):

| Month    | PV         | Biomass    | Grid    | Total Load   |
| -------- | ---------- | ---------- | ------- | ------------ |
| Jan      | 1 800      | 3 000      | 100     | 4 900        |
| Apr      | 2 200      | 2 700      | 70      | 4 970        |
| Jul      | 2 600      | 2 400      | 50      | 5 050        |
| Oct      | 1 900      | 2 900      | 90      | 4 890        |
| **Year** | **25 000** | **34 000** | **960** | **≈ 60 000** |

> **Grid share:** \~ 1.6 % of annual energy.\
> **Renewable share:** \~ 98 %.\
> **CO₂ reduction:** vs. diesel grid baseline (0.7 kg kWh⁻¹) → ↓ ≈ 41 t CO₂ yr⁻¹.

*Note:* Figures use the simplified daily profile scaled to monthly climate data; exact values would be refined in a full HOMER Pro (or similar) optimisation run.

## 5  O&M and Cost Highlights

| Component           | CAPEX (USD)  | OPEX (USD yr⁻¹)      | Notes                                       |
| ------------------- | ------------ | -------------------- | ------------------------------------------- |
| 15 kWp PV           | 15 000       | 150                  | \$1 W⁻¹ turnkey cost.                       |
| 5 kW biomass genset | 6 000        | 2 000 fuel & service | Fuel cost assumes \$0.15 kg⁻¹ agri‑residue. |
| 17 kWh LiFePO₄      | 9 000        | 90                   | \$550 kWh⁻¹ declining trend.                |
| Inverters & BOS     | 7 000        | 70                   | Combiner, ATS, wiring.                      |
| **Total**           | **≈ 37 000** | **≈ 2 300**          | Excludes land / site works.                 |

Levelised cost of energy (LCOE) estimate (20‑yr life, 6 % discount): **\$0.12 kWh⁻¹**, competitive with commercial tariffs and far below diesel genset alternatives.

---

## 6  Further Work

1. **Detailed HOMER Pro optimisation** with hourly solar & load data (8760 points).
2. Analysis of **battery storage** value vs. additional PV oversize.
3. **Grid feed‑in** option when PV surplus exceeds load.
4. **Carbon accounting** for biomass fuel sourcing (net‑zero vs. supply chain emissions).

---


