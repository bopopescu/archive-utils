{
  "id": "ptzplace",
  "resources": {
    "uat": {
      "auth": [
        "10.112.209.22"
      ],
      "sql": [
        "10.202.210.176"
      ],
      "memc": [
        "10.202.210.176"
      ],
      "reverseproxy": [
        "10.202.210.176"
      ],
      "webfe": [
        "10.202.210.176"
      ]
    }
  },
  "defaults": {
    "instanceType": "m1.large",
    "ports": [
      "www",
      "memc-internal",
      "sql-internal"
    ],
    "ami": "ami-b0c638d9"
  },
  "roles": {
    "memc": {
      "max": 1,
      "min": 1
    },
    "sql": {
      "max": 1,
      "min": 1
    },
    "reverseproxy": {
      "max": 1,
      "min": 1
    },
    "webfe": {
      "max": 1,
      "min": 1
    }
  }
}
