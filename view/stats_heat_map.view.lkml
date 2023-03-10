view: stats_heat_map {
  derived_table: {
    sql: select dayname(event_publisher_date) day_name,
case
when to_time(event_timestamp) <= time_from_parts(3,0,0) then '00:00 - 03:00'
when to_time(event_timestamp) > time_from_parts(3,0,0) and to_time(event_timestamp) <= time_from_parts(6,0,0) then '03:00 - 06:00'
when to_time(event_timestamp) > time_from_parts(6,0,0) and to_time(event_timestamp) <= time_from_parts(9,0,0) then '06:00 - 09:00'
when to_time(event_timestamp) > time_from_parts(9,0,0) and to_time(event_timestamp) <= time_from_parts(12,0,0) then '09:00 - 12:00'
when to_time(event_timestamp) > time_from_parts(12,0,0) and to_time(event_timestamp) <= time_from_parts(15,0,0) then '12:00 - 15:00'
when to_time(event_timestamp) > time_from_parts(15,0,0) and to_time(event_timestamp) <= time_from_parts(18,0,0) then '15:00 - 18:00'
when to_time(event_timestamp) > time_from_parts(18,0,0) and to_time(event_timestamp) <= time_from_parts(21,0,0) then '18:00 - 21:00'
else '21:00 - 24:00'

end time_category,
sum(case
    when is_valid = true then (event_spend * (1E0 / (1E0 - (publisher_entity_markdown / 100))) * (1E0 + (agency_markup / 100)) * (1E0 + (effective_cd_markup / 100)) * d_logic_ratio)
    else 0E0
  end) as CDSpend
from tracking.modelled.view_tracking_event where should_contribute_to_joveo_stats = TRUE and agency_id = 'uber' and event_publisher_date >= date('2023-01-01') and event_publisher_date< date('2023-02-01') group by event_publisher_date,case
when to_time(event_timestamp) <= time_from_parts(3,0,0) then '00:00 - 03:00'
when to_time(event_timestamp) > time_from_parts(3,0,0) and to_time(event_timestamp) <= time_from_parts(6,0,0) then '03:00 - 06:00'
when to_time(event_timestamp) > time_from_parts(6,0,0) and to_time(event_timestamp) <= time_from_parts(9,0,0) then '06:00 - 09:00'
when to_time(event_timestamp) > time_from_parts(9,0,0) and to_time(event_timestamp) <= time_from_parts(12,0,0) then '09:00 - 12:00'
when to_time(event_timestamp) > time_from_parts(12,0,0) and to_time(event_timestamp) <= time_from_parts(15,0,0) then '12:00 - 15:00'
when to_time(event_timestamp) > time_from_parts(15,0,0) and to_time(event_timestamp) <= time_from_parts(18,0,0) then '15:00 - 18:00'
when to_time(event_timestamp) > time_from_parts(18,0,0) and to_time(event_timestamp) <= time_from_parts(21,0,0) then '18:00 - 21:00'
else '21:00 - 24:00'
end ;;
  }
  dimension: day_name {
    type: string
    sql: ${TABLE}.day_name ;;
  }
  dimension: time_category {
    type: string
    sql: ${TABLE}.time_category ;;
  }
  measure: cdspend {
    type: number
    sql: ${TABLE}.cdspend ;;
  }
   }
