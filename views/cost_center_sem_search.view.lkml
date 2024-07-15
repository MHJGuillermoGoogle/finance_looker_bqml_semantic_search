view: cost_center_sem_search {
  derived_table: {
    sql:
    -- This SQL statement performs the vector search --
    -- Step 1. Generate Embedding from natural language question --
    -- Step 2. Specify the text_embedding column from the embeddings table that was generated for each product in this example --
    -- Step 3. Use BQML's native Vector Search functionality to match the nearest embeddings --
    -- Step 4. Return the matche products --
    SELECT query.query,
    base.cost_center_code as matched_cost_center_code,
    base.cost_center_description as matched_cost_center_description
    FROM VECTOR_SEARCH(
      TABLE `finance-looker-424218.semantic_search.LR_FZT5J1720642974264_cost_center_embeddings`, 'text_embedding',
      (
        SELECT ml_generate_embedding_result, content AS query
        FROM ML.GENERATE_EMBEDDING(
          MODEL `@{BQML_EMBEDDINGS_MODEL_ID}`,
          (SELECT {% parameter cost_center_search %} AS content)
        )
      ),
      top_k => {% parameter cost_center_matches %}
      ,options => '{"fraction_lists_to_search": 0.5}'
    ) ;;
  }

  parameter: cost_center_search {
    type: string
  }

  parameter: cost_center_matches {
    type: number
  }

  dimension: cost_center_search_chosen {
    type: string
    sql: {% parameter cost_center_search %} ;;
  }

  dimension: cost_center_matches_chosen {
    type: string
    sql: {% parameter cost_center_matches %} ;;
  }

  dimension: matched_cost_center_code {
    type: string
    sql: ${TABLE}.matched_cost_center_code ;;
  }

  dimension: matched_cost_center_description {
    type: string
    sql: ${TABLE}.matched_cost_center_description ;;
  }
}
