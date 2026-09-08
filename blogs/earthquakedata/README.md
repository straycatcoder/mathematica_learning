# EarthquakeData magnitude-quality re-check (Wolfram Language 15.0.1)

Re-testing Charles J. Ammon's 2017 warning — ["Don't Study Large Earthquakes with Mathematica's EarthquakeData"](https://sites.psu.edu/charlesammon/2017/05/01/dont-study-large-earthquakes-with-mathematica/) — nine years later on Wolfram Language 15.0.1.

> **TL;DR:** Ammon still holds. `EarthquakeData[All, 8.0]` grew 253 → **265** records (extended through July 2025), but every magnitude error from 2017 is still there byte-for-byte: inflated historical `M9.6`/`9.7`/`9.5` values dominate the `M≥9.0` search, while four canonical modern `M9+` earthquakes (1952, 1960, 1964, 2004) are stored at `8.4–8.9` and vanish from it. The generic `Magnitude` field mixes incommensurable scales (`Missing`, `Mi`/`Mwp`, `mww`, `Mo`, `Mt`, …). **Do not use it for magnitude-threshold science — import USGS / ISC / GCMT preferred magnitudes instead.**

## Files in this folder

| File | What it is |
|---|---|
| `blogpost-followup-claude-sonnet-5.md` | Follow-up A (Claude): tight literal re-run of Ammon's 9 claims on WL 15.0.1, with `Wolfram vs reference` bar charts |
| `blogpost-followup-GPT5.6-sol.md` | Follow-up B (ChatGPT): same core + seismological "why" — magnitude-type mixing, 1964 Alaska duplicate (`8.5` + `8.4`), `178` vs `100` count gap since 1900, live 2025 Kamchatka failure (`8.0 Mi` vs `8.8 Mww`) |
| `blogpost-independent-verification-muse-spark-1.2.md` | Independent live verification (muse-spark-1.2, Sept 4, 2026): local `wolframscript` + USGS FDSN checks; head-to-head of A vs B — both correct on essentials, B is a strict superset |
| `blogpost-independent-verification-muse-spark-1.3.md` | Re-run of the verification under muse-spark-1.3: fresh `wolframscript` + USGS `curl` log; reproduces the 1.2 pass exactly |
| `blogpost.webarchive` | Archived copy of Ammon's original 2017 post |
| `make_plots.wl` | Wolfram Language source for the Claude follow-up charts (`images/`) |
| `generate_figures.wl` | Wolfram Language source for the ChatGPT follow-up charts (`figures/`) |
| `images/magnitude_comparison.png` | Claude chart: Wolfram vs reference magnitudes (historical over-, modern under-estimates) |
| `images/missing_great_earthquakes.png` | Claude chart: real `M≥9` since 1950 vs what `EarthquakeData[All, 9.0]` returns |
| `figures/magnitude-9-timeline.png` | ChatGPT timeline: Wolfram's `≥9` list (pre-instrumental, `Missing` type) vs USGS instrumental `≥9` list |
| `figures/magnitude-comparison.png` | ChatGPT paired Wolfram-vs-USGS comparison incl. 2025 Kamchatka |

## Key results (WL 15.0.1, verified live)

- `EarthquakeData[All, 8.0]` → **265** records (was 253 in 2017); first entry still 1096 Honshu `M8.3`; latest now 2025-07-29 Kamchatka.
- `EarthquakeData[All, 9.0]` → the **same 5** events as 2017 at identical values: 1687 Peru `9.0`, 1812 Caracas `9.6`, 1827 Colombia `9.7`, 1868 Arica `9.5` (all `Missing` type) + 2011 Tohoku `9.0` (`Mo`).
- Modern deficits confirmed vs USGS preferred: 1952 Kamchatka `8.5` vs `9.0`, 1960 Chile `8.5` vs `9.5` (largest ever recorded), 1964 Alaska `8.5` + duplicate `8.4` vs `9.2`, 2004 Sumatra `8.9` vs `9.1`, 2011 Tohoku `9.0` vs `9.1`.
- 2016 Solomon Islands still `8.0 Mi` vs USGS `7.8 mww` (wrong side of the `8.0` threshold).
- 2025 Kamchatka: Wolfram holds both `8.8 mww` and `8.0 Mi` as separate "earthquakes" 3 s apart (double-count + `0.8` deficit on the `Mi` leg) — the issue is active, not legacy.
- Type tally over the 265 `M≥8` rows: `Missing 243, mww 9, Mi 5, Mo 1, Mw 1, Mt 2, MI 1, Null 3` — thresholding the bare numeric `Magnitude` compares incommensurable scales.
- Since-1900 `M≥8` count: Wolfram **178** vs USGS preferred **100**.

## Reproducing the checks

```wolfram
eq8 = Values @ EarthquakeData[All, 8.0];
eq9 = Values @ EarthquakeData[All, 9.0];

propertyValue[a_, name_] :=
  Values[a][[First @ FirstPosition[ToString /@ Keys[a], name]]];

Length[eq8]   (* 265 *)
Length[eq9]   (* 5 *)
```

```bash
# USGS preferred magnitudes (no key needed)
curl -s "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&eventid=official19600522191120_30"
curl -s "https://earthquake.usgs.gov/fdsnws/event/1/count?starttime=1900-01-01&minmagnitude=8"  # → 100
```

See the two verification posts for the full per-event `wolframscript` + FDSN logs, and `make_plots.wl` / `generate_figures.wl` for the figure sources.

## Sources

1. Charles J. Ammon (2017), original post + `blogpost.webarchive`.
2. USGS [Magnitude Types](https://www.usgs.gov/programs/earthquake-hazards/magnitude-types); [20 Largest Since 1900](https://www.usgs.gov/programs/earthquake-hazards/science/20-largest-earthquakes-world-1900); [FDSN API](https://earthquake.usgs.gov/fdsnws/event/1/).
3. [ISC magnitude standards](https://www.isc.ac.uk/standards/magnitudes/); [USGS Catalog Search](https://earthquake.usgs.gov/earthquakes/search/); [Global CMT Catalog](https://www.globalcmt.org/).
