view: campaign_info {
  derived_table: {
    sql:select distinct id,name,budget_value,budget_cap_frequency from idp.modelled.campaign_management_campaigns ;;
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
  dimension: budget {
    type :  number
    sql: ${TABLE}.budget_value ;;
  }
  dimension: budget_freq {
    type :  string
    sql: ${TABLE}.budget_cap_frequency ;;
  }
}
