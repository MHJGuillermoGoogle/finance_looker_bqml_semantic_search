connection: "explore-assistant-bigquery-connection"

include: "/views/*.view.lkml"                # include all views in the views/ folder in this project

# datagroup: explore_assistant_demo_default_datagroup {
#   sql_trigger: SELECT DATE(2024,06,01) ;;
#   max_cache_age: "32 hours"
# }

# persist_with: explore_assistant_demo_default_datagroup

explore: demo_exp_assist_sem_search {
  label : "Demo Explore Assistant with Semantic Search"
  join: finance_profit_center_sem_search {
    type: left_outer
    relationship: one_to_one
    sql_on: ${demo_exp_assist_sem_search.profit_center_code} = ${finance_profit_center_sem_search.profit_center_code} ;;
  }

  join: finance_gl_account_sem_search {
    type: left_outer
    relationship: one_to_one
    sql_on: ${demo_exp_assist_sem_search.gl_account_code} = ${finance_gl_account_sem_search.gl_account_code} ;;
  }

  join: finance_cost_center_sem_search {
    type: left_outer
    relationship: one_to_one
    sql_on: ${demo_exp_assist_sem_search.cost_center_code} = ${finance_cost_center_sem_search.cost_center_code} ;;
  }
}

explore:  finance_profit_center_sem_search {
  label: "Finance PC Semantic Search"
  view_name: finance_profit_center_sem_search
}

explore: finance_cost_center_sem_search {
  label: "Finance CC Semantic Search"
  view_name: finance_cost_center_sem_search
}

explore:  finance_gl_account_sem_search {
  label: "Finance GL Account Semantic Search"
  view_name: finance_gl_account_sem_search
}

explore:  profit_center_sem_search {
  label: "PC Semantic Search"
  view_name: profit_center_sem_search
}

explore: cost_center_sem_search {
  label: "CC Semantic Search"
  view_name: cost_center_sem_search
}

explore:  gl_account_sem_search {
  label: "GL Account Semantic Search"
  view_name: gl_account_sem_search
}
