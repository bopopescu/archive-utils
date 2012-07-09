{
  "_rev": "11-537ab5deca16fe38ab6ec351d87cb42d",
  "id": "phoenix",
  "resources": {
    "prod": {
      "auctionProxy": [

      ],
      "resources": [

      ],
      "payment": [
        "10.83.122.203",
        "10.203.29.78"
      ],
      "argo": [
        "10.110.243.151",
        "10.77.101.161"
      ],
      "auctions": [
        "10.110.23.13",
        "10.96.163.119"
      ],
      "new-argo": [
        "10.32.57.117",
        "10.204.111.77",
        "10.202.6.224"
      ]
    }
  },
  "defaults": {
    "ami": "ami-2eb54a47"
  },
  "data_bag": "prod",
  "roles": {
    "auctionProxy": {
      "max": 2,
      "min": 4
    },
    "payment": {
      "max": 2,
      "min": 2
    },
    "auctions": {
      "max": 2,
      "min": 4
    },
    "argo": {
      "max": 5,
      "min": 3
    }
  },
  "chef_type": "data_bag_item"
}
