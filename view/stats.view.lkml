view: stats {
derived_table: {sql: select agency_id,client_id,campaign_id,job_group_id,event_publisher_date,coalesce(dbg_original_publisher,publisher_id) jax_vis,publisher_id jax_hide,
sum( case when (
        event_type = 'CLICK'
        and is_valid = true
      ) then event_count
      else 0
    end) clicks
from tracking.modelled.view_tracking_event
where (agency_id not like '%ripple%' and agency_id <> 'uberjax')
and date(event_publisher_date) >=  date('2023-01-01')
and date(event_publisher_date) <  date('2023-02-01')
and should_contribute_to_joveo_stats = TRUE
group by agency_id,client_id,campaign_id,job_group_id,coalesce(dbg_original_publisher,publisher_id),publisher_id,event_publisher_date;; }
  dimension: agency_id {
    type: string
    sql: ${TABLE}.agency_id ;;
  }
  dimension: client_id {
    type: string
    sql: ${TABLE}.client_id ;;
  }
  dimension: campaign_id {
    type: string
    sql: ${TABLE}.campaign_id ;;
  }
  dimension: job_group_id {
    type: string
    sql: ${TABLE}.job_group_id ;;
  }
dimension: jax_vis {
  type: string
  sql: ${TABLE}.jax_vis ;;
}
dimension: jax_hide {
  type: string
  sql: ${TABLE}.jax_hide ;;
}
measure: clicks {
  type: sum
  sql: ${TABLE}.clicks ;;
}
parameter: jax_or_not {
  type: unquoted
  allowed_value: {
    label: "Jax Visibility"
    value: "show"
  }
  allowed_value: {
    label: "Hide Jax"
    value: "hide"
  }
  }
  dimension: select_col {
    sql:{% if jax_or_not._parameter_value == 'show' %}
      ${jax_vis}
    {% else %}
      ${jax_hide}
    {% endif %};;
  }
  dimension: filters_are_applied_or_not {
    sql: {% if job_group_id.is_filtered %}
    ${TABLE}.job_group_id
    {% elsif campaign_id.is_filtered %}
    ${TABLE}.campaign_id
    {% elsif client_id.is_filtered %}
    ${TABLE}.client_id
    {% elsif agency_id.is_filtered %}
    ${TABLE}.agency_id
    {% endif %};;
  }
 }
