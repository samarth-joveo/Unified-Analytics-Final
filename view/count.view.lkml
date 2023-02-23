view: count {
  derived_table: {
    sql:select agency_id,client_id,campaign_id,job_group_id,total_jobs_count,sponsored_jobs_count from jobs.modelled.JOB_COUNT_AT_JOBGROUP_LEVEL_HOURLY ;;
  }
  dimension: agency_id {
    type :  string
    sql: ${TABLE}.agency_id ;;
  }
  dimension: client_id {
    type :  string
    sql: ${TABLE}.client_id ;;
  }
  dimension: campaign_id {
    type :  string
    sql: ${TABLE}.campaign_id ;;
  }
  dimension: job_group_id {
    type :  string
    sql: ${TABLE}.job_group_id ;;
  }
  dimension: total_jobs_count {
    type :  number
    sql: ${TABLE}.total_jobs_count ;;
  }
  dimension: sponsored_jobs_count {
    type :  number
    sql: ${TABLE}.sponsored_jobs_count ;;
  }
  measure: spon_jb_cnt {
    type: sum
    sql: ${sponsored_jobs_count} ;;
  }
  measure: total_jb_cnt {
    type: sum
    sql: ${total_jobs_count} ;;
  }
}
