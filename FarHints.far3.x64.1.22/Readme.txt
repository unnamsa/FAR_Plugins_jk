FarHints plugin for FAR 2/3
---------------------------

?????? ?????????? ????????? ???????? ????? ?? ??????????? ?????????.

????:

- ????????? ?????????? ????????????? ? ??????? ???? ??? ??????? ???????
  ??????? ??? ??????????? ???????????. ????????????? ????? ?????????
  ????? ????????? ???????.

- ?????????????? ???-??????? ??? ?????? ??????? ?????? ????????? ?????.
- ??? ?????????????????? ????????? ????? ? ????????? ???????????? ??????.
- ??? ???????? ? ????????? ???????????? Version Info ? ?????? ?????????.
- ??? ???????? ???????????? ????? ???????? ? ?? ???????. ???????? 
  ????????????? ??????????????? ?????? (????????, ??????? ?????)
- ??? ????????? ?????????????? ?????? ??????????? ? ?????????? ??????.
- ??? MP3 ?????? ???????????? ????


????????????? FarHints ? ???????? (?????? ??? Far3):

  Plugin.Call(ID, ???????, ?????????...)

???  

  ID = "CDF48DA0-0334-4169-8453-69048DD3B51C"

???????:

 "Visible"

   ?????????? True ???? ????????? ?????

 "Hide"
 
   ?????? ?????????, ???? ??? ?????.

 "Show", {Mode}

   ???????? ????????? ??? ?????
     Mode = 1 - ? ??????? ???? (?? ?????????)
     Mode = 2 - ? ??????? ???????

 "Size", {+/-1}

   ?????????/????????? ?????? ??????. 
   (?????????? ????? ???????????????? ?????? ??????? ?????)


 "Info", "?????", {X,} {Y,} {MSec}

   ???????? ?????????????? ?????????. ????????? ????????????? ????????
   ????? ???????? ???????? ??????? (?? ????????? - 3 ???). 

   ????? ?????? ??????? X:Y ? ??????? ???????? ?????????. 
   ???? Y < 0, ?? ?????????  ???????? ? ?????? ?????? ??????? - Y. 
   ???? X = -1 ?? ????????? ???????????? ?? ???????????.

 "Color", RGB

   ?????? ???? ???? ????????? ? ??????? RGB

 "FontColor", RGB

   ?????? ???? ?????? ????????? ? ??????? RGB
   
 "FontSize", Size

   ?????? ?????? ?????? ?????????

 "Transparency", Value

   ?????? ???????????????? ????????? 
   ???????? ?? 0 (??????????) ?? 255 (????????????)


 ??????????: ???????, ??????????????? ???????? ????????? (Color, FontSize...)
 ?????? ?????? ?? ??????? ?????????, ???? ??? ?????? ? ???????????? ???? 
 ????????? ???. ????? ???????? ????????? ? ?????????????? ??????????
 ????????????? ???????????? ????????? ?????????????????? ???????:

 Plugin.Call(ID, "Info", "")           -- ??????? ?????? ?????????
 Plugin.Call(ID, "Color", 0x0000FF)    -- ????????????? ????
 Plugin.Call(ID, "Info", "?????????")  -- ?????????? ?????????
