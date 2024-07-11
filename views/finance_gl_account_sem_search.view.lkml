view: finance_gl_account_sem_search {

  derived_table: {
    sql:
    -- This SQL statement performs the vector search --
    -- Step 1. Generate Embedding from natural language question --
    -- Step 2. Specify the text_embedding column from the embeddings table that was generated for each product in this example --
    -- Step 3. Use BQML's native Vector Search functionality to match the nearest embeddings --
    -- Step 4. Return the matche products --
    SELECT query.query,
    base.gl_account_code as gl_account_code,
    base.gl_account_description as gl_account_description,
    base.profit_center_code,
    base.profit_center_description,
    base.cost_center_code,
    base.cost_center_description,
    base.amount,
    base.company_code,
    base.scenario,
    base.fiscal_year,
    base.fiscal_month
    FROM VECTOR_SEARCH(
      TABLE `finance-looker-424218.semantic_search.finance_data_sem_search_demo`, 'gl_account_text_embedding',
      (
        SELECT ml_generate_embedding_result, content AS query
        FROM ML.GENERATE_EMBEDDING(
          MODEL `@{BQML_EMBEDDINGS_MODEL_ID}`,
          (SELECT {% parameter gl_account_search %} AS content)
        )
      ),
      top_k => {% parameter gl_account_matches %}
      ,options => '{"fraction_lists_to_search": 0.5}'
    ) ;;
  }

  parameter: gl_account_search {
    type: string
  }

  parameter: gl_account_matches {
    type: number
  }

  dimension: gl_account_search_chosen {
    type: string
    sql: {% parameter gl_account_search %} ;;
  }

  dimension: gl_account_matches_chosen {
    type: string
    sql: {% parameter gl_account_matches %} ;;
  }


  dimension: gl_account_code {
    description: "Cost center code"
    type: string
    sql: ${TABLE}.gl_account_code ;;
  }

  dimension: profit_center_code {
    description: "Profit center code"
    type: string
    sql: ${TABLE}.profit_center_code ;;
  }

  dimension: cost_center_code {
    description: "Cost center code"
    type: string
    sql: ${TABLE}.cost_center_code ;;
  }

  dimension: company_code {
    description: "Company code"
    type: number
    sql: ${TABLE}.company_code ;;
  }

  dimension: scenario {
    description: "scenario"
    type: string
    sql: ${TABLE}.scenario ;;
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

  measure: total_amount {
    description: "Use this for total amount"
    type: sum
    sql: ${amount} ;;
  }

  measure: actual_total_amount {
    description: "Total amount of actuals"
    type: sum
    sql: ${amount} ;;
    filters: [scenario: "ACTUAL"]
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
    filters: [scenario: "WIP_FCST"]
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
    filters: [scenario: "WIP_AOP"]
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
