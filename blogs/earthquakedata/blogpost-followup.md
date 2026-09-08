# Nine Years Later, Don't Study Large Earthquakes with Mathematica's `EarthquakeData` — Still

*A follow-up test of Charles J. Ammon's 2017 blog post, ["Don't Study Large Earthquakes with Mathematica's EarthquakeData"](https://sites.psu.edu/charlesammon/2017/05/01/dont-study-large-earthquakes-with-mathematica/), re-run on Wolfram Language 15.0.1 (2026)*

## Background

In May 2017, Penn State seismologist [Charles J. Ammon published a blog post](https://sites.psu.edu/charlesammon/2017/05/01/dont-study-large-earthquakes-with-mathematica/) warning that Mathematica's built-in `EarthquakeData` function returns seriously inaccurate magnitudes for large historical earthquakes. His conclusion was blunt:

> "No one should use Wolfram's `EarthquakeData` to investigate large earthquakes, even casually... Frankly, I wish they would remove the command."

Nine years and several major Wolfram Language releases later, I re-ran his exact queries on **Wolfram Language 15.0.1** (installed locally, July 2026 build) to see whether the underlying data has been fixed. It has not.

## Summary: what's the issue, and is it fixed?

| Issue | What's wrong | Fixed in 15.0.1? |
|---|---|---|
| **Historical earthquakes overrated** | 1812 Caracas and 1827 Colombia are tagged M9.6 / M9.7 — 2–3 magnitude units above NOAA's values (M7.0 for both) | ❌ No — identical values |
| **Major 20th/21st-century earthquakes underrated** | 1952 Kamchatka, 1960 Chile, 1964 Alaska, and 2004 Sumatra all carry magnitudes ~0.2–1.0 units below their real, well-documented values | ❌ No — identical values |
| **Real M9+ earthquakes vanish from M≥9.0 searches** | Because of the underrating above, `EarthquakeData[All, 9.0]` returns only 1687 Peru, 1812, 1827, 1868, and 2011 Tohoku — missing every other real M9-class earthquake since 1900 | ❌ No — same 5-event list as 2017 |
| **Recent, well-recorded earthquakes still mismatched** | Dec 8, 2016 Solomon Islands quake: USGS/GCMT = M7.8, Wolfram = M8.0 | ❌ No — still off (by a different amount) |
| **Catalog coverage / freshness** | Whether new earthquakes get added over time | ✅ Yes — grew from 253 to 265 M≥8.0 events, now includes events through 2025 |
| **Bottom line: is `EarthquakeData` safe for large/historical earthquake research?** | Ammon's 2017 answer was no | ❌ Still no |

Everything below walks through the individual queries behind this summary.

## Methodology

I reproduced each of Ammon's core queries directly:

```mathematica
(* Great earthquakes, M >= 8.0 *)
eqs = EarthquakeData[All, 8.0];
Length[eqs]

(* The largest class, M >= 9.0 *)
eqs9 = EarthquakeData[All, 9.0];
eqs9[[All, {"Period", "Magnitude", "Position"}]]
```

and then cross-checked specific events against USGS, NOAA's historical tsunami/earthquake database, and the Global Centroid Moment Tensor (GCMT) catalog — the same authoritative sources Ammon used.

## Findings

| # | Claim in the 2017 post | Result on Wolfram 15.0.1 (2026) | Verdict |
|---|---|---|---|
| 1 | `EarthquakeData[All, 8.0]` returns 253 great earthquakes | Returns **265** — the catalog has grown (new events through 2025 appended) | Dataset extended, old records untouched |
| 2 | First entry: 1096 Honshu, Japan, M8.3 | Identical entry returned — same date, magnitude, coordinates (34.2°N, 137.3°E) | Unchanged |
| 3 | Dec 8, 2016 Solomon Islands quake — Wolfram's magnitude disagreed with USGS/GCMT's 7.8 | Wolfram now reports **M8.0** vs. USGS/GCMT's **7.8** | Still wrong |
| 4 | `EarthquakeData[All, 9.0]` returns exactly 5 events: 1687 Peru, 1812 Caracas, 1827 Colombia, 1868 Arica, 2011 Tohoku | **Byte-for-byte identical** 5-event list, same magnitudes, same coordinates | Unchanged |
| 5 | 1812 Caracas (M9.6) and 1827 Colombia (M9.7) are implausible; NOAA lists Colombia 1827 at only M7.0 | Same M9.6 / M9.7 values still returned | Unchanged |
| 6 | 1868 Arica, Chile listed at M9.5; NOAA gives M8.5, Abe's tsunami-magnitude estimate is M9.0 | Same M9.5 still returned | Unchanged |
| 7 | 1952 Kamchatka, 1960 Chile, 1964 Alaska, 2004 Sumatra — all real M9+ earthquakes — are absent from the M≥9.0 results | Confirmed present in the database, but **magnitudes are clipped just under 9.0**: Kamchatka listed 8.5 (real ≈9.0), Chile listed 8.5 (real 9.5 — the largest earthquake ever recorded), Alaska listed 8.5 (real 9.2), Sumatra listed 8.9 (real 9.1) | Root cause confirmed |
| 8 | Only 2011 Tohoku (of the post-1950 M9+ events) makes the list | Still the only post-1950 event returned | Unchanged |
| 9 | Recommendation: use USGS/ISC/GCMT directly instead of `EarthquakeData` for large or historical earthquakes | Still valid — see charts below | Confirmed |

## The magnitude errors, visualized

The chart below plots Wolfram's `EarthquakeData` magnitude against the authoritative reference magnitude for every event discussed above. Historical 19th-century earthquakes are *overestimated* by 2–3 magnitude units; well-documented 20th/21st-century earthquakes are *underestimated* by 0.2–1.0 units — in the wrong direction for opposite reasons, but wrong either way.

![Wolfram EarthquakeData magnitude vs. reference magnitude](images/magnitude_comparison.png)

The practical consequence of the 1952/1960/1964/2004 underestimates is that all four vanish from any `EarthquakeData[All, 9.0]` search, even though each is unambiguously a magnitude-9-class earthquake in every seismological catalog:

![Real M>=9.0 earthquakes since 1950 vs. what EarthquakeData[All, 9.0] returns](images/missing_great_earthquakes.png)

1960 Chile is the starkest case: it is the largest earthquake ever instrumentally recorded (Mw 9.5), and Wolfram's own database — accessible via a plain geographic/date query — has it on file at M8.5, a full magnitude unit low, low enough to disappear from its own "great earthquake" search.

## Conclusion

Ammon's 2017 diagnosis holds up exactly as originally stated, on a Wolfram Language release nine years newer. The `EarthquakeData` catalog has been *extended* with new events through 2025, but the historical magnitude errors he identified — the inflated 19th-century values and the deflated 20th/21st-century ones — are still there, unedited.

**If you need to work with earthquake magnitude data in Mathematica, import it from USGS, ISC, or GCMT directly rather than relying on `EarthquakeData`.** Mathematica remains an excellent tool for analyzing and visualizing that data once imported — just not for sourcing it.

## Reproducing this

All queries were run with:

```bash
wolframscript -code '$Version'
(* 15.0.1 for Mac OS X ARM (64-bit) (July 2, 2026) *)
```

The two comparison charts were generated with `EarthquakeData` output plotted against the reference magnitudes tabulated in the table above (source code: [`images/make_plots.wl`](images/make_plots.wl)).

## Source

Original post: Charles J. Ammon, ["Don't Study Large Earthquakes with Mathematica's EarthquakeData"](https://sites.psu.edu/charlesammon/2017/05/01/dont-study-large-earthquakes-with-mathematica/), *Charles J. Ammon – Online Notes*, May 1, 2017.
