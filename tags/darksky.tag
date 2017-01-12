<darksky>
    <section id="darkSkyContainer" class="default-background">
        <div class="content">
            <h1 class="sub-header">Today's weather</h1>
            <div class="forecast-location">
                <a id="myLocation" class="icon-location my-location">
                    <span id="urlText" class="visuallyhidden">Link to my location</span>
                </a>
                <div class="current-temp" id="currentTemp">Getting your forecast ...</div>
            </div>
            <div class="current-time" id="currentTime"></div>

            <div class="forecast-wrapper" id="forecast"></div>
        </div>
    </section>

    <style type="scss" scoped>
        $image-dir: 'assets/images/';

        :scope {
            display: block;
            height: 100vh;
        }

        h1 {
            margin-top: 0;
        }

        .content {
            padding: 1rem;
            background-color: rgba(0, 0, 0, 0.3);
            height: 100%;

            .partly-cloudy-day &,
            .clear-night &,
            .clear-day &,
            .rain &,
            .snow &,
            .sleet &,
            .wind &,
            .fog &,
            .cloudy &,
            .partly-cloudy-night & {
                height: auto;
            }
        }

        .current-time {
            margin-bottom: 2rem;
            font-size: .8rem;
        }

        .sub-header {
            margin-bottom: 0;
        }

        .day-of-week {
            padding-right: 1rem;
        }

        .forecast-container {
            margin-bottom: 1rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.5);

            &:last-of-type {
                border-bottom: 0;
                padding-bottom: 3rem;
            }
        }

        .forecast-summary {
            margin-bottom: 0;
            font-size: .8rem;
        }

        .default-background {
            overflow: scroll;
            -webkit-overflow-scrolling: touch;
            background-image: url(#{$image-dir}default.jpg);
            background-position: center center;
            background-size: cover;
            height: 100vh;
            transition: all 2s ease;
        }

        .forecast-location {
            display: flex;
        }

        .my-location {
            font-size: .9rem;

            &:before {
                padding: 0 .3rem 0 0;
                line-height: 1.5rem;
            };
        }

        $weather-backgrounds: partly-cloudy-day, clear-night, clear-day, rain, snow, sleet, wind, fog, cloudy, partly-cloudy-night;

        @each $background in $weather-backgrounds {
            .#{$background} {
                background-image: url(#{$image-dir}#{$background}.jpg);
            }
        }
    </style>

    <script>
        function getDisplayWeatherData() {
            "use strict";

            // initiate Geolocation to dynamically find users location
            function initGeolocation() {
                if( navigator.geolocation ) {
                    // Call getCurrentPosition with approve and block callbacks
                    navigator.geolocation.getCurrentPosition( approve, block );

                // simple alert to notify user their browser does not support
                } else {
                    alert("Sorry, your browser does not support geolocation services.");
                }
            }

            // user approved; sets lat long to current position
            function approve(position) {
                const lat = position.coords.latitude.toFixed(4),
                    long = position.coords.longitude.toFixed(4);

                callAPI(lat, long);
                buildGoogleUrl(lat, long);
            }

            // user blocks; set position to Antarctica
            function block(position) {
                const lat = '-82.8628',
                    long = '135.0000';

                callAPI(lat, long);
                buildGoogleUrl(lat, long);
            }

            function buildGoogleUrl(lat, long) {
                const google = 'http://maps.google.com/maps?z=12&t=m&q=loc:',
                    mapUrl = google + lat + '+' + long;

                myLocation.href = mapUrl;
            }

            // pass in lat long answer and produce API call
            function callAPI(lat, long) {
              // To personalize app, replace with your own API key
              // const apiKey = ' ';
              const dakrskyUrl = 'https://api.darksky.net/forecast/',

                // darksky does not support COORS, this is a patch solution to pass the API off to a SaaS domain
                corsProxy = 'https://crossorigin.me/',
                oReq = new XMLHttpRequest();

              // API call
              oReq.addEventListener("load", reqListener);
              oReq.open('GET', corsProxy + dakrskyUrl + apiKey + '/' + lat + "," + long);
              oReq.send();
            }


            function updateCurrentTemp(data) {
                // Uncomment to see full data model coming from Dark Sky API
                // console.log(data);

                const dateTime = new Date(),
                    hours = (dateTime.getHours() === 0) ? 12 : (dateTime.getHours() > 12) ? dateTime.getHours() - 12 : dateTime.getHours(),
                    minutes = (dateTime.getMinutes() < 10 ? '0' : '') + dateTime.getMinutes(),
                    morningAfternoon = (dateTime.getHours() < 12) ? 'am' : 'pm';

                // parse out data in currently object
                const currentTempData = Math.round(data.currently.apparentTemperature),
                    currentSummary = data.currently.summary;

                // appending output to DOM elements
                currentTemp.innerHTML = currentTempData + '&#176;' + ' ' + currentSummary;
                currentTime.innerHTML = hours + ':' + minutes + ' ' + morningAfternoon;
                darkSkyContainer.classList.add(data.currently.icon);
            }

            function loopForecast(data) {
                // loop through 5 days of daily forecast data and parse out object values
                data.daily.data.slice(1,6).forEach(function(data) {

                    // process for turning UNIX time into human readable
                    const timeStamp = data.time;
                    const humanGMT = new Date(timeStamp * 1000);
                    const splitString = humanGMT.toString().split(" ");

                    // Generate the necessary weather list markup
                    const container = document.createElement('p'),
                        dayOfWeek = document.createElement('span'),
                        tempHigh = document.createElement('span'),
                        tempLow = document.createElement('span'),
                        forecastSummary = document.createElement('p');

                    // append response data to generated HTML DOM elements
                    container.className = 'forecast-container icon-' + data.icon;
                    tempHigh.innerHTML = Math.round(data.apparentTemperatureMax) + '&#176;' + ' ' + '/' + ' ';
                    tempHigh.className = 'high-temp';
                    tempLow.innerHTML = Math.round(data.apparentTemperatureMin) + '&#176;';
                    tempLow.className = 'low-temp';
                    dayOfWeek.innerHTML = splitString[0];
                    dayOfWeek.className = 'day-of-week';
                    forecastSummary.innerHTML = data.summary;
                    forecastSummary.className = 'forecast-summary';

                    // build out DOM
                    container.appendChild(dayOfWeek);
                    container.appendChild(tempHigh);
                    container.appendChild(tempLow);
                    container.appendChild(forecastSummary);

                    // Now append the new slide to the slide container
                    forecast.appendChild(container);
                });
            }

            // Handle the API response and update UI
            function reqListener () {

                const darkSkyResponse = JSON.parse(this.responseText);

                updateCurrentTemp(darkSkyResponse);
                loopForecast(darkSkyResponse);
            }

            return initGeolocation();
        }

        getDisplayWeatherData();
    </script>
</darksky>
