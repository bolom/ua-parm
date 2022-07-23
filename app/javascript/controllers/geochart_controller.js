import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'geochart' ]

  connect() {
    console.log(this.hasGeochartTarget)

    if(this.hasGeochartTarget) {
      google.charts.load('current', {
        'packages':['geochart'],
        'mapsApiKey': '[AIzaSyAEois78Qx_qZnYLerIRJqFPKI3Id5xR8U]'
      });

      var geoTarget = this.geochartTarget
      var introduced = geoTarget.dataset.introduced.split(',');
      var natives = geoTarget.dataset.natives.split(',');

      google.charts.setOnLoadCallback( function () {
        console.log("setOnLoadCallback")
        var d=[];
        var Header= ['Country', 'Native'];
        d.push(Header);
        for (var i = 0; i < introduced.length; i++) {
           var temp=[];
           temp.push(introduced[i]);
           temp.push(1);
           d.push(temp);
       }

       for (var i = 0; i < natives.length; i++) {
          var temp=[];
          temp.push(natives[i]);
          temp.push(0);
          d.push(temp);
      }

        var data = google.visualization.arrayToDataTable(d);
          var options = {
              colorAxis:{
                      colors:['green','purple'],
                      minValue: 0,
                      maxValue:1 },
               legend:'none',
               tooltip: {trigger: 'none'}
            };

            console.log("draw chart");

          var chart = new google.visualization.GeoChart(geoTarget);
          console.log(chart);
          chart.draw(data, options);
      } );
    }
  }
}
/*
    function drawChart(geochart){
      var data = google.visualization.arrayToDataTable([
          ['Country', 'Native'],
          ['FR',1],
          ['RU',0]
        ]);

          var options = {
            colorAxis:{
                    colors:['green','purple'],
                    minValue: 0,
                    maxValue:1 },
             legend:'none',
             tooltip: {trigger: 'none'}
          };


        var chart = new google.visualization.GeoChart(geoTarget);
    }*/
