# rkolada

Simple R package to access the Kolada API (http://www.kolada.se/).

***~ development version, beware of possible bugs ~***

    library(rkolada)  # devtools::install_github('reinholdsson/rkolada')
    a <- rkolada::rkolada()

## Get kpi:s

**`a$kpi()`**  # get all kpi:s

    fetching http://api.kolada.se/v2/kpi ...
    Source: local data table [3,660 x 13]
    
       kpi.auspices                                                                                                                                           kpi.description kpi.has_ou_data kpi.id kpi.is_divided_by_gender
    1             E                                             Personalkostnader kommunen totalt, dividerat med verksamhetens kostnader kommun. Avser egen regi. Källa: SCB.           FALSE N00002                    FALSE
    2             E                                                Personalkostnader kommunen totalt, dividerat med antal invånare totalt 31/12. Avser egen regi. Källa: SCB.           FALSE N00003                    FALSE
    3             X                                                               Kommunalekonomisk utjämning kommun, dividerat med antal invånare totalt 31/12 . Källa: SCB.           FALSE N00005                    FALSE
    4            NA                                                                                                     Momsavgift, dividerat med antal invånare totalt 31/12           FALSE N00006                    FALSE
    5             X                                                                                              Invånarrelaterat bidrag, kronor per invånare den 1/11 fg år.           FALSE N00007                    FALSE
    6             X                                                                                              Åldersrelaterat bidrag i kronor per invånare den 1/11 fg år.           FALSE N00008                    FALSE
    7            NA Externa intäkter exklusive intäkter från försäljning till andra kommuner och landsting för mmunen totalt, dividerat med antal invånare 31/12. Källa: SCB.           FALSE N00009                    FALSE
    8            NA                                                                        Inkomstutjämning, bidrag/avgift, i kronor per invånare den 1/11 fg år. Källa: SCB.           FALSE N00011                    FALSE
    9            NA                                                                   Kostnadsutjämning, bidrag/avgift, i kronor per invånare den 1/11 nov fg år. Källa: SCB.           FALSE N00012                    FALSE
    10            X                                                                                       Generellt statsbidrag (-2004) i kronor per invånare den 1/11 fg år.           FALSE N00013                    FALSE
    ..          ...                                                                                                                                                       ...             ...    ...                      ...
    Variables not shown: kpi.municipality_type (chr), kpi.operating_area (chr), kpi.perspective (chr), kpi.prel_publication_date (date), kpi.publ_period (int), kpi.publication_date (date), kpi.title (chr),
      kpi.ou_publication_date (date)
    
**`a$kpi(c('N00008', 'N00009'))`**

    fetching http://api.kolada.se/v2/kpi/N00008,N00009 ...
    Source: local data table [2 x 12]
    
      kpi.auspices                                                                                                                                           kpi.description kpi.has_ou_data kpi.id kpi.is_divided_by_gender
    1            X                                                                                              Åldersrelaterat bidrag i kronor per invånare den 1/11 fg år.           FALSE N00008                    FALSE
    2           NA Externa intäkter exklusive intäkter från försäljning till andra kommuner och landsting för mmunen totalt, dividerat med antal invånare 31/12. Källa: SCB.           FALSE N00009                    FALSE
    Variables not shown: kpi.municipality_type (chr), kpi.operating_area (chr), kpi.perspective (chr), kpi.title (chr), kpi.prel_publication_date (date), kpi.publ_period (int), kpi.publication_date (date)

## Get municipalities

**`a$municipality()`**  # get all municipalites

    fetching http://api.kolada.se/v2/municipality ...
    Source: local data table [311 x 3]
    
       municipality.id municipality.title municipality.type
    1             1440                Ale                 K
    2             1489           Alingsås                 K
    3             0764            Alvesta                 K
    4             0604              Aneby                 K
    5             1984             Arboga                 K
    6             2506           Arjeplog                 K
    7             2505         Arvidsjaur                 K
    8             1784             Arvika                 K
    9             1882          Askersund                 K
    10            2084             Avesta                 K
    ..             ...                ...               ...

**`a$municipality(1440:1489)`**

    fetching http://api.kolada.se/v2/municipality/1440,1441,1442,1443,1444,1445,1446,1447,1448,1449,1450,1451,1452,1453,1454,1455,1456,1457,1458,1459,1460,1461,1462,1463,1464,1465,1466,1467,1468,1469,1470,1471,1472,1473,1474,1475,1476,1477,1478,1479,1480,1481,1482,1483,1484,1485,1486,1487,1488,1489 ...
    Source: local data table [28 x 3]
    
       municipality.id municipality.title municipality.type
    1             1440                Ale                 K
    2             1489           Alingsås                 K
    3             1460         Bengtsfors                 K
    4             1443          Bollebygd                 K
    5             1445            Essunga                 K
    6             1444           Grästorp                 K
    7             1447          Gullspång                 K
    8             1480           Göteborg                 K
    9             1471             Götene                 K
    10            1466         Herrljunga                 K
    ..             ...                ...               ...

## Get values

**`a$values('N00006', '0764', 2000:2010)`**

    fetching http://api.kolada.se/v2/data/kpi/N00006/municipality/0764/year/2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010 ...
    Source: local data table [3 x 7]
    
      kpi.id municipality.id period count gender status value
    1 N00006            0764   2000     1      T        -2096
    2 N00006            0764   2001     1      T        -2272
    3 N00006            0764   2002     1      T        -2467

**`a$values('N00006', '0764', 2000:2010, all.cols = T)`**  # with extra kpi and municipality columns (meta data)

    fetching http://api.kolada.se/v2/data/kpi/N00006/municipality/0764/year/2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010 ...
    fetching http://api.kolada.se/v2/kpi/N00006 ...
    fetching http://api.kolada.se/v2/municipality/0764 ...
    Source: local data table [3 x 16]
    
      municipality.id kpi.id period count gender status value                                       kpi.description kpi.has_ou_data kpi.is_divided_by_gender kpi.municipality_type    kpi.operating_area kpi.perspective
    1            0764 N00006   2000     1      T        -2096 Momsavgift, dividerat med antal invånare totalt 31/12           FALSE                    FALSE                     K Skatter och utjämning        Resurser
    2            0764 N00006   2001     1      T        -2272 Momsavgift, dividerat med antal invånare totalt 31/12           FALSE                    FALSE                     K Skatter och utjämning        Resurser
    3            0764 N00006   2002     1      T        -2467 Momsavgift, dividerat med antal invånare totalt 31/12           FALSE                    FALSE                     K Skatter och utjämning        Resurser
    Variables not shown: kpi.title (chr), municipality.title (chr), municipality.type (chr)
    
**`a$values(c('N00006', 'N00007'))`**  # get all municipalites and years of both kpi:s

    fetching http://api.kolada.se/v2/municipality ...
    fetching http://api.kolada.se/v2/data/kpi/N00006,N00007/municipality/1440,1489,0764,0604,1984,2506,2505,1784,1882,2084,1460,2326,2403,1260,2582,1443,2183,0885,2081,1490,0127,0560,1272,2305,1231,1278,1438,0162,1862,2425,1730,0125,0686,0862,0381,0484,1285,1445,1982,1382,1499,2080,1782,0562,0482,1763,1439,2026,0662,0461,0617,0980,1764,1444,1447,2523,2180,1480,1471,0643,1783,1861,1961,1380,1761,0136,2583,0331,2083,1283,1466,1497,2104,0126,2184,0860,1315,0305,1863,2361,2280,1401,1293,1284,0821,1266,1267,2510,0023,0123,0680,2514,0880,1446,1082,1883,1080,1780,0483,1715,0513,2584,1276,0330,2282,1290,1781,2309,1881,1384,1960,1482,1261,1983,1381,1282,0010,0020,0021,0006,0008,0003,0017,0005,0007,0004,0022,0019,1860,1814,2029,1441,0761,0186,1494,1462,1885,0580,0781,2161,1864,1262,2085,2580,1281,2481,1484,1280,2023,2418,1493,1463,0767,1461,0586,2062,0583,0642,1430,1762,1481,0861,0840,0182,1884,1962,2132,2401,0025,0581,0188,2417,0881,0140,0480,0192,0682,2101,1060,2034,1421,1273,0882,2121,0481,2521,1402,1275,2581,2303,0009,0013,0012,2409,1081,2031,1981,0128,2181,0191,1291,1265,1495,2482,1904,1264,1496,2061,2283,0163,0184,2422,1427,1230,1415,0180,0001,1760,2421,0486,1486,2313,0183,2281,1766,1907,1214,1263,1465,1785,2082,0684,2182,0582,0181,1083,1435,1472,1498,0360,2262,0763,1419,1270,1737,0834,1452,0687,1287,1488,0488,0138,0160,1473,1485,1491,2480,0114,0139,0380,0760,0584,0665,0563,0115,2021,1470,1383,0187,1233,0685,2462,0884,2404,0428,1442,1487,2460,0120,0683,0024,0883,1980,0014,0780,0512,1286,1492,2260,2321,1765,2463,1277,0561,0765,2039,0319,2560,1292,1407,0509,1880,0018,1257,2284,2380,0117,0382,1256,2513,2518/year/1970,1971,1972,1973,1974,1975,1976,1977,1978,1979,1980,1981,1982,1983,1984,1985,1986,1987,1988,1989,1990,1991,1992,1993,1994,1995,1996,1997,1998,1999,2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015 ...
    Source: local data table [4,925 x 7]
    
       kpi.id municipality.id period count gender status value
    1  N00006            0114   1998     1      T        -1784
    2  N00006            0115   1998     1      T        -1777
    3  N00006            0117   1998     1      T        -1785
    4  N00006            0120   1998     1      T        -1740
    5  N00006            0123   1998     1      T        -1785
    6  N00006            0125   1998     1      T        -1798
    7  N00006            0126   1998     1      T        -1779
    8  N00006            0127   1998     1      T        -1803
    9  N00006            0128   1998     1      T        -1790
    10 N00006            0136   1998     1      T        -1777
    ..    ...             ...    ...   ...    ...    ...   ...
