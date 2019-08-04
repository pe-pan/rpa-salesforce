namespace: Salesforce.sub_flows
flow:
  name: create_order
  inputs:
    - username
    - password
    - lines
  workflow:
    - get_order:
        do:
          Salesforce.sub_flows.get_order:
            - lines: '${lines}'
        publish:
          - id
          - account_name
          - contract_number
          - start_date
          - amount
          - next_lines
        navigate:
          - SUCCESS: Order_flow
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${next_lines}'
            - second_string: ''
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: MORE_LINES
    - Order_flow:
        do:
          Salesforce.Order_flow:
            - username: '${username}'
            - password: '${password}'
            - account_name: '${account_name}'
            - contract_number: '${contract_number}'
            - order_date: '${start_date}'
            - description: '${"order id "+id+" with amount "+amount}'
        publish:
          - order_number
        navigate:
          - SUCCESS: string_equals
          - FAILURE: on_failure
  outputs:
    - id: '${id}'
    - account_name: '${account_name}'
    - contract_number: '${contract_number}'
    - start_date: '${start_date}'
    - amount: '${amount}'
    - next_lines: '${next_lines}'
  results:
    - MORE_LINES
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_order:
        x: 165
        'y': 155
      string_equals:
        x: 550
        'y': 121
        navigate:
          4de20366-5059-3269-692c-458523250082:
            targetId: b56d47b6-89a6-6986-df19-a47883175b27
            port: SUCCESS
          2a7bcb55-5946-6278-9f0d-6b15bb501bed:
            targetId: 296cec9b-9e88-8c8f-463c-56cf2d5d90f9
            port: FAILURE
      Order_flow:
        x: 322
        'y': 160
    results:
      MORE_LINES:
        296cec9b-9e88-8c8f-463c-56cf2d5d90f9:
          x: 637
          'y': 144
      SUCCESS:
        b56d47b6-89a6-6986-df19-a47883175b27:
          x: 409
          'y': 349
