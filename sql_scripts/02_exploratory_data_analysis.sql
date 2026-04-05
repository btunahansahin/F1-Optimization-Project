-- Hangi Pistlerde Daha Çok Pit-Stop Yapılıyor --
SELECT 
    r.name AS yaris_adi,
    r.year AS yaris_yili,
    COUNT(p.stop) AS toplam_pit_stop_sayisi
FROM pit_stops p
INNER JOIN races r ON p.raceId = r.raceId
GROUP BY r.name, r.year
ORDER BY toplam_pit_stop_sayisi DESC
LIMIT 10;

-- 2023 Yılında Takımların Ortalama Pit-Stop Hızları --
SELECT 
    c.name AS takim_adi,
    COUNT(p.stop) AS toplam_pit_sayisi,
    ROUND(AVG(p.milliseconds) / 1000.0, 2) AS ortalama_pit_suresi_sn
FROM pit_stops p
JOIN races r ON p.raceId = r.raceId
JOIN results res ON p.raceId = res.raceId AND p.driverId = res.driverId
JOIN constructors c ON res.constructorId = c.constructorId
WHERE r.year = 2023
GROUP BY c.name
ORDER BY ortalama_pit_suresi_sn ASC;



