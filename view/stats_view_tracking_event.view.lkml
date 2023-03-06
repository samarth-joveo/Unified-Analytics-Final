view: stats_view_tracking_event {
 derived_table: {
   sql: select agency_id,client_id,campaign_id,job_group_id,publisher_id,event_publisher_date,0 total_jobs_count,0 sponsored_jobs_count,job_city,job_state,job_country,
sum( case when (
        event_type = 'CLICK'
        and is_valid = true
      ) then event_count
      else 0
    end)  clicks,sum(case
      when (
        event_type = 'CONVERSION'
        and conversion_type = 'APPLY'
      ) then event_count
      else 0
    end) applies,sum(case
     when (
       event_type = 'CONVERSION'
       and conversion_type = 'HIRE'
     ) then event_count
     else 0
   end) hires,sum(case
    when is_valid = true then (event_spend * (1E0 / (1E0 - (publisher_entity_markdown / 100))) * (1E0 + (agency_markup / 100)) * (1E0 + (effective_cd_markup / 100)) * d_logic_ratio)
    else 0E0
  end) spend
from tracking.modelled.view_tracking_event
where (agency_id not like '%ripple%' and agency_id <> 'uberjax') and date(event_publisher_date) >=  date('2023-01-01')
and should_contribute_to_joveo_stats = TRUE
group by agency_id,client_id,campaign_id,job_group_id,publisher_id,event_publisher_date,job_city,job_state,job_country

union

select agency_id,client_id,campaign_id,job_group_id,null publisher_id,null event_publisher_date,total_jobs_count,sponsored_jobs_count, null clicks, null applies, null hires, null spend, null job_city, null job_state, null job_country from jobs.modelled.JOB_COUNT_AT_JOBGROUP_LEVEL_HOURLY
  ;;
 }
  dimension: job_city {
    type: string
    sql:  ${TABLE}.job_city ;;
  }
  dimension: job_state {
    type: string
    sql:  ${TABLE}.job_state ;;
  }
  dimension: job_country {
    type: string
    sql:  ${TABLE}.job_country ;;
  }
  dimension: agency_id {
    type: string
    sql:  ${TABLE}.agency_id ;;
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
    value_format: "$ #.00"
  }
  measure: cpc {
    type: number
    sql: iff(${sum_clicks}=0,0,${sum_spend}/${sum_clicks}) ;;
    value_format: "$ #.00"
  }
  measure: cpa {
    type :  number
    sql: iff(${sum_applies}=0,0,${sum_spend}/${sum_applies}) ;;
    value_format: "$ #.00"
  }
  measure: cta {
    type: number
    sql: iff(${sum_clicks}=0,0,${sum_applies}*100/${sum_clicks});;
    value_format: "#.00"
  }
  measure: total_job_count {
    type: sum
    sql: ${TABLE}.total_jobs_count ;;
  }
  measure: sponsored_job_count {
    type: sum
    sql: ${TABLE}.sponsored_jobs_count ;;
  }
}
