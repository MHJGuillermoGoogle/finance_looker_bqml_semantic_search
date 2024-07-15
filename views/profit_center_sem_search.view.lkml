view: profit_center_sem_search {
  derived_table: {
    sql:
    -- This SQL statement performs the vector search --
    -- Step 1. Generate Embedding from natural language question --
    -- Step 2. Specify the text_embedding column from the embeddings table that was generated for each product in this example --
    -- Step 3. Use BQML's native Vector Search functionality to match the nearest embeddings --
    -- Step 4. Return the matche products --
    SELECT query.query,
    base.profit_center_code as matched_profit_center_code,
    base.profit_center_description as matched_profit_center_description
    FROM VECTOR_SEARCH(
      TABLE `finance-looker-424218.semantic_search.LR_FZAY71719878195398_profit_center_embeddings`, 'text_embedding',
      (
        SELECT ml_generate_embedding_result, content AS query
        FROM ML.GENERATE_EMBEDDING(
          MODEL `@{BQML_EMBEDDINGS_MODEL_ID}`,
          (SELECT {% parameter profit_center_search %} AS content)
        )
      ),
      top_k => {% parameter profit_center_matches %}
      ,options => '{"fraction_lists_to_search": 0.5}'
    ) ;;
  }

  parameter: profit_center_search {
    type: string
  }

  parameter: profit_center_matches {
    type: number
  }

  dimension: profit_center_search_chosen {
    type: string
    sql: {% parameter profit_center_search %} ;;
  }

  dimension: profit_center_matches_chosen {
    type: string
    sql: {% parameter profit_center_matches %} ;;
  }

  dimension: matched_profit_center_code {
    type: string
    sql: ${TABLE}.matched_profit_center_code ;;
  }

  dimension: matched_profit_center_description {
    type: string
    sql: ${TABLE}.matched_profit_center_description ;;
  }
}
