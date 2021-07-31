************************
*   作者： 重明论      *
*   日期： 2021.7.31   *
************************
* 数据导入
import excel "江苏区域经济数据.xlsx", sheet("元数据") cellrange(A2:E366) firstrow clear

* 计算区域GDP
bys area Year: egen Yi = sum(Yij)

* 计算总GDP
bys Year: egen Y = sum(Yij)

* 计算区域人口
bys area Year: egen Pi = sum(Pij)

* 计算总人口
bys Year: egen P = sum(Pij)

* 计算各区域的城市间差异
bys area Year: egen TPi = sum((Yij/Yi)*log((Yij/Yi)/(Pij/Pi)))

* 保留区域数据
drop city Yij Pij
* 去重 保留各区域每年唯一值
duplicates drop

* 计算总区域内差异
bys Year: egen TWR = sum((Yi/Y)*TPi)

* 计算总区域间差异
bys Year: egen TBR = sum((Yi/Y)*log((Yi/Y)/(Pi/P)))

* 计算泰尔指数（总区域差异）
gen Theil = TWR + TBR

* 保留年份 区域和指数数据
drop Yi Y Pi P

* 长表转宽表 每个区域指数单列
reshape wide TPi, i(Year TWR TBR Theil) j(area) string
