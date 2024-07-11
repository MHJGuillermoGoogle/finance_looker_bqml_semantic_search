connection: "explore-assistant-bigquery-connection"

include: "/views/*.view.lkml"                # include all views in the views/ folder in this project

datagroup: explore_assistant_demo_default_datagroup {
  sql_trigger: SELECT DATE(2024,06,01) ;;
  max_cache_age: "32 hours"
}

persist_with: explore_assistant_demo_default_datagroup

explore: demo_exp_assist_sem_search {
  label : "Demo dummy data"
  # from: exp_assist_sem_search_demo
  join: profit_center_sem_search {
    type: left_outer
    relationship: one_to_one
    sql_on: ${demo_exp_assist_sem_search.profit_center} = ${profit_center_sem_search.matched_profit_center_code} ;;
  }

  join: gl_account_sem_search {
    type: left_outer
    relationship: one_to_one
    sql_on: ${demo_exp_assist_sem_search.gl_account} = ${gl_account_sem_search.matched_gl_account_code} ;;
  }

  join: cost_center_sem_search {
    type: left_outer
    relationship: one_to_one
    sql_on: ${demo_exp_assist_sem_search.cost_center} = ${cost_center_sem_search.matched_cost_center_code} ;;
  }
}

explore:  profit_center_sem_search {
  label: "Profit Center Semantic Search"
  join: profit_center_details {
    type: left_outer
    relationship: one_to_many
    sql_on: ${profit_center_details.profit_center_code} = ${profit_center_sem_search.matched_profit_center_code};;
  }
}
