connection: "idp"

include: "/view/*.view.lkml"

datagroup: samarth_testing_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: samarth_testing_default_datagroup
label: "Unified Analytics"

explore: stats_view_tracking_event {
  join : client_info  {
    type: left_outer
    sql_on: ${client_info.id} = ${stats_view_tracking_event.client_id} ;;
    relationship: many_to_one
  }
  join: campaign_info {
    type: left_outer
    sql_on: ${campaign_info.id} = ${stats_view_tracking_event.campaign_id} ;;
    relationship: many_to_one
  }
  join: jg_info {
    type: left_outer
    sql_on: ${jg_info.id} = ${stats_view_tracking_event.job_group_id}  ;;
    relationship: many_to_one
  }

}
explore: count {
  join : client_info  {
    type: left_outer
    sql_on: ${client_info.id} = ${count.client_id} ;;
    relationship: many_to_one
  }
  join: campaign_info {
    type: left_outer
    sql_on: ${campaign_info.id} = ${count.campaign_id} ;;
    relationship: many_to_one
  }
  join: jg_info {
    type: left_outer
    sql_on: ${jg_info.id} = ${count.job_group_id}  ;;
    relationship: many_to_one
  }
}
explore: stats_view_tracking_event_trend {

}
