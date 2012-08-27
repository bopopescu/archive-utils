{
  "_rev": "58-c1f4da0435fd186395fcd82365794ad1",
  "resources": {
    "prod": {
      "auth": [
        "10.85.150.24",
        "10.98.71.150"
      ],
      "utilz": [
        "10.46.161.31",
        "10.70.17.171"
      ],
      "splunk": [
        "10.32.253.81",
        "10.72.102.220"
      ],
      "serenity": [
        "10.110.61.102"
      ],
      "buddy": [
        "10.220.126.16"
      ],
      "javadev": [
        "10.209.135.112"
      ],
      "srijith": [
        "10.46.154.115",
        "10.46.165.121",
        "10.82.127.95",
        "10.117.23.157"
      ],
      "paul": [
        "10.86.183.188"
      ]
    }
  },
  "id": "opz",
  "defaults": {
    "instanceType": "m1.large",
    "ami": "ami-b0c638d9"
  },
  "data_bag": "prod",
  "roles": {
    "auth": {
      "max": 2,
      "min": 2
    },
    "utilz": {
      "max": 3,
      "min": 1
    },
    "splunk": {
      "max": 2,
      "min": 1
    },
    "serenity": {
      "max": 2,
      "ports": [
        "www"
      ],
      "min": 1
    },
    "javadev": {
      "max": 2,
      "ports": [
        "www",
        "javadev"
      ],
      "min": 1
    },
    "buddy": {
      "max": 2,
      "min": 1
    },
    "srijith": {
      "max": 4,
      "min": 2
    },
    "paul": {
      "max": 2,
      "min": 1
    }
  },
  "chef_type": "data_bag_item"
}
