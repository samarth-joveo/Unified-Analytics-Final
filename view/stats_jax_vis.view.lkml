view: stats_jax_vis {
derived_table: {
  sql: select agency_id,client_id,campaign_id,job_group_id,publisher_id,event_publisher_date,'Hide Jax' jax_vis,
sum( case when (
        event_type = 'CLICK'
        and is_valid = true
      ) then event_count
      else 0
    end) clicks
from tracking.modelled.view_tracking_event
where client_id = '18457b0e-361a-4ad5-88e3-9be503cfcc2b'
and date(event_publisher_date) >=  date('2023-01-01')
and date(event_publisher_date) <  date('2023-02-01')
and should_contribute_to_joveo_stats = TRUE
group by agency_id,client_id,campaign_id,job_group_id,publisher_id,event_publisher_date
union
select agency_id,client_id,campaign_id,job_group_id,coalesce(dbg_original_publisher,publisher_id) publisher_id,event_publisher_date,'Jax Visibility' jax_vis,
sum( case when (
        event_type = 'CLICK'
        and is_valid = true
      ) then event_count
      else 0
    end) clicks
from tracking.modelled.view_tracking_event
where client_id = '18457b0e-361a-4ad5-88e3-9be503cfcc2b'
and date(event_publisher_date) >=  date('2023-01-01')
and date(event_publisher_date) <  date('2023-02-01')
and should_contribute_to_joveo_stats = TRUE
group by agency_id,client_id,campaign_id,job_group_id,coalesce(dbg_original_publisher,publisher_id),event_publisher_date ;;
}
dimension: publisher_id {
  type: string
  sql: ${TABLE}.publisher_id ;;
}
  dimension: clicks {
    type: number
    sql: ${TABLE}.clicks ;;
  }
  dimension: jax_vis {
    type: string
    sql: ${TABLE}.jax_vis ;;
  }
  measure: sum_clicks {
    type: sum
    sql: ${clicks} ;;
  }
 }
