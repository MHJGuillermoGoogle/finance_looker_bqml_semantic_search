view: gl_account_sem_search {
  derived_table: {
    sql:
    -- This SQL statement performs the vector search --
    -- Step 1. Generate Embedding from natural language question --
    -- Step 2. Specify the text_embedding column from the embeddings table that was generated for each product in this example --
    -- Step 3. Use BQML's native Vector Search functionality to match the nearest embeddings --
    -- Step 4. Return the matche products --
    SELECT query.query,
    base.gl_account_code as matched_gl_account_code,
    base.gl_account_description as matched_gl_account_description
    FROM VECTOR_SEARCH(
      TABLE `finance-looker-424218.semantic_search.gl_account_embeddings`, 'text_embedding',
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

  dimension: matched_gl_account_code {
    type: string
    sql: ${TABLE}.matched_gl_account_code ;;
  }

  dimension: matched_gl_account_description {
    type: string
    sql: ${TABLE}.matched_gl_account_description ;;
  }
}
