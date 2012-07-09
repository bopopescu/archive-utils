{
  "_rev": "19-17d2e741c668a4636b66609da6dfca00",
  "id": "site",
  "resources": {
    "uat": {
      "reverseproxy": [
        "10.68.34.132"
      ],
      "memc": [

      ],
      "webfe": [
        "10.255.107.15"
      ]
    }
  },
  "defaults": {
    "instanceType": "m1.large",
    "ami": "ami-2eb54a47"
  },
  "data_bag": "uat",
  "static_fail_over": false,
  "active_cell": "webfe",
  "roles": {
    "memc": {
      "max": 1,
      "ports": [
        "memc-internal"
      ],
      "min": 1
    },
    "reverseproxy": {
      "max": 1,
      "ports": [
        "www"
      ],
      "min": 1
    },
    "webfe": {
      "max": 1,
      "ports": [
        "www"
      ],
      "min": 1
    }
  },
  "chef_type": "data_bag_item"
}
