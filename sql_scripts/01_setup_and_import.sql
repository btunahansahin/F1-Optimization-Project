CREATE TABLE drivers (
    driverId INT PRIMARY KEY,
    driverRef VARCHAR(255),
    number VARCHAR(10),
    code VARCHAR(10),
    forename VARCHAR(255),
    surname VARCHAR(255),
    dob DATE,
    nationality VARCHAR(255),
    url TEXT
);

-- 2. Takımlar (Constructors) Tablosu
CREATE TABLE constructors (
    constructorId INT PRIMARY KEY,
    constructorRef VARCHAR(255),
    name VARCHAR(255),
    nationality VARCHAR(255),
    url TEXT
);

-- 3. Yarışlar Tablosu
CREATE TABLE races (
    raceId INT PRIMARY KEY,
    year INT,
    round INT,
    circuitId INT,
    name VARCHAR(255),
    date DATE,
    time TIME,
    url TEXT,
    fp1_date DATE,
    fp1_time TIME,
    fp2_date DATE,
    fp2_time TIME,
    fp3_date DATE,
    fp3_time TIME,
    quali_date DATE,
    quali_time TIME,
    sprint_date DATE,
    sprint_time TIME
);

-- 4. Pit Stoplar Tablosu
CREATE TABLE pit_stops (
    raceId INT,
    driverId INT,
    stop INT,
    lap INT,
    time TIME,
    duration VARCHAR(255), -- Milisaniye dışındaki string ifadeler için VARCHAR tuttuk, sonra temizleyeceğiz.
    milliseconds INT,
    PRIMARY KEY (raceId, driverId, stop)
);

-- 5. Yarış Sonuçları Tablosu
CREATE TABLE results (
    resultId INT PRIMARY KEY,
    raceId INT,
    driverId INT,
    constructorId INT,
    number VARCHAR(10),
    grid INT,
    position VARCHAR(10),
    positionText VARCHAR(255),
    positionOrder INT,
    points FLOAT,
    laps INT,
    time VARCHAR(255),
    milliseconds VARCHAR(255),
    fastestLap VARCHAR(10),
    rank INT,
    fastestLapTime VARCHAR(255),
    fastestLapSpeed VARCHAR(255),
    statusId INT
);