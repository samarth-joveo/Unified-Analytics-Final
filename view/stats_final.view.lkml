view: stats_final {
derived_table: {
  sql: select publisher_name,event_publisher_date,job_city,job_state,job_country,
sum(case
    when (
      event_type= 'CONVERSION'
      and conversion_type in ('CUSTOM_CONVERSION_1','SHORTLIST')    ) then event_count
    else 0
  end) as "Background_check",
     sum(case
     when (
       event_type = 'CLICK'
       and is_valid = 1
     ) then event_count
     else 0
   end) as CLICKS,
   sum(case
     when (
       event_type = 'CONVERSION'
       and conversion_type = 'APPLY'
     ) then event_count
     else 0
   end) as APPLIES,
       sum(case
     when (
       event_type = 'CONVERSION'
       and conversion_type = 'HIRE'
     ) then event_count
     else 0
   end) as HIRES,

    sum((event_spend * d_logic_ratio * (1E0 / (1E0 - (publisher_entity_markdown / 100))) * (1E0 + (agency_markup / 100)) * (1E0 + (effective_cd_markup / 100))))
   as CD_SPEND
FROM   tracking.modelled.VIEW_TRACKING_EVENT
       WHERE  agency_id='uber'
       and event_publisher_date >= date('2023-01-01') and event_publisher_date <= date('2023-03-01')
       and should_contribute_to_joveo_stats = TRUE
GROUP  BY publisher_name,event_publisher_date,job_city,job_state,job_country;;
}
dimension: publisher_name {
  type: string
  sql: ${TABLE}.publisher_name ;;
}
  dimension: date {
    type: date
    sql: ${TABLE}.event_publisher_date ;;
  }
  dimension: state {
    map_layer_name: us_states
    sql: ${TABLE}.job_state ;;
  }
  dimension: country {
    map_layer_name: countries
    sql: ${TABLE}.job_country ;;
  }
  measure: clicks{
    type: sum
    sql: ${TABLE}.clicks ;;
  }
  measure: applies {
    type: sum
    sql: ${TABLE}.applies ;;
  }
  measure: hires {
    type: sum
    sql: ${TABLE}.hires ;;
  }
  measure: cd_spend {
    type: sum
    sql: ${TABLE}.cd_spend ;;
  }
 }
