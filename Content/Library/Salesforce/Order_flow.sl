namespace: Salesforce
flow:
  name: Order_flow
  inputs:
    - username
    - password:
        sensitive: true
    - account_name
    - order_date
    - contract_number
    - description
  workflow:
    - Order:
        do:
          Salesforce.Order:
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - account_name: '${account_name}'
            - order_date: '${order_date}'
            - contract_number: '${contract_number}'
            - description: '${description}'
        publish:
          - order_number: '${order_number.split()[1]}'
          - return_result
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - WARNING: SUCCESS
          - FAILURE: on_failure
  outputs:
    - order_number
    - return_result
    - error_message
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      Order:
        x: 100
        'y': 150
        navigate:
          95dde648-ed7d-410d-ea53-6c5b9fcb4b89:
            targetId: bb1a8b48-5268-533d-ce59-0c9f04a8857f
            port: SUCCESS
          5522db53-5003-3722-f039-e17886d37fc1:
            targetId: bb1a8b48-5268-533d-ce59-0c9f04a8857f
            port: WARNING
    results:
      SUCCESS:
        bb1a8b48-5268-533d-ce59-0c9f04a8857f:
          x: 400
          'y': 150
