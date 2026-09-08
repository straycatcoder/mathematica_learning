# Don't Study Large Earthquakes with `EarthquakeData` — Independent Verification Re-run (muse-spark-1.3)

*Comparing Ammon (2017), Claude's follow-up, and ChatGPT's follow-up, with a fresh live re-verification in Wolfram Language*

- **Original:** Charles J. Ammon, ["Don't Study Large Earthquakes with Mathematica's EarthquakeData"](https://sites.psu.edu/charlesammon/2017/05/01/dont-study-large-earthquakes-with-mathematica/), May 1, 2017 (archived as `blogpost.webarchive`)
- **Follow-up A (Claude):** `blogpost-followup-claude-sonnet-5.md` — *"Nine Years Later … Still"*
- **Follow-up B (ChatGPT):** `blogpost-followup-GPT5.6-sol.md` — *"Revisiting Mathematica's earthquake data…"*
- **Prior verification:** `blogpost-independent-verification-muse-spark-1.2.md` (generated with **muse-spark-1.2**)
- **This re-run:** **muse-spark-1.3** (`PI_MODEL=muse-spark-1.3-contributor`, `PI_PROVIDER=meta`), September 4, 2026
- **Engine (unchanged):** Wolfram Language 15.0.1 for Mac OS X ARM (64-bit) (July 2, 2026), local `wolframscript` + USGS FDSN API

> **TL;DR:** The 1.3 re-run reproduces the 1.2 verification exactly. On WL 15.0.1, `EarthquakeData[All,8.0]` → **265** records, `EarthquakeData[All,9.0]` → the **same 5** events as 2017 at identical magnitudes. Both follow-ups are correct on the core; ChatGPT's extras (1964 Alaska duplicate, `Mi`/`mww`/`Missing` type-mixing, 2025 live failure, `178` vs `100` count gap) all re-verify. No claim needed correction between the 1.2 and 1.3 passes.

---

## 1. Why re-run?

The previous verification was produced under muse-spark-1.2. This post re-executes every live check from scratch under muse-spark-1.3 to confirm the findings are engine facts, not model-session artifacts, and to leave an auditable fresh log.

What was re-done (not copied):

1. Fresh `wolframscript` run (`/tmp/verify_1_3.wl`) — counts, `M≥9` list, per-event magnitudes/types/IDs, since-1900 count, Alaska duplicate probe, type tally, 2025 rows.
2. Fresh USGS FDSN `curl` checks — 7 `eventid` preferred `mag`/`magType` + `count?minmagnitude=8/9`.
3. Fresh comparison of the two follow-ups against the new log.

---

## 2. Follow-up comparison (unchanged conclusion, re-confirmed)

| Issue | Claude (A) | ChatGPT (B) | 1.3 live verdict |
|---|---|---|---|
| `M≥8` count 253 → ? | **265**, old rows untouched | 265, "changed, not a fix" | **265 confirmed** (`EQ8_COUNT=265`) |
| First record | Same 1096 Honshu `M8.3`, `34.2,137.3` | Same first entry | **Confirmed** (`8.300000190734863`, `Missing`) |
| `M≥9` list | Byte-identical 5 events | Same 5; 4×`Missing` + 1×`Mo` | **Confirmed** (`EQ9_COUNT=5`, see §3) |
| Historical inflated (1812 `9.6`, 1827 `9.7`, 1868 `9.5` vs NOAA ~`7.0`/`7.0`/`8.5`) | Unchanged | Unchanged + no-type note | **Confirmed** — same floats to 6dp |
| Modern deflated (1952/1960/1964/2004) | `8.5`/`8.5`/`8.5`/`8.9` vs `9.0`/`9.5`/`9.2`/`9.1` | `8.4–8.9` range | **Confirmed** (1964 resolves to `8.5`+`8.4` duplicate) |
| 2016 Solomon `8.0` vs USGS `7.8` | Still wrong | Still **`8.0 Mi` vs `7.8 mww`** | **Confirmed** (`at00ohvnon`, `Mi`) |
| Freshness through 2025 | ✅ appended | ✅ appended | **Confirmed** (latest `2025-07-29`, 2 rows) |
| Root cause: type-mixing | Implied | **Explicit** (`Mi`≡`Mwp` vs `Mww` vs `Missing`/`Mo`/`Mt`) | **Confirmed** (`Missing 243, mww 9, Mi 5, Mo 1, Mw 1, Mt 2, MI 1, Null 3`) |
| Duplicate 1964 Alaska | — | **`8.5` + `8.4`** | **Confirmed** (`ALASKA_DUP=2`) — B only, correct |
| 2025 Kamchatka live failure | Notes 2025 present | **`8.0 Mi` vs USGS `8.8 mww`**, Δ0.8 ≈ ×15.8 moment | **Direction confirmed, nuance kept**: WL now holds *both* `8.8 mww` and `8.0 Mi` 3 s apart (double-count) |
| Count since 1900 | — | **WL `178` vs USGS `100`** | **Confirmed** (`SINCE1900=178`; FDSN `count=100`) |
| Advice | Use USGS/ISC/GCMT | Same + hierarchy | Both stand |

No contradiction between A and B; B is a strict superset (mechanism + duplicates + counts + 2025 proof).

---

## 3. Fresh 1.3 live log (WL 15.0.1)

Script `/tmp/verify_1_3.wl`, run `wolframscript -file`:

```
Model rerun: muse-spark-1.3 | WL 15.0.1 for Mac OS X ARM (64-bit) (July 2, 2026)
EQ8_COUNT=265
FIRST=DateObject[{1096,12,17,0,0,0.},…] MAG=8.300000190734863 TYPE=Missing[NotAvailable]
EQ9_COUNT=5
EQ9_1=1687-10-20 MAG=9.                TYPE=Missing  ID=centennial50959
EQ9_2=1812-03-26 MAG=9.600000381469727 TYPE=Missing  ID=centennial51294
EQ9_3=1827-11-16 MAG=9.699999809265137 TYPE=Missing  ID=centennial51360
EQ9_4=1868-08-13 MAG=9.5               TYPE=Missing  ID=centennial51632
EQ9_5=2011-03-11 MAG=9.                TYPE=Mo       ID=USc0001xgp
E1952=1952-11-04 MAG=8.5               TYPE=Missing  ID=centennial52750
E1960=1960-05-22 MAG=8.5               TYPE=Missing  ID=centennial52883
E1964=1964-03-28 MAG=8.399999618530273 TYPE=Missing  ID=atlas627657  (+ atlas52948 8.5, see below)
E2004=2004-12-26 MAG=8.899999618530273 TYPE=Missing  ID=official22349
E2011=2011-03-11 MAG=9.                TYPE=Mo       ID=USc0001xgp
E2016=2016-12-08 MAG=8.                TYPE=Mi       ID=at00ohvnon
E2025=2025-07-29 MAG=8.800000190734863 TYPE=mww      ID=usus6000qw60-1753845839004 (+ atat00t06p1k 8. Mi)
E1812=1812-03-26 MAG=9.600000381469727 TYPE=Missing  ID=centennial51294
E1827=1827-11-16 MAG=9.699999809265137 TYPE=Missing  ID=centennial51360
E1868=1868-08-13 MAG=9.5               TYPE=Missing  ID=centennial51632
E1687=1687-10-20 MAG=9.                TYPE=Missing  ID=centennial50959
SINCE1900=178
ALASKA_DUP=2
  ALASKA_ROW=1964-03-28 8.5             ID=atlas52948
  ALASKA_ROW=1964-03-28 8.399999618530273 ID=atlas627657
TYPES={{Missing,243},{Mt,2},{MI,1},{Mo,1},{Mw,1},{Null,3},{mww,9},{Mi,5}}
Y2025_ROWS=2
  Y2025_ROW=2025-07-29 8.800000190734863 mww usus6000qw60-…
  Y2025_ROW=2025-07-29 8.                Mi  atat00t06p1k
```

Identical to the 1.2 pass to the last digit — the data did not shift between passes.

Repro:

```wolfram
eq8 = EarthquakeData[All, 8.0]; Length[eq8]  (* 265 *)
eq9 = EarthquakeData[All, 9.0]; Length[eq9]  (* 5 *)
getProp[a_, n_] := Values[a][[First@FirstPosition[ToString/@Keys[a], n]]]
```

---

## 4. Fresh USGS cross-check (1.3 re-run)

```bash
for id in official19521104165830_30 official19600522191120_30 \
  official19640328033616_30 official20041226005853450_30 \
  official20110311054624120_30 us20007z80 us6000qw60; do
  curl -s "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&eventid=$id" \
  | python3 -c "import sys,json; p=json.load(sys.stdin)['properties']; print(p['mag'],p['magType'],p['title'])"
done
curl -s "https://earthquake.usgs.gov/fdsnws/event/1/count?starttime=1900-01-01&minmagnitude=8" # → 100
curl -s "https://earthquake.usgs.gov/fdsnws/event/1/count?starttime=1900-01-01&minmagnitude=9" # → 5
```

Result (same as 1.2):

```
9.0  mw  | M 9.0 - 89 km ESE of Petropavlovsk-Kamchatsky, Russia (1952)
9.5  mw  | M 9.5 - 1960 Great Chilean Earthquake (Valdivia)
9.2  mw  | M 9.2 - The 1964 Prince William Sound, Alaska Earthquake
9.1  mw  | M 9.1 - 2004 Sumatra-Andaman Islands Earthquake
9.1  mww | M 9.1 - 2011 Great Tohoku Earthquake, Japan
7.8  mww | M 7.8 - 69 km WSW of Kirakira, Solomon Islands (2016)
8.8  mww | M 8.8 - 2025 Kamchatka Peninsula, Russia Earthquake
counts: M≥8 → 100, M≥9 → 5
```

Hence the deficits re-confirm: `−0.5` (1952), `−1.0` (1960, largest ever), `−0.7/−0.8` (1964 dup), `−0.2` (2004), `−0.1` (2011, still passes). Only Tohoku survives `≥9` in WL.

Historical note (unchanged): 1812/1827 `9.6`/`9.7` vs NCEI ~`7.0` (+2–2.7); 1868 `9.5` vs modern `8.8–9.0` (USGS archive `9.0`; tide-gauge inversion doi `10.1029/2024GL113849`) — `8.5` cited by Ammon/Claude/ChatGPT is slightly low today, but `9.5` remains an unqualified `Missing`-type outlier.

---

## 5. 1.2 vs 1.3: what changed?

Nothing substantive. Every number re-verified equal:

- `265` / `5` / `178` / `100` / `5` all equal across passes.
- All 11 per-event magnitudes equal to `10⁻⁶`.
- Type tally, duplicate counts, 2025 doubling all equal.
- USGS preferred values unchanged.

The 1.3 pass therefore promotes the prior "verified once" to "verified twice, independently re-executed." The two nuances from 1.2 carry over: (a) 1868's reference is better stated as `8.8–9.0` than flat `8.5`; (b) 2025 is a *doubling* (`8.8 mww` + `8.0 Mi` as separate "earthquakes") plus a `0.8` deficit on the `Mi` leg — ChatGPT's "active failure" conclusion stands.

---

## 6. Conclusion (re-affirmed)

Ammon (2017) holds on WL 15.0.1: **do not use the generic `EarthquakeData` `Magnitude` for large/historical threshold science.** The catalog was extended (253→265 through July 2025) but not curated — same four `Missing`-type `9.0–9.7` inflations, same four instrumental `M9` suppressions, same `2016 Mi` threshold error, plus a new 2025 `Mi`/`mww` doubling.

For research, import preferred magnitudes first ([USGS Search](https://earthquake.usgs.gov/earthquakes/search/) / [FDSN](https://earthquake.usgs.gov/fdsnws/event/1/), [ISC](https://www.isc.ac.uk/), [GCMT](https://www.globalcmt.org/)), then use WL for analysis/visualization. If you must use `EarthquakeData`, never filter the bare `Magnitude` — require a common `MagnitudeType`.

---

## Sources

1. Ammon (2017), original post + `blogpost.webarchive`.
2. Follow-up A (Claude), `blogpost-followup-claude-sonnet-5.md`; figs `images/`.
3. Follow-up B (ChatGPT), `blogpost-followup-GPT5.6-sol.md`; figs `figures/`, `generate_figures.wl`.
4. Prior verification (muse-spark-1.2), `blogpost-independent-verification-muse-spark-1.2.md`.
5. This re-run (muse-spark-1.3): `/tmp/verify_1_3.wl` log above; USGS FDSN `eventid`/`count` queries above.
6. USGS [Magnitude Types](https://www.usgs.gov/programs/earthquake-hazards/magnitude-types); [20 Largest Since 1900](https://www.usgs.gov/programs/earthquake-hazards/science/20-largest-earthquakes-world-1900); ISC [magnitude standards](https://www.isc.ac.uk/standards/magnitudes/).
