view: jg_info {
  derived_table: {
    sql:select distinct id,name from idp.modelled.campaign_management_jobgroups where agency_id ='uber' ;;
  }
  dimension: id {
    primary_key: yes
    type :  string
    sql: ${TABLE}.id ;;
  }
  dimension: name {
    type :  string
    sql: ${TABLE}.name ;;
  }
  measure: number_of_jgs{
    type: count_distinct
    sql: ${TABLE}.id ;;
  }
 }
