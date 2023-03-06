view: stats_pub_name {
derived_table: {
  sql: with stats as (
  select agency_id,client_id,publisher_id,
   sum(case
    when is_valid = true then (event_spend * (1E0 / (1E0 - (publisher_entity_markdown / 100))) * (1E0 + (agency_markup / 100)) * (1E0 + (effective_cd_markup / 100)) * d_logic_ratio)
    else 0E0
  end) as CDSpend,
  sum(case
    when is_valid = true then (event_spend * (1E0 / (1E0 - (publisher_entity_markdown / 100))) * d_logic_ratio)
    else 0E0
  end) as MojoSpend,
sum(case
    when is_valid = true then (event_spend * d_logic_ratio)
    else 0E0
  end) as VPSpend
from tracking.modelled.view_tracking_event
where agency_id = 'uber'
and date(event_publisher_date) >=  date('2023-01-01')
and date(event_publisher_date) <  date('2023-02-01')
and should_contribute_to_joveo_stats = TRUE
group by agency_id,client_id,publisher_id
),
publisher_names as (select distinct agency_id,publisher_id,name from idp.modelled.publisher_management_publishers where agency_id = 'uber')
select stats.agency_id agency_id,client_id,cdspend,name from stats left join publisher_names on stats.agency_id = publisher_names.agency_id and stats.publisher_id = publisher_names.publisher_id ;;
}
dimension: agency_id {
  type: string
  sql: ${TABLE}.agency_id ;;
}
  dimension: client_id {
    type: string
    sql: ${TABLE}.client_id ;;
  }
  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }
  measure: cdspend {
    type: sum
    sql: ${TABLE}.cdspend ;;
  }
 }
