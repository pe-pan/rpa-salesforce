namespace: Salesforce.sub_flows
flow:
  name: create_multiple_orders
  inputs:
    - lines
    - username
    - password
  workflow:
    - parse_header:
        do:
          Salesforce.sub_flows.get_order:
            - lines: '${lines}'
        publish:
          - next_lines
        navigate:
          - SUCCESS: create_order
    - create_order:
        loop:
          for: 'i in range(0,10)'
          do:
            Salesforce.sub_flows.create_order:
              - username: '${username}'
              - password: '${password}'
              - lines: '${next_lines}'
          break:
            - SUCCESS
            - FAILURE
          publish:
            - next_lines
            - id
            - account_name
            - contract_number
            - start_date
            - amount
        navigate:
          - MORE_LINES: FAILURE
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      parse_header:
        x: 176
        'y': 116
      create_order:
        x: 462
        'y': 112
        navigate:
          2652a0f5-62bd-3647-26ae-e82de7fb9ba1:
            targetId: 2de3d545-5bf4-23c0-a17c-1a3473b2ce26
            port: SUCCESS
          c0dfb0a4-1862-ec6b-7ac8-05b673e30f18:
            targetId: 56bdcaef-325e-0ac6-5352-abd80103d8b8
            port: MORE_LINES
          13cff0fb-a13e-4896-1bed-9b949105c32c:
            targetId: 56bdcaef-325e-0ac6-5352-abd80103d8b8
            port: FAILURE
    results:
      SUCCESS:
        2de3d545-5bf4-23c0-a17c-1a3473b2ce26:
          x: 649
          'y': 97
      FAILURE:
        56bdcaef-325e-0ac6-5352-abd80103d8b8:
          x: 543
          'y': 323
