<my-app>
    <style type="scss" scoped>
        $ico-font-dir: 'assets/fonts/';
        $ico-font-family: 'icomoon';

        :scope {
          display: block;
          height: 100vh;
        }

        a {
            &,
            &:hover,
            &:active {
                color: #fff;
                text-decoration: none;
            }
        }

        .visuallyhidden {
            position: absolute;
            overflow: hidden;
            clip: rect(0 0 0 0);
            height: 1px; width: 1px;
            margin: -1px; padding: 0; border: 0;
        }

        @font-face {
            font-family: '#{$ico-font-family}';
            src:  url('#{$ico-font-dir}/#{$ico-font-family}.eot?lj87yq');
            src:  url('#{$ico-font-dir}/#{$ico-font-family}.eot?lj87yq#iefix') format('embedded-opentype'),
            url('#{$ico-font-dir}/#{$ico-font-family}.ttf?lj87yq') format('truetype'),
            url('#{$ico-font-dir}/#{$ico-font-family}.woff?lj87yq') format('woff'),
            url('#{$ico-font-dir}/#{$ico-font-family}.svg?lj87yq##{$ico-font-family}') format('svg');
            font-weight: normal;
            font-style: normal;
        }

        [class^="icon-"],
        [class*=" icon-"] {
            /* use !important to prevent issues with browser extensions that change fonts */
            font-family: '#{$ico-font-family}' !important;
            speak: none;
            font-style: normal;
            font-weight: normal;
            font-variant: normal;
            text-transform: none;
            line-height: 1;

            /* Better Font Rendering =========== */
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;

            &:before {
              padding: 10px 10px 10px 0;
            }
        }

        .icon-partly-cloudy-night:before {
            content: "\e900";
        }
        .icon-clear-night:before {
            content: "\e902";
        }
        .icon-sleet:before {
            content: "\e903";
        }
        .icon-snow:before {
            content: "\e904";
        }
        .icon-rain:before {
            content: "\e905";
        }
        .icon-cloudy:before {
            content: "\e906";
        }
        .icon-fog:before {
            content: "\e907";
        }
        .icon-partly-cloudy-day:before {
            content: "\e908";
        }
        .icon-wind:before {
            content: "\e909";
        }
        .icon-clear-day:before {
            content: "\e90a";
        }
        .icon-location:before {
          content: "\e947";
        }
    </style>

    <darksky></darksky>
</my-app>
