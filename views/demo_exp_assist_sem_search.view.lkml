view: demo_exp_assist_sem_search {
  # sql_table_name: explore_assistant.demo_finance_data ;;
  sql_table_name: explore_assistant.finance_data_demo ;;

  dimension: cost_center_code {
    description: "Cost center code"
    type: string
    sql: ${TABLE}.cost_center ;;
  }

  dimension: company_code {
    description: "Company code"
    type: number
    sql: ${TABLE}.company_code ;;
  }

  dimension: gl_account_code {
    description: "GL account code"
    type: string
    sql: ${TABLE}.gl_account ;;
  }

  dimension: scenario {
    description: "scenario"
    type: string
    sql: ${TABLE}.scenario ;;
  }

  dimension: profit_center_code {
    description: "Profit center code"
    type: string
    sql: ${TABLE}.profit_center ;;
  }

  dimension: fiscal_year {
    description: "Fiscal year period in a format of YYYY"
    type: number
    sql: ${TABLE}.fiscal_year;;
  }

  # dimension_group: fiscal_date {
  #   type: time
  #   timeframes: [raw,time,date,week,month,quarter,year]
  #   sql: PARSE_DATE("%Y%m", CONCAT(CAST(${fiscal_year} AS STRING),CAST(${fiscal_month} AS STRING))) ;;
  # }

  dimension: fiscal_month {
    description: "Fiscal year period in a format of MM"
    type: number
    sql: ${TABLE}.fiscal_month;;
  }

  dimension: amount {
    description: "Amount"
    type: number
    sql: ${TABLE}.amount ;;
  }

  # dimension: headcount {
  #   description: "Amount"
  #   type: number
  #   sql: ${TABLE}.headcount ;;
  # }

  dimension: quarter_period {
    description: "Number of quarter of the year"
    type: tier
    tiers: [4,7,10]
    sql: ${fiscal_month} ;;
    style: integer
  }

  dimension: matched_gl_account {
    type: yesno
    sql: ${gl_account_code} IN (
      SELECT gl_account_code
      FROM ${finance_gl_account_sem_search.SQL_TABLE_NAME}
    );;
  }

  dimension: matched_cost_center {
    type: yesno
    sql: ${cost_center_code} IN (
      SELECT cost_center_code
      FROM ${finance_cost_center_sem_search.SQL_TABLE_NAME}
    );;
  }

  dimension: matched_profit_center {
    type: yesno
    sql: ${profit_center_code} IN (
      SELECT profit_center_code
      FROM ${finance_profit_center_sem_search.SQL_TABLE_NAME}
    );;
  }

  measure: total_amount {
    description: "Use this for total amount"
    type: sum
    sql: ${amount} ;;
  }

  measure: matched_gl_account_total_amount {
    type: sum
    value_format_name: usd
    filters: [matched_gl_account: "yes"]
    sql: ${amount} ;;
  }

  measure: matched_cost_center_total_amount {
    type: sum
    value_format_name: usd
    filters: [matched_cost_center: "yes"]
    sql: ${amount} ;;
  }

  measure: matched_profit_center_total_amount {
    type: sum
    value_format_name: usd
    filters: [matched_profit_center: "yes"]
    sql: ${amount} ;;
  }

  measure: actual_total_amount {
    description: "Total amount of actuals"
    type: sum
    sql: ${amount} ;;
    filters: [demo_exp_assist_sem_search.scenario: "ACTUAL"]
  }

  measure: percent_actual_total_amount {
    type: number
    value_format_name: percent_2
    sql: 1.0*${actual_total_amount}/NULLIF(${total_amount},0) ;;
  }

  measure: forecast_total_amount {
    description: "Total amount of actuals"
    type: sum
    sql: ${amount} ;;
    filters: [demo_exp_assist_sem_search.scenario: "WIP_FCST"]
  }

  measure: percent_forecast_total_amount {
    type: number
    value_format_name: percent_2
    sql: 1.0*${forecast_total_amount}/NULLIF(${total_amount},0) ;;
  }

  measure: aop_total_amount {
    description: "Total amount of actuals"
    type: sum
    sql: ${amount} ;;
    filters: [demo_exp_assist_sem_search.scenario: "WIP_AOP"]
  }

  measure: percent_aop_total_amount {
    type: number
    value_format_name: percent_2
    sql: 1.0*${aop_total_amount}/NULLIF(${total_amount},0) ;;
  }

  measure: count {
    description: "Use this for count rows"
    type: count
  }

  measure: matched_gl_account_count {
    type: count
    filters: [matched_gl_account: "yes"]
  }

  measure: matched_cost_center_count {
    type: count
    filters: [matched_cost_center: "yes"]
  }

  measure: matched_profit_center_count {
    type: count
    filters: [matched_profit_center: "yes"]
  }

  measure: number_of_unique_cost_center {
    description: "Count the distinct cost center values"
    type: count_distinct
    sql: ${cost_center_code} ;;
  }

  measure: number_of_unique_gl_account {
    description: "Count the distinct GL Accounts"
    type: count_distinct
    sql: ${gl_account_code} ;;
  }

  measure: number_of_unique_profit_center {
    description: "Count the distinct Profit Center"
    type: count_distinct
    sql: ${profit_center_code} ;;
  }

  measure: average_amount {
    description: "Use this for total amount"
    type: average
    sql: ${amount} ;;
  }
}
