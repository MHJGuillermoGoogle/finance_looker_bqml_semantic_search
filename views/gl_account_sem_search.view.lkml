view: gl_account_embeddings {
  derived_table: {
    datagroup_trigger: explore_assistant_demo_default_datagroup
    publish_as_db_view: yes
    sql_create:
    -- This SQL statement creates embeddings for all the rows in the given table (in this case the profit center details table) --
    CREATE OR REPLACE TABLE ${SQL_TABLE_NAME} AS
    SELECT ml_generate_embedding_result as text_embedding
      , * FROM ML.GENERATE_EMBEDDING(
      MODEL `@{BQML_EMBEDDINGS_MODEL_ID}`,
      (
        SELECT *, gl_account_description as content
        FROM ${gl_account_details.SQL_TABLE_NAME}
      )
    )
    WHERE LENGTH(ml_generate_embedding_status) = 0; ;;
  }
}

view: gl_account_embeddings_index {
  derived_table: {
    datagroup_trigger: explore_assistant_demo_default_datagroup
    sql_create:
    -- This SQL statement indexes the embeddings for fast lookup. We specify COSINE similarity here --
      CREATE OR REPLACE VECTOR INDEX ${SQL_TABLE_NAME}
      ON ${gl_account_embeddings.SQL_TABLE_NAME}(text_embedding)
      OPTIONS(index_type = 'IVF',
        distance_type = 'COSINE',
        ivf_options = '{"num_lists":500}') ;;
  }
}

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
      TABLE ${gl_account_embeddings.SQL_TABLE_NAME}, 'text_embedding',
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
