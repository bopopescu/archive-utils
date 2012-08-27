{
  "_rev": "7-5267bd597975666e93a1fd5f71cafa16",
  "id": "phoenix",
  "resources": {
    "uat": {
      "auctionProxy": [

      ],
      "resources": [

      ],
      "argo": [
        "10.32.25.228"
      ],
      "auctions": [

      ]
    }
  },
  "defaults": {
    "ami": "ami-2eb54a47"
  },
  "data_bag": "uat",
  "roles": {
    "auctionProxy": {
      "max": 2,
      "min": 4
    },
    "payment": {
      "max": 2,
      "min": 2
    },
    "argo": {
      "max": 1,
      "min": 1
    },
    "auctions": {
      "max": 2,
      "min": 4
    }
  },
  "chef_type": "data_bag_item"
}
