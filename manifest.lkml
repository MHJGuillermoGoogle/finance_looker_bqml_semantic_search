project_name: "explore_assistant_semantic_search"

# This is the ID of the BQML MODEL setup with the remote connect
constant: BQML_REMOTE_CONNECTION_MODEL_ID {
  value: "finance-looker-424218.semantic_search.semantic-search-llm"
}

# This is the ID of the remote connection setup in BigQuery
constant: BQML_REMOTE_CONNECTION_ID {
  value: "finance-looker-424218.us-central1.semantic-search-vertex-ai"
}

# This is the name of the Looker BigQuery Database connection
constant: LOOKER_BIGQUERY_CONNECTION_NAME {
  value: "explore-assistant-bigquery-connection"
}

constant: BQML_EMBEDDINGS_MODEL_ID {
  value: "finance-looker-424218.semantic_search.embeddings_model"
}

# application: finance_exp_assist_sem_search {
#   label: "Demo Exp Assist Sem Search"
#   file: "bundle.js"
#   entitlements: {
#     core_api_methods: ["lookml_model_explore","create_sql_query","run_sql_query","run_query","create_query"]
#     navigation: yes
#     use_embeds: yes
#     use_iframes: yes
#     new_window: yes
#     new_window_external_urls: ["https://developers.generativeai.google/*"]
#     local_storage: yes
#   }
# }
