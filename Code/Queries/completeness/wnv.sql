SELECT
    COUNT(*) as all_rows,
    COUNT(season_year) as season_year,
    COUNT(week) as week,
    COUNT(test_id) as test_id,
    COUNT(block) as block,
    COUNT(trap) as trap,
    COUNT(trap_type) as trap_type,
    COUNT(test_date) as test_date,
    COUNT(number_of_mosquitoes) as number_of_mosquitoes,
    COUNT(result) as result,
    COUNT(species) as species,
    COUNT(day_of_week) as day_of_week,
    COUNT(latitude) as latitude,
    COUNT(longitude) as longitude,
    COUNT(main_trap) as main_trap,
    COUNT(sub_trap) as sub_trap
  FROM "WNV"
