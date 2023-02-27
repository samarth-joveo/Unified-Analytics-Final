view: stats_view_tracking_event_trend {
    derived_table: {
      sql: select agency_id,client_id,campaign_id,job_group_id,publisher_id,'Jan 2023' "Month",day(event_publisher_date) day,
sum(clicks) clicks,sum(applies) applies,sum(hires) hires,sum(cd_spend) spend
from tracking.modelled.view_grouped_tracking_event
where agency_id = 'uber'
and date(event_publisher_date) >=  date('2023-01-01')
and date(event_publisher_date) <  date('2023-02-01')
and should_contribute_to_joveo_stats = TRUE
group by agency_id,client_id,campaign_id,job_group_id,publisher_id,event_publisher_date
union
select agency_id,client_id,campaign_id,job_group_id,publisher_id,'Dec 2020' "Month",day(event_publisher_date) day,
sum(clicks) clicks,sum(applies) applies,sum(hires) hires,sum(cd_spend) spend
from tracking.modelled.view_grouped_tracking_event
where agency_id = 'uber'
and date(event_publisher_date) >=  date('2023-12-01')
and date(event_publisher_date) <  date('2023-01-01')
and should_contribute_to_joveo_stats = TRUE
group by agency_id,client_id,campaign_id,job_group_id,publisher_id,event_publisher_date ;;
    }
  dimension: month_name {
    type: string
    sql:  ${TABLE}."Month" ;;
  }
  dimension: day {
    type: number
    sql:  ${TABLE}.day;;
  }
  measure: total_spend {
    type: sum
    sql:  ${TABLE}.spend ;;
  }
 }
