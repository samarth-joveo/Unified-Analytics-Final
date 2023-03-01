view: map_trial {
  derived_table: {
    sql: select 45 spend, 'New York' state
union
select 54 spend, 'California' state
union
select 32 spend, 'Oregon' state
union
select 47 spend, 'Utah' state
union
select 41 spend, 'Vermont' state ;;
  }
  dimension: state {
    map_layer_name: us_states
    sql: ${TABLE}.state ;;
  }
  measure: spend {
    type: sum
    sql: ${TABLE}.spend ;;
  }
   }
