(* Compare Wolfram EarthquakeData magnitudes against authoritative reference magnitudes
   for the earthquakes discussed in Ammon (2017) "Don't Study Large Earthquakes with
   Mathematica's EarthquakeData". Values pulled live from EarthquakeData on this
   installation (Wolfram 15.0.1) vs. published USGS/NOAA/GCMT reference magnitudes. *)

labels = {
  "1812\nCaracas",
  "1827\nColombia",
  "1868\nArica, Chile",
  "1952\nKamchatka",
  "1960\nChile",
  "1964\nAlaska",
  "2004\nSumatra",
  "2011\nTohoku",
  "2016\nSolomon Is."
};

wolframMag   = {9.6, 9.7, 9.5, 8.5, 8.5, 8.5, 8.9, 9.0, 8.0};
referenceMag = {7.0, 7.0, 8.5, 9.0, 9.5, 9.2, 9.1, 9.0, 7.8};
refSource    = {"NOAA", "NOAA", "NOAA", "USGS", "USGS", "USGS", "USGS", "USGS/GCMT", "USGS/GCMT"};

chart = BarChart[
  Transpose[{wolframMag, referenceMag}],
  ChartLabels -> {Placed[labels, Axis], None},
  ChartLegends -> {"Wolfram EarthquakeData", "Reference (USGS/NOAA/GCMT)"},
  ChartStyle -> {RGBColor[0.85, 0.33, 0.10], RGBColor[0.15, 0.45, 0.70]},
  PlotLabel -> Style["Wolfram EarthquakeData Magnitude vs. Reference Magnitude", Bold, 15],
  AxesLabel -> {None, "Magnitude"},
  GridLines -> {None, {9.0}},
  GridLinesStyle -> Directive[Dashed, Gray],
  PlotRange -> {0, 10.6},
  ImageSize -> 900,
  AspectRatio -> 0.62,
  ImagePadding -> {{50, 20}, {60, 30}},
  LabelingFunction -> (Placed[NumberForm[#, {3, 1}], Above] &),
  Epilog -> {
    Text[Style["M \[GreaterEqual] 9.0 \"great earthquake\" cutoff", 11, Gray, Italic],
      Scaled[{0.83, 0.965}]]
  }
];
Export["/Users/wang208/Projects/wolfram_lang/earthquake/images/magnitude_comparison.png", chart, ImageResolution -> 150];
Print["Exported magnitude_comparison.png"];

(* Second plot: timeline of Wolfram's M>=9.0 catalog (what the search actually returns)
   vs. the true global M9+ earthquakes since 1900, showing the ones Wolfram's magnitude
   errors push below its own 9.0 threshold. *)

trueM9 = {
  {DateObject[{1952, 11, 4}], 9.0, "1952 Kamchatka"},
  {DateObject[{1960, 5, 22}], 9.5, "1960 Chile"},
  {DateObject[{1964, 3, 28}], 9.2, "1964 Alaska"},
  {DateObject[{2004, 12, 26}], 9.1, "2004 Sumatra"},
  {DateObject[{2011, 3, 11}], 9.0, "2011 Tohoku"}
};

wolframReturned = {
  {DateObject[{2011, 3, 11}], 9.0, "2011 Tohoku"}
};

wolframMissed = {
  {DateObject[{1952, 11, 4}], 9.0, "1952 Kamchatka (listed 8.5)"},
  {DateObject[{1960, 5, 22}], 9.5, "1960 Chile (listed 8.5)"},
  {DateObject[{1964, 3, 28}], 9.2, "1964 Alaska (listed 8.5)"},
  {DateObject[{2004, 12, 26}], 9.1, "2004 Sumatra (listed 8.9)"}
};

labelOffset = {0, -0.45, 0, -0.45, 0.45};
allPoints = Join[wolframMissed, wolframReturned];
allOffsets = Join[{-0.45, 0.45, -0.45, 0.45}, {0.45}];
allColors = Join[
  Table[RGBColor[0.85, 0.33, 0.10], {Length[wolframMissed]}],
  Table[RGBColor[0.15, 0.45, 0.70], {Length[wolframReturned]}]
];

timeline = Graphics[
  Join[
    {{Gray, Dashed, Line[{{AbsoluteTime[DateObject[{1948}]], 9.0}, {AbsoluteTime[DateObject[{2013}]], 9.0}}]}},
    Table[
      {
        {PointSize[0.02], allColors[[i]], Point[{AbsoluteTime[allPoints[[i, 1]]], allPoints[[i, 2]]}]},
        {Thin, allColors[[i]],
          Line[{{AbsoluteTime[allPoints[[i, 1]]], allPoints[[i, 2]]},
                {AbsoluteTime[allPoints[[i, 1]]], allPoints[[i, 2]] + allOffsets[[i]]}}]},
        Text[Style[allPoints[[i, 3]], 11, allColors[[i]], Bold],
          {AbsoluteTime[allPoints[[i, 1]]], allPoints[[i, 2]] + allOffsets[[i]] + If[allOffsets[[i]] > 0, 0.12, -0.12]}]
      },
      {i, Length[allPoints]}
    ]
  ],
  Frame -> True,
  FrameLabel -> {"Year", "Magnitude"},
  FrameTicks -> {
    {Table[{y, y}, {y, 8.5, 9.5, 0.5}], None},
    {Table[{AbsoluteTime[DateObject[{y}]], y}, {y, 1950, 2010, 10}], None}
  },
  PlotRangePadding -> 0,
  PlotRange -> {{AbsoluteTime[DateObject[{1948}]], AbsoluteTime[DateObject[{2013}]]}, {8.0, 10.1}},
  PlotLabel -> Style["Real M \[GreaterEqual] 9.0 Earthquakes Since 1950:\nWhat Wolfram's EarthquakeData[All, 9.0] Actually Returns", Bold, 14],
  ImageSize -> 950,
  AspectRatio -> 0.6,
  ImagePadding -> {{60, 20}, {50, 60}}
];
Export["/Users/wang208/Projects/wolfram_lang/earthquake/images/missing_great_earthquakes.png", timeline, ImageResolution -> 150];
Print["Exported missing_great_earthquakes.png"];
