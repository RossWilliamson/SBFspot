DROP VIEW IF EXISTS vwPvoData;
DROP VIEW IF EXISTS vwHomeData;

CREATE Table IF NOT EXISTS HomeData (
	TimeStamp datetime NOT NULL,
	NestTemp float,
	NestHumidity float,
	AtticTemp float,
	AtticFan int,
	PRIMARY KEY (TimeStamp)
);

CREATE VIEW vwHomeData AS
	SELECT datetime(Dat.TimeStamp, 'unixepoch', 'localtime') TimeStamp,
		datetime(CASE WHEN (Dat.TimeStamp % 300) < 150
		THEN Dat.TimeStamp - (Dat.TimeStamp % 300)
		ELSE Dat.TimeStamp - (Dat.TimeStamp % 300) + 300
		END, 'unixepoch', 'localtime') AS Nearest5min,

		Dat.NestTemp,
		Dat.NestHumidity,
		Dat.AtticTemp,
		Dat.AtticFan
	FROM [HomeData] Dat
	ORDER BY Dat.Timestamp Desc;

CREATE VIEW vwPvoData AS
	SELECT dd.Timestamp,
  	dd.Name,
    dd.Type,
    dd.Serial,
    dd.TotalYield AS V1,
    dd.Power AS V2,
    cons.EnergyUsed AS V3,
    cons.PowerUsed AS V4,
    spot.Temperature AS V5,
    spot.Uac1 AS V6,
    spot.Uac2 AS V7,
    spot.Temperature AS V8,
    home.NestTemp AS V9,
    home.NestHumidity AS V10,
    home.AtticTemp AS V11,
    home.AtticFan AS V12,
    dd.PVoutput
  FROM vwDayData AS dd
  	LEFT JOIN vwAvgSpotData AS spot
    	ON dd.Serial = spot.Serial AND dd.Timestamp = spot.Nearest5min
		LEFT JOIN vwHomeData AS home
			ON dd.Timestamp = home.Nearest5min
    LEFT JOIN vwAvgConsumption AS cons
     ON dd.Timestamp = cons.Nearest5min
  ORDER BY dd.Timestamp DESC;
