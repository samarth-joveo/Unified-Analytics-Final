view: stats_top_5_others {
  derived_table: {
    sql: with stats1 as (select publisher_id,
sum(clicks) value, 'Clicks' type
from tracking.modelled.view_grouped_tracking_event
where agency_id = 'uberjax'
and date(event_publisher_date) >=  date('2023-01-01')
and date(event_publisher_date) <  date('2023-02-01')
and should_contribute_to_joveo_stats = TRUE
group by publisher_id having sum(clicks)>0),
stats2 as (select publisher_id,
sum(applies) value, 'Applies' type
from tracking.modelled.view_grouped_tracking_event
where agency_id = 'uberjax'
and date(event_publisher_date) >=  date('2023-01-01')
and date(event_publisher_date) <  date('2023-02-01')
and should_contribute_to_joveo_stats = TRUE
group by publisher_id having sum(applies)>0),
stats3 as (select publisher_id,
sum(cd_spend) value, 'Spend' type
from tracking.modelled.view_grouped_tracking_event
where agency_id = 'uberjax'
and date(event_publisher_date) >=  date('2023-01-01')
and date(event_publisher_date) <  date('2023-02-01')
and should_contribute_to_joveo_stats = TRUE
group by publisher_id having sum(cd_spend)>0),
final_results as (select publisher_id,value,type,rank() over( order by value desc) rnk from stats1
union
select publisher_id,value,type,rank() over( order by value desc) rnk from stats2
union
select publisher_id,value,type,rank() over( order by value desc) rnk from stats3)
select value,type,iff(rnk>5,'Others',publisher_id) publisher_id from final_results ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }
  dimension: publisher_id {
    type: string
    sql: ${TABLE}.publisher_id ;;
  }
  measure: value {
    type: sum
    sql: ${TABLE}.value ;;
  }
}
