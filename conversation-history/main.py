from conversation_history import parse

log_entry = """\
id: "daab9b9f-c3f2-4910-820f-a38dddbc8fac-9aa0e9ed"
lang: "en"
session_id: "b05cf487-77b2-42e2-abe2-e7ef03f02e73"
timestamp: "2020-04-01t22:44:37.445z"
result {
  source: "agent"
  resolved_query: "do i have it\\\\"
  score: 0.9
  parameters {
  }
  metadata {
    intent_id: "d24ac022-9278-4038-824a-cece99f45bf2"
    intent_name: "faq - symptoms"
    webhook_used: "false"
    webhook_for_slot_filling_used: "false"
    is_fallback_intent: "false"
  }
  fulfillment {
    speech: "patients may have fever, cough, runny nose, shortness of breath and other symptoms. in more severe cases, infection can cause pneumonia with severe acute respiratory distress."
    messages {
      lang: "en"
      type {
        number_value: 0.0
      }
      speech {
        string_value: "patients may have fever, cough, runny nose, shortness of breath and other symptoms. in more severe cases, infection can cause pneumonia with severe acute respiratory distress."
      }
    }
  }
}
status {
  code: 200
  error_type: "success"
}
"""

if __name__ == '__main__':
    print(parse(log_entry))
