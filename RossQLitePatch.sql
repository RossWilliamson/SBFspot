DROP VIEW IF EXISTS vwPvoData;

CREATE Table HomeData (
	TimeStamp datetime NOT NULL,
	NestTemp float,
	NestHumidity float,
	AtticTemp float,
	AtticFan int,
	PRIMARY KEY (TimeStamp)
);

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
              NULL AS V9,
              NULL AS V10,
              NULL AS V11,
              NULL AS V12,
              dd.PVoutput
         FROM vwDayData AS dd
              LEFT JOIN vwAvgSpotData AS spot
                     ON dd.Serial = spot.Serial AND dd.Timestamp = spot.Nearest5min
              LEFT JOIN vwAvgConsumption AS cons
                     ON dd.Timestamp = cons.Nearest5min
        ORDER BY dd.Timestamp DESC;
