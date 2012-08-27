{
  "id": "pegasus",
  "defaults": {
    "instanceType": "m1.large",
    "ami": "ami-b0c638d9"
  },
  "roles": {
    "webfe": {
      "max": 1,
      "ports": [
        "www"
      ],
      "min": 1
    }
  }
}
