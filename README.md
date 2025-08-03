# Green-5G-Power ― Massive-MIMO & Hybrid Energy Demo

## Table of Contents
- [Project Overview](#project-overview)
- [Quick Start](#quick-start)
- [Requirements](#requirements)
- [Simulation Modules](#simulation-modules)
   - [Antenna & RF Scripts](#antenna--rf-scripts)
   - [Energy-Saving Scripts](#energy-saving-scripts)
   - [Hybrid Power Model](#hybrid-power-model)
- [Directory Tree](#directory-tree)
- [Figures & Logs](#figures--logs)
- [Key Results](#key-results)
- [Design Notes (PV + Biomass Sizing)](#design-notes-pv--biomass-sizing)
- [Re-run a Single Module](#re-run-a-single-module)
- [Citation](#citation)

## Project Overview
This repo reverse-engineers all the maths, code and figures behind our paper  
*“Analysis of Massive-MIMO Antenna, Sleep-Mode Power Optimisation & Hybrid Power Generation for 5 G.”*  
The goal: **slash radio-access energy ≈ 25 % and cover the remaining 75 % with renewables**.

| Pillar | What we do | Why it matters |
| ------ | ---------- | -------------- |
| **Antenna physics** | Calculate down-tilt, beam pattern, return-loss, gain/efficiency for an 8-element Massive-MIMO array. | Narrow beams ⟶ fewer watts per bit, but matching & mutual coupling are non-trivial. |
| **Network power-saving** | Model dynamic 60 % sleep-mode outside office hours. | Turns 264 kWh day⁻¹ ➜ 198 kWh day⁻¹ for the same QoS. |
| **Green power plant** | Size a **15 kWp PV + 5 kW biomass + grid backup** micro-hybrid, dispatch hourly, compute CAPEX/OPEX & LCOE. | 98 % renewable share, LCOE ≈ \$0.12 kWh⁻¹ ⇢ beats diesel & grid tariff. |

Everything is **one-click reproducible** (`run_all.m`), spits out high-res PNGs to `figures/`, and logs every number to `results/` for auditability. Fork it to tweak antenna height, change traffic curves, or swap biomass for wind—scripts are parameterised and Octave-friendly.

## Quick Start
> **Clone → Run → Get Figures (60 seconds)**

```bash
# 1. grab the repo
git clone https://github.com/YOUR_USER/mimo_smt_5G.git
cd green-5g-power

# 2. fire up MATLAB / Octave
cd matlab
run_all                % ⇨ runs every script, auto-saves PNGs & logs
```

## Requirements
| Tool / Library | Version tested | Notes |
|---------------|----------------|-------|
| **MATLAB**    | R2023b (desktop & `-batch`) | No extra toolboxes needed. |
| **GNU Octave**| ≥ 7.0          | Works out-of-the-box; replace `exportgraphics` with `print -dpng` if you want identical PNGs. |
| **Disk**      | ~30 MB         | Code + figures + logs. |
| **RAM / CPU** | Any laptop     | All scripts finish in < 3 s on a 2020 dual-core. |
| **(Optional) HOMER Pro** | 3.x | Only if you plan to do a full-year hybrid optimisation; not required for the demo scripts. |

## Simulation Modules
Below you’ll find the three “black-box” bundles that power every result in this repo.  
Each module is self-contained – open the script, tweak the **PARAMETERS** block at the top, hit **Run**.

### Antenna & RF Scripts
| Script | Purpose | Key Inputs | Main Output |
| ------ | ------- | ---------- | ----------- |
| `coverage_analysis.m` | Computes down-tilt angle and inner/outer cell radius. | `h_T`, `h_R`, `D`, `QBW` | `coverage_annulus.png` |
| `beamforming_simulation.m` | 8-element uniform linear array beam pattern (MIMO). | `N`, `d`, `steer_angle` | `beam_pattern.png` |
| `return_loss_impedance.m` | Return-loss ↔ impedance match demos. | `Pin`, `Pr`, `Z_ant` | `return_loss_examples.png` |
| `gain_efficiency_comparison.m` | MIMO vs SISO gain + efficiency calc. | `P_in`, `G_*`, `eff_*` | `gain_efficiency.png` |

*Typical run-time: < 1 s each.*

---

### Energy-Saving Scripts
| Script | What it models | Adjustable | Figure |
| ------ | -------------- | ---------- | ------ |
| `sleep_mode_power.m` | 24 h load curve with/without 60 % sleep-mode. | `P_full`, `peak_hours`, `sleep_factor` | `sleep_mode_energy.png` |

Outputs console summary and bar chart showing % energy saved.  
*Want weekend vs weekday? Swap `peak_hours` array and re-run.*

---

### Hybrid Power Model
| Script | Description | Knobs you can turn | Figure |
| ------ | ----------- | ------------------ | ------ |
| `hybrid_power_simulation.m` | Dispatches PV → Biomass → Grid hour-by-hour. | `load_profile`, `solar_profile`, `biomass_max` | `hybrid_supply_stack.png` |
| `design_notes.md` | Hand-calc sizing, CAPEX, LCOE. | Markdown file – edit numbers or add HOMER screenshots. | – |

*Extensible:*  
*— plug in real irradiance data;*  
*— change biomass to wind;*  
*— add battery logic if `battery_kWh > 0`.*

---

> **Tip:** Execute `run_all.m` to run **every** script above, regenerate all PNGs, and write a single combined log to `results/full_run.log`.

## Directory Tree

```bash
mimo_smt_5G/
├── README.md
│
├── docs/                      # paper + any supplementary PDFs
│   └── report.pdf
│
├── matlab/                    # antenna + power-saving simulations
│   ├── beamforming_simulation.m
│   ├── coverage_analysis.m
│   ├── gain_efficiency_comparison.m
│   ├── return_loss_impedance.m
│   ├── sleep_mode_power.m
│   └── run_all.m              # <- executes every script in one go
│
├── hybrid_power/              # green-energy dispatch model
│   ├── design_notes.md        # sizing, CAPEX, LCOE calculations
│   └── hybrid_power_simulation.m
│
├── figures/                   # auto-generated PNGs (✓ committed)
│   ├── beamforming_pattern.png
│   ├── coverage_annulus.png
│   ├── gain_efficiency.png
│   ├── hybrid_power_supply_allocation_vs_load.png
│   ├── return_loss_examples.png
│   └── sleep_mode_energy.png
│
├── results/                   # plain-text run logs (✓ committed)
│   ├── coverage_analysis_YYYYMMDD_HHMMSS.log
│   ├── gain_efficiency_comparison_YYYYMMDD_HHMMSS.log
│   ├── hybrid_power_simulation_YYYYMMDD_HHMMSS.log
│   ├── return_loss_impedance_YYYYMMDD_HHMMSS.log
│   └── sleep_mode_power_YYYYMMDD_HHMMSS.log
│
└── .gitignore                 # ignores *.asv, *.fig, temp files
```

## Figures & Logs
Everything you run is **auto-captured**:

| PNG (in `figures/`) | Generated by | Snapshot |
|---------------------|--------------|----------|
| `beamforming_pattern.png` | `beamforming_simulation.m` | 8-element array main-lobe steered to 30 °. |
| `coverage_annulus.png` | `coverage_analysis.m` | Outer / inner cell footprint for given tilt & beamwidth. |
| `return_loss_examples.png` | `return_loss_impedance.m` | Bar plot: power-ratio vs impedance-mismatch RL. |
| `gain_efficiency.png` | `gain_efficiency_comparison.m` | MIMO vs SISO gain (dBi) + efficiency (%) in one chart. |
| `sleep_mode_energy.png` | `sleep_mode_power.m` | 24 h energy bar — always-on vs sleep-enabled. |
| `hybrid_power_supply_allocation_vs_load.png` | `hybrid_power_simulation.m` | Stacked-area PV + Biomass + Grid vs load curve. |

---

| Log file (in `results/`) | What’s inside |
|--------------------------|---------------|
| `*_coverage_analysis_YYYYMMDD_HHMMSS.log` | Down-tilt angle, inner/outer radius values. |
| `*_beamforming_simulation_…` *(optional if diarised)* | Console trace of AF magnitude stats. |
| `*_sleep_mode_power_…` | Daily kWh (active vs sleep) and % savings. |
| `*_hybrid_power_simulation_…` | Total load, kWh split by Solar / Biomass / Grid. |

Logs are **timestamped** so you can diff old vs new runs.  
Set `timestamp = datestr(now,'yyyymmdd_HHMMSS');` at the top of each script to keep them chronological.

## Key Results
| Metric / Scenario                              | Value | Benchmark / Comment |
|------------------------------------------------|-------|---------------------|
| **Antenna Gain** (Massive-MIMO)                | **10.85 dBi** | +1.6 dB vs SISO (9.25 dBi) |
| **Radiation Efficiency** (MIMO)                | **93.75 %**   | vs 75 % (SISO) |
| **Return Loss**                                | 6.0 dB (MIMO) | vs 15 dB (SISO) |
| **Daily Station Load — Always-On**             | 264 kWh | 100 % power, 24 h |
| **Daily Station Load — Sleep-Mode Enabled**    | 198 kWh | **-25 % energy** |
| **Hybrid-Supply Split** (Sunny design-day)     | PV 23 % • Biomass 73 % • Grid 4 % | Grid covers only peak deficit |
| **Annual Renewable Share**                     | **≈ 98 %** | Based on monthly budget in design notes |
| **Annual CO₂ Avoided**                         | ≈ 41 t CO₂ | vs diesel/grid baseline |
| **LCOE** (20 yr, 6 % discount)                 | **\$0.12 kWh⁻¹** | Cheaper than local retail tariff |


## Design Notes (PV + Biomass Sizing)
All sizing math, CAPEX, and LCOE live in **`hybrid_power/design_notes.md`**.  
Key take-aways:

* **15 kWp PV + 5 kW biomass genset** covers 98 % of annual energy; grid < 2 %.
* Estimated **LCOE ≈ \$0.12 kWh⁻¹** &nbsp;↔&nbsp; beats diesel / commercial tariff.
* CAPEX ≈ \$37 k and avoids ≈ 41 t CO₂ per year.

> Open the markdown file for full tables (assumptions, monthly budget, battery optionality)

## Re-run a Single Module
You don’t need the full pipeline every time—run just the piece you’re tweaking.

```matlab
cd matlab                    % <- inside repo
sleep_mode_power             % quick energy-saving bar chart
coverage_analysis            % geometry numbers + annulus plot
hybrid_power_simulation      % PV-Biomass-Grid dispatch stack
```

## Citation

1. Abdalla, D., & Pointcheval, M. (2005). **Simple Password-Based Encrypted Key Exchange Protocols**. In *Topics in Cryptology – CT-RSA* (pp. 191-208).  
2. Kulkarni, A., Gautam, A., Kothari, M., & Saonawane, S. (2020). **A Review on Energy-Efficient Green Communication**. *International Journal of Innovative Research in Electronics & Communication*, 7(2), 8-11. https://doi.org/10.20431/2349-4050.0702002  
3. Kim, H. (2020). **Design and Optimization for 5 G Wireless Communications**. John Wiley & Sons.  
4. Rogers, E. M. (1986). **Communication Technology**. Free Press.  
5. Sharawi, M. S. (2014). **Printed MIMO Antenna Engineering**. Artech House.  
6. Zhang, H., Gladisch, A., Pickavet, M., Tao, Z., & Mohr, W. (2010). **Energy Efficiency in Communications**. *IEEE Communications Magazine*, 48(11), 48-49. https://doi.org/10.1109/MCOM.2010.5621966  
7. Uthansakul, P., Khan, A. A., Uthansakul, M., & Duangmanee, P. (2018). **Energy-Efficient Design of Massive-MIMO Based on Closely Spaced Antennas: Mutual Coupling Effect**. *Energies*, 11(8), 2029. https://doi.org/10.3390/en11082029  
8. Halbauer, H., Weber, A., Wiegner, D., & Wild, T. (2018). **Energy-Efficient Massive-MIMO Array Configurations**. In *Proc. IEEE GLOBECOM Workshops* (pp. 1-6).  
9. Yang, G. (2020). **Advanced Technologies for Energy Savings in Small-Cell Networks**. Technical Report.  
10. Hawasli, M., & Çolak, S. A. (2017). **Toward Green 5 G Heterogeneous Small-Cell Networks: Power Optimisation Using Load-Balancing Technique**. *AEU – International Journal of Electronics and Communications*, 82, 474-485. https://doi.org/10.1016/j.aeue.2017.09.012  
11. Sharif, M. R., Rahman, M. N., Chowdhury, M. H. R., & Shoeb, M. A. (2016). **Designing of an Optimised Building-Integrated Hybrid Energy-Generation System**. In *ICDRET 2016 – 4th Int. Conf. on Development of Renewable Energy Technology* (pp. 329-342). https://doi.org/10.1109/ICDRET.2016.7421498  
12. Arnold, O., Richter, F., Fettweis, G., & Blume, O. (2010). **Power-Consumption Modelling of Different Base-Station Types in Heterogeneous Cellular Networks**. In *Future Network & Mobile Summit* (pp. 1-8).  
13. Abrol, A., & Jha, R. K. (2016). **Power Optimisation in 5 G Networks: A Step Toward Green Communication**. *IEEE Access*, 4, 1355-1374. https://doi.org/10.1109/ACCESS.2016.2549641  
14. Hossain, M. S., & Rahman, M. F. (2020). **Hybrid Solar-PV/Biomass-Powered Energy-Efficient Remote Cellular Base Stations**. *International Journal of Renewable Energy Research*, 10(1), 329-342. https://doi.org/10.20508/ijrer.v10i1.10542.g7911  
15. Zamrodah, Y. (2016). **Utilisation of Solar and Biomass Energy – A Panacea to Energy Sustainability in a Developing Economy**. *International Journal of Energy & Environment Research*, 15(2), 1-23.  
16. Alsharif, M. H., Kelechi, A. H., Kim, J., & Kim, J. H. (2019). **Energy Efficiency and Coverage Trade-Off in 5 G for Eco-Friendly and Sustainable Cellular Networks**. *Symmetry*, 11(3), 408. https://doi.org/10.3390/sym11030408  
17. Matalatala, M., et al. (2019). **Multi-Objective Optimisation of Massive-MIMO 5 G Wireless Networks Toward Power Consumption, Uplink and Downlink Exposure**. *Applied Sciences*, 9(22), 4974. https://doi.org/10.3390/app9224974  
18. Selinis, I., Katsaros, K., Allayioti, M., Vahid, S., & Tafazolli, R. (2018). **The Race to 5 G Era: LTE and Wi-Fi**. *IEEE Access*, 6, 56598-56636. https://doi.org/10.1109/ACCESS.2018.2867729  
19. Shafique, K., Khawaja, B. A., Sabir, F., Qazi, S., & Mustaqim, M. (2020). **Internet of Things (IoT) for Next-Generation Smart Systems: A Review of Current Challenges, Future Trends and Prospects for Emerging 5 G-IoT Scenarios**. *IEEE Access*, 8, 23022-23040. https://doi.org/10.1109/ACCESS.2020.2970118  
20. Asogwa, T. C., Fidelis, E., Obodoeze, C., & Obiokafor, I. N. (2007). **Wireless Sensor-Network Applications in Oil & Gas and Agriculture Industries in Nigeria**. *International Journal of Advanced Research in Computer & Communication Engineering*, 3297, 100-104. https://doi.org/10.17148/IJARCCE  
21. Fujino, N., Ogawa, K., & Minowa, M. (2016). **Wireless-Network Technologies to Support the Age of IoT**. *Fujitsu Scientific & Technical Journal*, 52(4), 68-76.  
22. Gemma, P. (2018). **5 G for Smart Sustainable Cities**. White Paper.  
23. Arbi, A., & O’Farrell, T. (2015). **Energy Efficiency in 5 G Access Networks: Small-Cell Densification and High-Order Sectorisation**. In *Proc. IEEE ICC Workshops* (pp. 2806-2811). https://doi.org/10.1109/ICCW.2015.7247604  
24. Correia, L. M., et al. (2010). **Challenges and Enabling Technologies for Energy-Aware Mobile-Radio Networks**. *IEEE Communications Magazine*, 48(11), 66-72. https://doi.org/10.1109/MCOM.2010.5621969  
25. Chua, C., Aditya, S., & Shen, Z. (2012). **Energy-Efficient Base-Station Entering Sleep Mode**. Patent Publication.  
26. Raikar, M. M., Doddagoudar, P., & Maralapannavar, M. S. (2014). **An Algorithmic Perspective of Base-Station Switching in Dense Cellular Networks**. In *Proc. 3rd Int. Conf. Eco-Friendly Computing & Communication Systems* (pp. 177-182). https://doi.org/10.1109/Eco-friendly.2014.44  
27. Rathore, R. S., Sangwan, S., Kaiwartya, O., & Aggarwal, G. (2021). **Green Communication for Next-Generation Wireless Systems: Optimisation Strategies, Challenges, Solutions and Future Aspects**. *Wireless Communications & Mobile Computing*, Article 5528584. https://doi.org/10.1155/2021/5528584  
28. Chen, Y., Zhang, S., & Xu, S. (2010). **Characterising Energy-Efficiency and Deployment-Efficiency Relations for Green Architecture Design**. In *IEEE ICC Workshops* (pp. 1-5). https://doi.org/10.1109/ICCW.2010.5503900  
29. Ezri, D., & Shilo, S. (2009). **Green Cellular — Optimising the Cellular Network for Minimal Emission from Mobile Stations**. In *IEEE Int. Conf. on Microwaves, Communications, Antennas & Electronics Systems* (pp. 1-5). https://doi.org/10.1109/COMCAS.2009.5385989  
30. Mandelli, S., Lieto, A., Baracca, P., Weber, A., & Wild, T. (2021). **Power Optimisation for Low Interference and Throughput Enhancement for 5 G and 6 G Systems**. In *Proc. IEEE WCNC Workshops* (pp. 1-7). https://doi.org/10.1109/WCNCW49093.2021.9419981  



