view: demo_exp_assist_sem_search {
  sql_table_name: explore_assistant.finance_data_demo ;;

  dimension: cost_center {
    description: "Cost center code"
    type: string
    sql: ${TABLE}.cost_center ;;
  }

  dimension: company_code {
    description: "Company code"
    type: number
    sql: ${TABLE}.company_code ;;
  }

  dimension: gl_account {
    description: "GL account code"
    type: string
    sql: ${TABLE}.gl_account ;;
  }

  dimension: scenario {
    description: "scenario"
    type: string
    sql: ${TABLE}.scenario ;;
  }

  dimension: profit_center {
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

  dimension: headcount {
    description: "Amount"
    type: number
    sql: ${TABLE}.headcount ;;
  }

  dimension: quarter_period {
    description: "Number of quarter of the year"
    type: tier
    tiers: [4,7,10]
    sql: ${fiscal_month} ;;
    style: integer
  }

  measure: total_amount {
    description: "Use this for total amount"
    type: sum
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

  measure: number_of_unique_cost_center {
    description: "Count the distinct cost center values"
    type: count_distinct
    sql: ${cost_center} ;;
  }

  measure: count_gl_account {
    description: "Use this for total amount"
    type: count_distinct
    sql: ${gl_account} ;;
  }


  measure: average_amount {
    description: "Use this for total amount"
    type: average
    sql: ${amount} ;;
  }
}
