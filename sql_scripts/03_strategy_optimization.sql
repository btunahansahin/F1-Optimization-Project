-- Derinlemesine Analiz ve Pit-Stop Stratejisi (Undercut Analizi) --
WITH PitAnalizi AS (
    SELECT 
        r.name AS yaris,
        d.surname AS pilot,
        p.lap AS pit_turu,
        p.milliseconds AS pit_suresi_ms,
        -- Window Function: Bir önceki ve bir sonraki tur zamanlarını getiriyoruz
        LAG(p.milliseconds) OVER (PARTITION BY p.raceId, p.driverId ORDER BY p.lap) as onceki_pit_ms
    FROM pit_stops p
    JOIN races r ON p.raceId = r.raceId
    JOIN drivers d ON p.driverId = d.driverId
    WHERE r.year >= 2021 -- Yakın tarihlere odaklanalım
)
SELECT 
    yaris,
    pilot,
    pit_turu,
    ROUND(pit_suresi_ms / 1000.0, 3) AS pit_saniye
FROM PitAnalizi
WHERE pit_suresi_ms IS NOT NULL
ORDER BY pit_saniye ASC
LIMIT 20;