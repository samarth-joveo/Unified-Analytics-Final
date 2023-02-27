view: stats_view_tracking_event {
 derived_table: {
   sql: select agency_id,client_id,campaign_id,job_group_id,publisher_id,event_publisher_date,
sum(clicks) clicks,sum(applies) applies,sum(hires) hires,sum(cd_spend) spend
from tracking.modelled.view_grouped_tracking_event
where agency_id = 'uber'
and date(event_publisher_date) >=  date('2023-01-01')
and date(event_publisher_date) <  date('2023-02-01')
and should_contribute_to_joveo_stats = TRUE
group by agency_id,client_id,campaign_id,job_group_id,publisher_id,event_publisher_date
  ;;
 }
dimension: client_id {
  type: string
  sql:  ${TABLE}.client_id ;;
}
dimension: campaign_id {
    type: string
    sql:  ${TABLE}.campaign_id ;;
  }
  dimension: job_group_id {
    type: string
    sql:  ${TABLE}.job_group_id ;;
  }
  dimension: publisher_id {
    type: string
    sql:  ${TABLE}.publisher_id ;;
  }
  dimension: event_publisher_date {
    type: date
    sql:  ${TABLE}.event_publisher_date ;;
  }
  dimension: clicks {
    type: number
    sql:  ${TABLE}.clicks ;;
  }
  dimension: applies {
    type: number
    sql:  ${TABLE}.applies ;;
  }
  dimension: hires {
    type: number
    sql:  ${TABLE}.hires ;;
  }
  dimension: spend {
    type: number
    sql:  ${TABLE}.spend ;;
  }
  measure: sum_clicks {
    type: sum
    sql:  ${clicks} ;;
  }
  measure: sum_applies {
    type: sum
    sql:  ${applies} ;;
  }
  measure: sum_hires {
    type: sum
    sql:  ${hires} ;;
  }
  measure: sum_spend {
    type: sum
    sql:  ${spend} ;;
    value_format: "$#.00"
  }
  measure: cpc {
    type: number
    sql: ${spend}/${clicks} ;;
    value_format: "$#.00"
  }
  measure: cpa {
    type :  number
    sql: ${spend}/${applies} ;;
    value_format: "$#.00"
  }
  measure: cta {
    type: number
    sql: ${applies}*100/${clicks};;
    value_format: "#.00"
  }
}
