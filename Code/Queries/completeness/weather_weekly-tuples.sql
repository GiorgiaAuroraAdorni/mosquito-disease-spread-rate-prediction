SELECT count(null_attributes), avg(null_attributes), min(null_attributes), max(null_attributes) 
  FROM (
  SELECT wban, (  
    CASE WHEN wban IS null THEN 1 ELSE 0 END +
    CASE WHEN year IS null THEN 1 ELSE 0 END +
    CASE WHEN week_of_year IS null THEN 1 ELSE 0 END +
    CASE WHEN days_per_week IS null THEN 1 ELSE 0 END +
    CASE WHEN t_max IS null THEN 1 ELSE 0 END +
    CASE WHEN t_max_is_suspicious IS null THEN 1 ELSE 0 END +
    CASE WHEN t_min IS null THEN 1 ELSE 0 END +
    CASE WHEN t_min_is_suspicious IS null THEN 1 ELSE 0 END +
    CASE WHEN t_avg IS null THEN 1 ELSE 0 END +
    CASE WHEN t_avg_is_suspicious IS null THEN 1 ELSE 0 END +
--    CASE WHEN depart IS null THEN 1 ELSE 0 END +
    CASE WHEN depart_is_suspicious IS null THEN 1 ELSE 0 END +
    CASE WHEN dew_point IS null THEN 1 ELSE 0 END +
    CASE WHEN dew_point_is_suspicious IS null THEN 1 ELSE 0 END +
    CASE WHEN wet_bulb IS null THEN 1 ELSE 0 END +
    CASE WHEN wet_bulb_is_suspicious IS null THEN 1 ELSE 0 END +
    CASE WHEN heat IS null THEN 1 ELSE 0 END +
    CASE WHEN heat_is_suspicious IS null THEN 1 ELSE 0 END +
    CASE WHEN cool IS null THEN 1 ELSE 0 END +
    CASE WHEN cool_is_suspicious IS null THEN 1 ELSE 0 END +
--    CASE WHEN sunrise IS null THEN 1 ELSE 0 END +
    CASE WHEN sunrise_is_suspicious IS null THEN 1 ELSE 0 END +
--    CASE WHEN sunset IS null THEN 1 ELSE 0 END +
    CASE WHEN sunset_is_suspicious IS null THEN 1 ELSE 0 END +
    CASE WHEN code_sum_is_suspicious IS null THEN 1 ELSE 0 END +
--    CASE WHEN snow_depth IS null THEN 1 ELSE 0 END +
    CASE WHEN snow_depth_is_suspicious IS null THEN 1 ELSE 0 END +
--    CASE WHEN snow_water IS null THEN 1 ELSE 0 END +
    CASE WHEN snow_water_is_suspicious IS null THEN 1 ELSE 0 END +
--    CASE WHEN snow_fall IS null THEN 1 ELSE 0 END +
    CASE WHEN snow_fall_is_suspicious IS null THEN 1 ELSE 0 END +
    CASE WHEN precip_total IS null THEN 1 ELSE 0 END +
    CASE WHEN precip_total_is_suspicious IS null THEN 1 ELSE 0 END +
    CASE WHEN stn_pressure IS null THEN 1 ELSE 0 END +
    CASE WHEN stn_pressure_is_suspicious IS null THEN 1 ELSE 0 END +
    CASE WHEN sea_level IS null THEN 1 ELSE 0 END +
    CASE WHEN sea_level_is_suspicious IS null THEN 1 ELSE 0 END +
    CASE WHEN result_speed IS null THEN 1 ELSE 0 END +
    CASE WHEN result_speed_is_suspicious IS null THEN 1 ELSE 0 END +
    CASE WHEN result_dir IS null THEN 1 ELSE 0 END +
    CASE WHEN result_dir_is_suspicious IS null THEN 1 ELSE 0 END +
    CASE WHEN avg_speed IS null THEN 1 ELSE 0 END +
    CASE WHEN avg_speed_is_suspicious IS null THEN 1 ELSE 0 END +
    CASE WHEN max5_speed IS null THEN 1 ELSE 0 END +
    CASE WHEN max5_speed_is_suspicious IS null THEN 1 ELSE 0 END +
    CASE WHEN max5_dir IS null THEN 1 ELSE 0 END +
    CASE WHEN max5_dir_is_suspicious IS null THEN 1 ELSE 0 END +
    CASE WHEN max2_speed IS null THEN 1 ELSE 0 END +
    CASE WHEN max2_speed_is_suspicious IS null THEN 1 ELSE 0 END +
    CASE WHEN max2_dir IS null THEN 1 ELSE 0 END +
    CASE WHEN max2_dir_is_suspicious IS null THEN 1 ELSE 0 END +
    CASE WHEN code_sum_ra IS null THEN 1 ELSE 0 END +
    CASE WHEN code_sum_br IS null THEN 1 ELSE 0 END +
    CASE WHEN code_sum_hz IS null THEN 1 ELSE 0 END +
    CASE WHEN code_sum_ts IS null THEN 1 ELSE 0 END +
    CASE WHEN code_sum_smoke IS null THEN 1 ELSE 0 END +
    CASE WHEN code_sum_dz IS null THEN 1 ELSE 0 END +
    CASE WHEN code_sum_wind IS null THEN 1 ELSE 0 END +
    CASE WHEN code_sum_fg IS null THEN 1 ELSE 0 END +
    CASE WHEN code_sum_sn IS null THEN 1 ELSE 0 END +
    CASE WHEN code_sum_up IS null THEN 1 ELSE 0 END +
    CASE WHEN code_sum_hail IS null THEN 1 ELSE 0 END
  ) AS null_attributes FROM "Weather"
) AS stats
WHERE wban not in ('4807', '4879')
