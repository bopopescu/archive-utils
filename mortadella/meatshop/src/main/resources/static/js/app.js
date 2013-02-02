var mekka = angular.module("mekka", ['ngResource']).config(function($interpolateProvider) {
    $interpolateProvider.startSymbol("[[").endSymbol("]]");
});

mekka.factory("Shop", function($resource) {
   return $resource("/shop/:shopId", { shopId: "@id" });
});

