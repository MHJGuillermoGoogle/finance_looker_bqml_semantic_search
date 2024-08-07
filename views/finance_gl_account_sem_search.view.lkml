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
    base.gl_account_description as gl_account_description
    FROM VECTOR_SEARCH(
      TABLE `finance-looker-424218.semantic_search.gl_account_finance_data_demo_embeddings`,'ml_generate_embedding_result',
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

  dimension: gl_account_description {
    description: "Cost center code"
    type: string
    sql: ${TABLE}.gl_account_description ;;
  }
}
