(* Generate the figures used by earthquake-data-quality-revisited.md. *)

SetDirectory[DirectoryName[$InputFileName]];

wolframBlue = RGBColor[0.16, 0.42, 0.72];
usgsOrange = RGBColor[0.88, 0.35, 0.12];
guideGray = GrayLevel[0.78];
textGray = GrayLevel[0.18];

eventLabels = {
   "2016 Solomon Islands",
   "1952 Kamchatka",
   "1960 Chile",
   "1964 Alaska",
   "2004 Sumatra",
   "2011 Tohoku",
   "2025 Kamchatka"
   };

wolframMagnitudes = {8.0, 8.5, 8.5, 8.5, 8.9, 9.0, 8.0};
usgsMagnitudes = {7.8, 9.0, 9.5, 9.2, 9.1, 9.1, 8.8};
yPositions = Reverse@Range[Length[eventLabels]];

comparisonGraphic = Graphics[
   {
    {guideGray, AbsoluteThickness[3],
     MapThread[Line[{{#1, #3}, {#2, #3}}] &,
      {wolframMagnitudes, usgsMagnitudes, yPositions}]},
    {wolframBlue, PointSize[0.018],
     Point@Transpose[{wolframMagnitudes, yPositions}]},
    {usgsOrange, PointSize[0.018],
     Point@Transpose[{usgsMagnitudes, yPositions}]},
    MapThread[
     Text[Style[NumberForm[#1, {2, 1}], 17, Bold, wolframBlue],
       {#1, #3}, {0, 2.15}] &, {wolframMagnitudes, usgsMagnitudes,
      yPositions}],
    MapThread[
     Text[Style[NumberForm[#2, {2, 1}], 17, Bold, usgsOrange],
       {#2, #3}, {0, -2.15}] &, {wolframMagnitudes, usgsMagnitudes,
      yPositions}]
    },
   Frame -> True,
   Axes -> False,
   FrameTicks -> {
     {Thread[{yPositions, Style[#, 17, textGray] & /@ eventLabels}], None},
     {Range[7.5, 9.75, 0.25], None}
     },
   FrameLabel -> {Style["Reported magnitude", 19, textGray], None},
   PlotRange -> {{7.5, 9.75}, {0.45, Length[eventLabels] + 0.55}},
   PlotRangePadding -> {{Scaled[0.015], Scaled[0.02]}, {0, 0}},
   GridLines -> {Range[7.5, 9.75, 0.25], None},
   GridLinesStyle -> Directive[GrayLevel[0.9], Thin],
   ImageSize -> 1600,
   AspectRatio -> 0.53,
   Background -> White,
   BaseStyle -> {FontFamily -> "Helvetica"}
   ];

comparisonFigure = Labeled[
   Legended[
    comparisonGraphic,
    Placed[
     PointLegend[{wolframBlue, usgsOrange},
      {"Wolfram EarthquakeData", "USGS preferred magnitude"},
      LegendMarkerSize -> 18,
      LabelStyle -> Directive[17, FontFamily -> "Helvetica"]],
     Above]],
   Style["Selected magnitude discrepancies", 25, Bold, textGray],
   Top];

Export[FileNameJoin[{"figures", "magnitude-comparison.png"}],
 comparisonFigure, ImageResolution -> 180];

wolframM9 = {
   {1687, 9.0, "1687  M9.0"},
   {1812, 9.6, "1812  M9.6"},
   {1827, 9.7, "1827  M9.7"},
   {1868, 9.5, "1868  M9.5"},
   {2011, 9.0, "2011  M9.0"}
   };

usgsM9 = {
   {1952, 9.0, "1952  M9.0"},
   {1960, 9.5, "1960  M9.5"},
   {1964, 9.2, "1964  M9.2"},
   {2004, 9.1, "2004  M9.1"},
   {2011, 9.1, "2011  M9.1"}
   };

wolframLabelPositions = {
   {1687, 1.72}, {1794, 1.78}, {1844, 2.02}, {1868, 1.75}, {2011, 1.75}
   };
usgsLabelPositions = {
   {1935, -0.20}, {1960, -0.53}, {1983, -0.20},
   {1995, -0.53}, {2022, -0.20}
   };

timelineGraphic = Graphics[
   {
    {GrayLevel[0.72], AbsoluteThickness[3],
     Line[{{1650, 1.35}, {2030, 1.35}}],
     Line[{{1650, 0.15}, {2030, 0.15}}]},
    {wolframBlue, PointSize[0.017],
     Point[({#[[1]], 1.35} & /@ wolframM9)]},
    {usgsOrange, PointSize[0.017],
     Point[({#[[1]], 0.15} & /@ usgsM9)]},
    MapThread[
     {
       {Directive[wolframBlue, Opacity[0.55], AbsoluteThickness[1.5]],
        Line[{{#1[[1]], 1.35}, #2}]},
       Text[Style[#1[[3]], 16, Bold, wolframBlue], #2, {0, -1.2}]
       } &, {wolframM9, wolframLabelPositions}],
    MapThread[
     {
       {Directive[usgsOrange, Opacity[0.55], AbsoluteThickness[1.5]],
        Line[{{#1[[1]], 0.15}, #2}]},
       Text[Style[#1[[3]], 16, Bold, usgsOrange], #2, {0, 1.2}]
       } &, {usgsM9, usgsLabelPositions}]
    },
   Frame -> True,
   Axes -> False,
   FrameTicks -> {
     {{{1.35, Style["Wolfram ≥9", 18, wolframBlue]},
       {0.15, Style["USGS ≥9 since 1900", 18, usgsOrange]}}, None},
     {Range[1650, 2025, 25], None}
     },
   FrameLabel -> {Style["Year", 19, textGray], None},
   PlotRange -> {{1645, 2035}, {-0.80, 2.20}},
   GridLines -> {Range[1650, 2025, 25], None},
   GridLinesStyle -> Directive[GrayLevel[0.91], Thin],
   ImageSize -> 1600,
   AspectRatio -> 0.42,
   Background -> White,
   BaseStyle -> {FontFamily -> "Helvetica"}
   ];

timelineFigure = Labeled[
   timelineGraphic,
   Style["Which earthquakes pass the magnitude-9 threshold?", 25, Bold,
    textGray],
   Top];

Export[FileNameJoin[{"figures", "magnitude-9-timeline.png"}],
 timelineFigure, ImageResolution -> 180];

Print["Generated figures/magnitude-comparison.png"];
Print["Generated figures/magnitude-9-timeline.png"];
