SELECT 
    COUNT(*) as all_rows,
    COUNT(wban) as wban,
    COUNT(wmo) as wmo,
    COUNT(call_sign) as call_sign,
    COUNT(climate_division_code) as climate_division_code,
    COUNT(climate_division_state_code) as climate_division_state_code,
    COUNT(climate_division_station_code) as climate_division_station_code,
    COUNT(name) as name,
    COUNT(state) as state,
    COUNT(location) as location,
    COUNT(latitude) as latitude,
    COUNT(longitude) as longitude,
    COUNT(ground_height) as ground_height,
    COUNT(station_height) as station_height,
    COUNT(barometer) as barometer,
    COUNT(time_zone) as time_zone
  FROM "Station"
