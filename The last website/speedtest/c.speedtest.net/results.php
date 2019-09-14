<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<script type="text/javascript" src="../static/jst/zdconsent.js?version=2581283" async="true"></script>
	<script type="text/javascript" src="javascript/prebid.1.12.0.min.js"></script>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
	<meta name="description" content="Test your Internet connection bandwidth to locations around the world with this interactive broadband speed test from Ookla" >
	<meta name="keywords" lang="en" content="ookla, speed, test, speedtest, speed test, bandwidth speed test, internet speed test, broadband speed test, speakeasy, flash, cnet, internet, network, connection, broadband, bandwidth, latency, ping, throughput, download, upload, connection, dsl, adsl, cable, t1, voip, isp, asp, internet, ip, ip address, tcp, ds3" >
	<meta name="ROBOTS" content="NOYDIR">
	<meta http-equiv="X-UA-Compatible" content="IE=10" />
	<title>Flash Speedtest.net by Ookla - Results</title>
	<link rel="apple-touch-icon" href="images/apple-touch-icon.png">
	<link rel="apple-touch-icon-precomposed" href="images/apple-touch-icon.png">
	<link rel="stylesheet" type="text/css" href="css/reset.css" media="screen" />
	<link rel="stylesheet" type="text/css" href="css/tipTip.css" media="screen" />

	<link rel="stylesheet" type="text/css" href="css/layout.css" media="screen" />
	<link rel="stylesheet" type="text/css" href="css/global.css" media="screen" />

	<!--[if lte IE 6]>
		<link rel="stylesheet" type="text/css" href="css/ie6.css?v=2012-11-23" media="screen" />
		<![endif]-->
	<link rel="canonical" href="http://www.speedtest.net/results.php" />

	
	

	<script type="text/javascript" src="javascript/speedtest-main.js?v=20181003"></script>



	<meta property="og:title" content="Flash Speedtest.net by Ookla - Results" />
	<meta property="og:type" content="website" />
	<meta property="og:site_name" content="Speedtest.net" />
	<meta property="og:url" content="http://www.speedtest.net/results.php" />
	<meta property="og:image" content="images/share-logo.png" />
	<meta name="twitter:card" content="app">
	<meta name="twitter:site" content="@ookla">
	<meta name="twitter:description" content="Test your mobile network speed, wherever you may be.
	Download the free Ookla Speedtest app for iOS, Amazon, Android or Windows Phone.">
	<meta name="twitter:app:id:iphone" content="300704847">
	<meta name="twitter:app:id:ipad" content="300704847">
	<meta name="twitter:app:id:googleplay" content="org.zwanoo.android.speedtest">
	<script type="text/javascript">
		window.isBlocked = true;
	</script>
	<script type="text/javascript" src="javascript/ads.js"></script>

	<script type='text/javascript'>
	// load the google script.
	var googletag = googletag || {};
	googletag.cmd = googletag.cmd || [];
	
	addScript("//www.googletagservices.com/tag/js/gpt.js");
</script>


	<script type="text/javascript">  
  var ads;
  var AdManager = window.OOKLA.AdManager;
  // param to force internal adblock house ads for testing.
  if (window.location.search.indexOf('adBlocked') !== -1) {
    window.isBlocked = true;
  }
  // check if criteo should be used. 
  if (window.abp && false) {  
    ads = AdManager.criteo({"subpages":{"leaderboard":{"selector":".ad-horizontal","dfp":{"id":"div-gpt-ad-1426720765154-12","path":"\/4585\/speedtest.net\/st_subpage_leaderboard","size":"[728, 90]"}}}}, {"country":"US","sessionAge":"new","isp_id":2252,"household_carrier":null});
    ads.display("subpages");
  } else {
    if (true && !window.isBlocked) {
      ads = AdManager.dfpPrebid({"subpages":{"leaderboard":{"selector":".ad-horizontal","dfp":{"id":"div-gpt-ad-1426720765154-12","path":"\/4585\/speedtest.net\/st_subpage_leaderboard","size":"[728, 90]"}}}}, {"country":"US","sessionAge":"new","isp_id":2252,"household_carrier":null}, {"disableInitialLoad": true});
    } else {
      ads = AdManager.internal({"subpages":{"leaderboard":{"selector":".ad-horizontal","dfp":{"id":"div-gpt-ad-1426720765154-12","path":"\/4585\/speedtest.net\/st_subpage_leaderboard","size":"[728, 90]"}}}}, {"country":"US","sessionAge":"new","isp_id":2252,"household_carrier":null});
    }
    
    // set dfp targeting
    ads.target('hostname', 'speedtest.net');
    ads.display("subpages");
    
    // bucket test
    var bucket = [1, 2, 3, 4, 5];
    ads.target("bucket_test", bucket[Math.floor(Math.random() * bucket.length)]);
  }

</script>

	
	

	<link rel="stylesheet" type="text/css" href="http://c.speedtest.net/css/datepicker.css" media="screen" />
<script type="text/javascript" src="http://c.speedtest.net/javascript/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="http://c.speedtest.net/javascript/jquery.ui.core.js"></script>
<script type="text/javascript">
  // set date format
 $.datepicker.setDefaults({
   dateFormat: 'mm/dd/yy',
   altFormat: 'mm/dd/yy',
 });
</script>


<script type="text/javascript" src="http://c.speedtest.net/javascript/highcharts.js?v=2014-10-07"></script>

<script type="text/javascript">
function remove_result (result_id) {
	var result = confirm("This result will be permanently removed from your history.  Are you sure you want to remove it?");
	
	if (result) {
		
		var parms = 'a=remove'
		        + '&rid=' + result_id;

		 $.ajax({  
		    type: "POST",  
		    url:  "results.php",  
		    data: parms,  
		    cache: false,  
		    success: remove_success});
    }
}

function unshare () {
	var result = confirm("Your share url will be disabled and the old url will no longer work.  Are you sure you want unshare your results?");
	
	if (result) {
		window.location = "results.php?a=unshare";
    }
}

function load_more(current_page)
{
	// hide the submit link
	$("#loadmore_href").hide();
    $("#loadmore_loading").show();
	
	 var parms = 'p=' + current_page
	          + '&sb=date'
	          + '&o=desc'
	          + ''
	          + '&ria=0'
	          + '&s=0'
	          + '&a=loadmore';
	
	 $.ajax({  
	     type: "POST",  
	     url:  "results.php",  
	     data: parms,  
	     cache: false,  
	     success: loadmore_success});
			    
    return false;
}

function loadmore_success(html)  
 {  
     if (html) {
		
		 // remove the old button
		 $("#load-more").remove();
		
        // add extra rows
        $("#recent-results tbody:last").append(html);
	
     } else {
	   // hide button if no data was returned
	   $("#load-more").hide();
     }
}

function remove_success (result_id) {
	
	if (result_id) {
		$('a[result_id="' + result_id + '"]').parent().parent().animate({ opacity: "hide" }, "fast");
	}
}

//Your Results delete row
$(document).ready(function () {
  $('#recent-results a.delete-row').live('click', function(e){
  	e.preventDefault();
	    var result_id = $(this).attr('result_id');
		remove_result(result_id);
  });

  $('#recent-results tr').live('hover', function(){
        $(this).children().children('a.delete-row').css('display','inline');
  });

  $('#recent-results tr').live('mouseleave', function(){
         $(this).children().children('a.delete-row').css('display','none');
  });

  $('#recent-results a.delete-row').live('hover', function(){
    	$(this).css("background", "url(/images/st-sprite.png) -793px -22px no-repeat");
		$(this).css("cursor", "pointer");
  });
});


var theme = {
	colors: ["#33ccff", "#99cc00", "#f64f18", "#fccc02"],
	chart: {
		backgroundColor: 'rgba(0, 0, 0, 0)', 
		borderWidth: 0,
		borderRadius: 0,
		plotBackgroundColor: null,
		plotShadow: false,
		plotBorderWidth: 0
	},
	title: {
		style: { 
			color: '#FFF',
			font: '16px Lucida Grande, Lucida Sans Unicode, Verdana, Arial, Helvetica, sans-serif'
		}
	},
	subtitle: {
		style: { 
			color: '#DDD',
			font: '12px Lucida Grande, Lucida Sans Unicode, Verdana, Arial, Helvetica, sans-serif'
		}
	},
	xAxis: {
		gridLineWidth: 0,
		lineColor: '#AAA',
		tickColor: '#AAA',
		labels: {
			style: {
				color: '#AAA',
				fontWeight: 'bold'
			}
		},
		title: {
			style: {
				color: '#AAA',
				font: 'bold 12px Lucida Grande, Lucida Sans Unicode, Verdana, Arial, Helvetica, sans-serif'
			}				
		}
	},
	yAxis: {
		alternateGridColor: null,
		minorTickInterval: null,
		gridLineColor: 'rgba(255, 255, 255, .1)',
		lineWidth: 0,
		tickWidth: 0,
		labels: {
			style: {
				color: '#AAA',
				fontWeight: 'bold'
			}
		},
		title: {
			style: {
				color: '#AAA',
				font: 'bold 12px Lucida Grande, Lucida Sans Unicode, Verdana, Arial, Helvetica, sans-serif'
			}				
		}
	},
	legend: {
		itemStyle: {
			color: '#CCC'
		},
		itemHoverStyle: {
			color: '#FFF'
		},
		itemHiddenStyle: {
			color: '#333'
		}
	},
	labels: {
		style: {
			color: '#CCC'
		}
	},
	tooltip: {
		backgroundColor: {
			linearGradient: [0, 0, 0, 50],
			stops: [
				[0, 'rgba(96, 96, 96, .8)'],
				[1, 'rgba(16, 16, 16, .8)']
			]
		},
		borderWidth: 0,
		style: {
			color: '#FFF'
		}
	},
	plotOptions: {
		series: {
			dataLabels: {
				color: '#CCC'
			},
			marker: {
				lineColor: '#333'
			}
        }
	},
	
	toolbar: {
		itemStyle: {
			color: '#CCC'
		}
	},
	
	navigation: {
		buttonOptions: {
			backgroundColor: {
				linearGradient: [0, 0, 0, 20],
				stops: [
					[0.4, '#606060'],
					[0.6, '#333333']
				]
			},
			borderColor: '#000000',
			symbolStroke: '#C0C0C0',
			hoverSymbolStroke: '#FFFFFF'
		}
	},
	
	exporting: {
		buttons: {
			exportButton: {
				symbolFill: '#55BE3B'
			},
			printButton: {
				symbolFill: '#7797BE'
			}
		}
	},	
	
	// special colors for some of the
	legendBackgroundColor: 'rgba(48, 48, 48, 0.8)',
	legendBackgroundColorSolid: 'rgb(70, 70, 70)',
	dataLabelsColor: '#444',
	maskColor: 'rgba(255,255,255,0.3)'
};

var highchartsOptions = Highcharts.setOptions(theme);

var data = [0];
var dates = ['0'];
var speedUnit = "Mbps";

var detailChart;
	
jQuery(document).ready(function() {
		
	// make the container smaller and add a second container for the master chart
	var $container = jQuery('#container');
		//.css('position', 'relative');
				
	// create a detail chart referenced by a global variable
	detailChart = new Highcharts.Chart({
		chart: {
			defaultSeriesType: 'area',
			marginBottom: 20,
			marginTop: 20,
			marginLeft: 55,
			marginRight: 5,
			renderTo: 'chart-container',
			width: 730,
			height: 300
		},
		credits: {
			enabled: false
		},
		title: {
			text: null
		},
		subtitle: {
			text: null
		},
	    xAxis: {
			tickLength: 0,
	        labels: {
	            enabled: false
	        }
	    },
		yAxis: {
			title: {
				text: 'Speeds (' + speedUnit + ')',
				margin: (55 - 40),
			},
			maxZoom: 0.1,
			min: 0,
		},
		tooltip: {
			formatter: function() {
				if (this.series.type == 'line') {
					return this.series.name + '<br><b>' + this.y +' ' + speedUnit + '</b>';
				} else {
					return dates[this.point.x] + '<br><b>' + this.y +' ' + speedUnit + '</b>';
				}
			}
		},
		legend: {
			enabled: true,
			layout: 'horizontal',
			floating: false,
			align: 'center',
			verticalAlign: 'bottom',
			borderWidth: 0,
			y: 12
		},
		plotOptions: {
			series: {
				marker: {
					enabled: false,
					states: {
						hover: {
							enabled: true,
							radius: 3
						}
					}
				}
			}
		},
		series: [
		{
			type: 'area',
			data: data,
			color: '#33ccff', 
			name: 'You',
			zIndex: 1,
			fillColor: {
		         linearGradient: [0, 0, 0, 250],
		        stops: [
		            [0, 'rgba(51, 204, 255, 100)'],
		            [0.88, 'rgba(0,0,0,0)']
		        ]
		    },
			lineWidth: 3
		}
		],
		
		exporting: {
			enabled: false
		}

	});
	
	
});

</script>

	
	</head>
	<body id="your-results" class="">

		<!-- Google Tag Manager -->
<noscript><iframe src="//www.googletagmanager.com/ns.html?id=GTM-MX6CBT"
height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<script>
(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'//www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','GTM-MX6CBT');</script>
<!-- End Google Tag Manager -->

		<div id="consent_blackbar"></div>

		<div id="header-container">

			<div id="header" class="clearfix">

				<div id="logo">
					<a href="/">Ookla Speedtest</a>
				</div><!--/logo-->

				<div id="nav">
					<ul>
						<li class="nav-advertise">
	<a href="/partner-with-ookla"><i></i>&nbsp;Advertise</a>
</li>

<li class="nav-host">
	<a href="http://www.ookla.com/host"><i></i>&nbsp;Become a Host</a>
</li>

<li class="nav-results">
	<a href="/results.php"><i></i>&nbsp;My Results</a>
</li>

<li class="nav-support">
	<a href="https://support.speedtest.net/home"><i></i>&nbsp;Support</a>
</li>

<li class="nav-settings">
	<a href="/user-settings.php"><i></i>&nbsp;Settings</a>
</li>

<li class="nav-login"><a class="login-title" href="/user-login.php"><i></i>Login</a></li>

<li class="nav-account"><a href="/user-register.php"><i></i>&nbsp;Create Account</a></li>

					</ul>
				</div><!--/nav-->

				<div class="login-box">
	<form method="post" action="https://legacy.speedtest.net/user-login.php" >
		<fieldset>
			<input id="action" type="hidden" name="action" value="login" />
			<input id="login-email" type="text" name="email" class="field" placeholder="Email" />
			<input id="login-pw" type="password" name="password" class="field" placeholder="Password" />
			<div class="pw-help">
				<input id="remember-me" type="checkbox" name="remember-me" />
				<label for="remember-me">Remember Me</label><br /><a href="/password-reset.php">Forgot Password?</a>
			</div>
			<div id="form-submit-login-menu"><input type="submit" value="Login"></input></div>
		</fieldset>
	</form>
</div><!--/login-box-->


				<div class="try-st4"><a href="http://www.speedtest.net/">Try the new Speedtest</a></div>

			</div><!--/header-->
			</div><!--/header-container-->

			<div id=container>
<div class="alert-container"><div class="neutral-box alert"><p>If you have an account you must <a href='user-login.php'>login</a> to see your results history.</p></div></div><!--/alert--><div class="ad-space ad-horizontal"></div><!--/ad-space-->

<div id="content">

<div id="yr-header">
	<h1>My Results</h1>
	<a style='display:none;' id="yr-share" href="#?w=300" rel="modal-share" class="modal">Share This Page</a>
	<a  id="yr-unshare" href="results.php?a=share">Enable Sharing</a>

	<div id="modal-share" class="modal-block">
		<h4>Share This Page</h4>
		<p>Use one of the links below to share this entire results page with others. You can always stop sharing it via the Unshare button if you change your mind.</p>
		<fieldset><label for="share-link">Share Link:</label>
		<input name="share-link" id="" type="text" value="http://www.speedtest.net/results.php?sh=&ria=0" readonly="readonly" onclick="this.focus();this.select()"></fieldset>

	<label>Share Elsewhere:</label>
	<div class="modal-share-icons">
	<ul>
	<li class="share-fb"><a href="https://www.facebook.com/dialog/feed?app_id=581657151866321&amp;link=http://www.speedtest.net/my-result/&amp;description=This%20is%20my%20Speedtest.net%20result.%20Compare%20your%20speed%20to%20mine!&amp;redirect_uri=http://www.speedtest.net&amp;name=Check%20out%20my%20Speedtest.net%20Result.%20What%27s%20Yours%3F" target="_blank">Facebook</a></li>
	<li class="share-tw"><a href="https://twitter.com/share?text=Check%20out%20my%20Speedtest.net%20result!%20What%27s%20your%20speed%3F&amp;url=http%3A%2F%2Fwww.speedtest.net%2Fmy-result%2F&amp;related=ookla%3ACreators%20of%20Speedtest.net&amp;hashtags=speedtest" target="_blank">Twitter</a></li>
	<li class="share-li"><a href="http://www.linkedin.com/shareArticle?mini=true&amp;url=http://www.speedtest.net/my-result/&amp;title=Ookla Speedtest - The Global Broadband Speed Test&amp;summary=Check out my result history from Ookla Speedtest&amp;source=Speedtest.net" target="_blank">LinkedIn</a></li>
	<li class="share-pn"><a href="http://pinterest.com/pin/create/button/?url=http://www.speedtest.net/my-result/&amp;media=http://www.speedtest.net/results.php?sh=&amp;description=Check out my result history from Ookla Speedtest" target="_blank">Pinterest</a></li>
	<li class="share-rd"><a href="http://reddit.com/submit?url=http://www.speedtest.net/my-result/&amp;title=Ookla Speedtest - The Global Broadband Speed Test" target="_blank">Reddit</a></li>
	<li class="share-em"><a href="mailto:?subject=Check%20Out%20My%20Speedtest.net%20Connection%20Speed!&amp;body=This%20is%20my%20Speedtest.net%20connection%20speed.%20You%20should%20take%20a%20test%20too!%0A%0Ahttp%3A%2F%2Fwww.speedtest.net%2Fmy-result%2F%3Futm_source%3Dshare-page%26utm_medium%3Demail%26utm_campaign%3Dsharev1">Email</a></li>
</ul>

	</div><!--/modal-share-icons-->
	</div><!--/modal-share-->

	<div id="yr-test-button"><a href="/"><p><span>Take a Speed Test</span></p></a></div>
</div><!--/yr-header-->

<div id="yr-main">
	<h2>ALL MY TESTS</h2>

	<div id="yr-isp">
	<span id="isp">(ALL RESULTS)</span>

	<div class="ip-dropdown">
	<span class="ip" href="">Change</span>
	<ul class="ips">
		<li><a href='results.php?ria=0'>ALL MY TESTS</a></li>
	</ul>
	</div><!--/ip-dropdown-->

	<span id="test-count">0 total | Last Test: -</span>
	</div><!--/yr-isp-->

	<div id="yr-graph">

	<ul id="comparison-tabs">
		<li id="dl-comparison" class="current"><a href="results.php?ct=d&ria=0&s=0">Download Comparison</a></li>
		<li id="ul-comparison" class=""><a href="?ct=u&ria=0&s=0">Upload Comparison</a></li>
		<li id="server-comparison" class=""><a href="?ct=s&ria=0">Server Comparison</a></li>
	</ul>

	<div id="chart-container"></div>

	<div id="yr-dropdowns">

	<div class="server-dropdown">
	<span class="server" href="">All Servers</span>
	<ul class="servers">
		<li><a href="results.php?s=0&ria=0&ct=">All Servers</a></li>
	</ul>

	</div><!--/server-dropdown-->

	<div class="timeframe-dropdown">

		<form>
		<label for="datepicker">Ignore Results Before </label>
		<input type="text" id="datepicker" value="" onchange="window.location='results.php?hd=' + this.value + '' + '&s=0';" />
		</form>

		</div><!--/timeframe-dropdown-->

		


	</div><!--/yr-dropdowns-->


	</div><!--/yr-graph-->

	<div id="yr-best-results">
	<h3>Best Result</h3>

	<ul>
		<li id="dl-bestresult">
		<span>N/A</span><a style='display:none;' href="#?w=300" rel="modal-dl-img" class="modal blue-link">Share</a></li>
			<div id="modal-dl-img" class="modal-block">
			<img src="/result/.png" alt="Share Image" />
			<fieldset><label for="share-link">Share Link:</label>
			<input name="share-link" id="" type="text" value="http://www.speedtest.net/my-result/" readonly="readonly" onclick="this.focus();this.select()"></fieldset>
			<div class="mini-share">
				<label>Share Elsewhere:</label>
				<div class="modal-share-icons">
					<ul>
	<li class="share-fb"><a href="https://www.facebook.com/dialog/feed?app_id=581657151866321&amp;link=http://www.speedtest.net/my-result/&amp;description=This%20is%20my%20Speedtest.net%20result.%20Compare%20your%20speed%20to%20mine!&amp;redirect_uri=http://www.speedtest.net&amp;name=Check%20out%20my%20Speedtest.net%20Result.%20What%27s%20Yours%3F" target="_blank">Facebook</a></li>
	<li class="share-tw"><a href="https://twitter.com/share?text=Check%20out%20my%20Speedtest.net%20result!%20What%27s%20your%20speed%3F&amp;url=http%3A%2F%2Fwww.speedtest.net%2Fmy-result%2F&amp;related=ookla%3ACreators%20of%20Speedtest.net&amp;hashtags=speedtest" target="_blank">Twitter</a></li>
	<li class="share-li"><a href="http://www.linkedin.com/shareArticle?mini=true&amp;url=http://www.speedtest.net/my-result/&amp;title=Check out my result from Ookla Speedtest!&amp;summary=Check out my result from Ookla Speedtest!&amp;source=Speedtest.net" target="_blank">LinkedIn</a></li>
	<li class="share-pn"><a href="http://pinterest.com/pin/create/button/?url=http://www.speedtest.net/my-result/&amp;media=http://www.speedtest.net/speedtest.net/result/.png&amp;description=Check out my result from Ookla Speedtest!" target="_blank">Pinterest</a></li>
	<li class="share-rd"><a href="http://reddit.com/submit?url=http://www.speedtest.net/my-result/&amp;title=Check out my result from Ookla Speedtest!" target="_blank">Reddit</a></li>
	<li class="share-em"><a href="mailto:?subject=Check%20Out%20My%20Speedtest.net%20Connection%20Speed!&amp;body=This%20is%20my%20Speedtest.net%20connection%20speed.%20You%20should%20take%20a%20test%20too!%0A%0Ahttp%3A%2F%2Fwww.speedtest.net%2Fmy-result%2F%3Futm_source%3Dshare-page%26utm_medium%3Demail%26utm_campaign%3Dsharev1">Email</a></li>
</ul>

				</div>
			</div>
			</div><!--/modal-dl-img-->
		<li id="ul-bestresult">
		<span>N/A</span><a style='display:none;' href="#?w=300" rel="modal-ul-img" class="modal blue-link">Share</a></li>
			<div id="modal-ul-img" class="modal-block">
			<img src="/result/.png" alt="Share Image" />
			<fieldset><label for="share-link">Share Link:</label>
			<input name="share-link" id="" type="text" value="http://www.speedtest.net/my-result/" readonly="readonly" onclick="this.focus();this.select()"></fieldset>
			<div class="mini-share">
				<label>Share Elsewhere:</label>
				<div class="modal-share-icons">
					<ul>
	<li class="share-fb"><a href="https://www.facebook.com/dialog/feed?app_id=581657151866321&amp;link=http://www.speedtest.net/my-result/&amp;description=This%20is%20my%20Speedtest.net%20result.%20Compare%20your%20speed%20to%20mine!&amp;redirect_uri=http://www.speedtest.net&amp;name=Check%20out%20my%20Speedtest.net%20Result.%20What%27s%20Yours%3F" target="_blank">Facebook</a></li>
	<li class="share-tw"><a href="https://twitter.com/share?text=Check%20out%20my%20Speedtest.net%20result!%20What%27s%20your%20speed%3F&amp;url=http%3A%2F%2Fwww.speedtest.net%2Fmy-result%2F&amp;related=ookla%3ACreators%20of%20Speedtest.net&amp;hashtags=speedtest" target="_blank">Twitter</a></li>
	<li class="share-li"><a href="http://www.linkedin.com/shareArticle?mini=true&amp;url=http://www.speedtest.net/my-result/&amp;title=Check out my result from Ookla Speedtest!&amp;summary=Check out my result from Ookla Speedtest!&amp;source=Speedtest.net" target="_blank">LinkedIn</a></li>
	<li class="share-pn"><a href="http://pinterest.com/pin/create/button/?url=http://www.speedtest.net/my-result/&amp;media=http://www.speedtest.net/speedtest.net/result/.png&amp;description=Check out my result from Ookla Speedtest!" target="_blank">Pinterest</a></li>
	<li class="share-rd"><a href="http://reddit.com/submit?url=http://www.speedtest.net/my-result/&amp;title=Check out my result from Ookla Speedtest!" target="_blank">Reddit</a></li>
	<li class="share-em"><a href="mailto:?subject=Check%20Out%20My%20Speedtest.net%20Connection%20Speed!&amp;body=This%20is%20my%20Speedtest.net%20connection%20speed.%20You%20should%20take%20a%20test%20too!%0A%0Ahttp%3A%2F%2Fwww.speedtest.net%2Fmy-result%2F%3Futm_source%3Dshare-page%26utm_medium%3Demail%26utm_campaign%3Dsharev1">Email</a></li>
</ul>

				</div>
			</div>
			</div><!--/modal-ul-img-->
		<li id="server-bestresult"><span>N/A</span></li>
	</ul>

	</div><!--/yr-best-results-->

	<div id="yr-connection-grade">
	<h3>Connection Grade <a href="#?w=400" rel="modal-whats-this" class="modal">?</a></h3>

		<div id="modal-whats-this" class="modal-block">
		<h4>What is this?</h4>
		<p>Based on the currently displayed results, connection grades show how you stack up with others in your country and around the world. For example if your value is 77% (giving you a B+) then only 23% of connections are faster than yours. The scale is:<br/><br/>
			A = 80-100%<br/>
			B = 60-79%<br/>
			C = 40-59%<br/>
			D = 20-39%<br/>
			F = 0-19%<br/><br/>
			Plus/minus grades are given for the top/bottom 5% of each grade.</p>
		</div><!--/modal-whats-this-->

	<ul>
		<li><span class="grade-title">National Grade</span>N/A</li>
		<li><span class="grade-title">Global Grade</span>N/A</li>
	</ul>

	</div><!--/yr-connection-grade-->

	<div id="yr-about-data">
	<h3>About This Data</h3>

	<p>Comparison data comes from aggregated Ookla Speedtest results.</p>
	</div><!--/yr-about-data-->


</div><!--/yr-main-->

<div id="yr-recent-results">
	<h2>Recent Results</h2>

	<div id="yr-recent-results-options">
			<a href="/csv.php?csv=1&ria=0&s=0" class="blue-link">Export Results</a>
	</div><!--/yr-recent-results-options-->
	<div id="yr-speedwave"><a href="speedwave-control.php">Speedwave</a></div>


		<table id="recent-results" cellspacing="0" cellpadding="0" border="0">
			<thead>
				<tr><th class='no-border delete-row-th'><span><img src="images/icon-th-delete.png" class="delete-icon"></span></th><th><span><img src="images/icon-th-sw.png" class="sw-icon"></span></th><th class='active'><a class='sort-url' href='results.php?o=asc&sb=date'> Date <img src='images/bg-ascending.png' alt='ascending' /></a></th><th ><a class='sort-url' href='results.php?o=desc&sb=ipaddress'> IP Address </a></th><th ><a class='sort-url' href='results.php?o=desc&sb=download'><img class="speed-icon" src="images/icon-th-dl.png"> Download </a></th><th ><a class='sort-url' href='results.php?o=desc&sb=upload'><img class="speed-icon" src="images/icon-th-ul.png"> Upload </a></th><th ><a class='sort-url' href='results.php?o=desc&sb=latency'><img class="speed-icon" src="images/icon-th-ping.png"> Latency </a></th><th ><a class='sort-url' href='results.php?o=desc&sb=server'> Server </a></th><th><span>Distance</span></th><th><span>Share</span></th></tr>
			</thead>
			<tbody>
				<tr class="even">
	<td>N/A</td>
	<td>N/A</td>
	<td>N/A</td>
	<td>N/A</td>
	<td>N/A</td>
	<td>N/A</td>
	<td>N/A</td>
	<td>N/A</td>
	<td>N/A</td>
	<td>N/A</td>
</tr>
				
			</tbody>
		</table>

	</div><!--/yr-recent-results-->

</div><!--/content-->
</div><!--/container-->

<div id="footer">

	<div class="footer-content-wrapper">

		<div id="footer-nav">

			<ul>
				<li class="footer-title" id="footer-company">Company</li>
				<li><a href="/about">About</a></li>
				<li><a href="/partner-with-ookla">Advertise</a></li>
				<li><a target="_blank"  href="http://www.speedtest.net/awards">Speedtest Awards</a></li>
				<li><a target="_blank"  href="http://www.speedtest.net/reports">Speedtest Reports</a></li>
				<li><a target="_blank" href="http://www.speedtest.net/insights/blog/">Speedtest Insights</a></li>
				<li><a target="_blank" href="http://www.speedtest.net/global-index">Speedtest Global Index</a></li>
				<li><a target="_blank" href="http://www.facebook.com/teamookla">Facebook</a></li>
				<li><a target="_blank" href="http://twitter.com/speedtest">Twitter</a></li>
			</ul>

			<ul>
				<li class="footer-title" id="footer-products">Products</li>
				<li><a href="/">Speedtest</a></li>
				<li><a href="/mobile/">Speedtest Mobile</a></li>
				<li><a href="/apps/desktop">Speedtest Desktop</a></li>
				<li><a href="http://www.ookla.com/speedtest-custom">Speedtest Custom</a></li>
			</ul>

			<ul>
				<li class="footer-title" id="footer-ziff">Ziff Davis</li>
				<li><a target="_blank" href="http://www.ign.com/">IGN</a></li>
				<li><a target="_blank" href="http://www.askmen.com/">AskMen</a></li>
				<li><a target="_blank" href="http://www.pcmag.com/">PCMag</a></li>
				<li><a target="_blank" href="http://www.offers.com/">Offers.com</a></li>
				<li><a target="_blank" href="http://www.extremetech.com/">ExtremeTech</a></li>
				<li><a target="_blank" href="http://www.geek.com/">Geek</a></li>
				<li><a target="_blank" href="http://www.toolbox.com/">Toolbox</a></li>
			</ul>

		</div><!--/footer-nav-->

		<div id="footer-ookla">
			<div id="footer-logo">
				<a href="http://ookla.com/"></a>
			</div>
			<div>
				<span id="copyright">
					<strong>Accurate, free and powered by <a href="http://ookla.com/">Ookla</a> &mdash; the global standard in network testing.</strong><br>
&copy; Copyright 2017 <a href="http://ookla.com/">Ookla</a>
				</span>
				<br />
				    <a href="/privacy">Privacy Policy</a> | 

				<a href="/terms">Terms &amp; Conditions</a> |
				<a href="http://status.ookla.com">Network Status</a> |
				
<div class="evidon-notice-link"></div>

			</div>
			<div id="footer-lang">
				<a href="/switch_language.php?lang=de">DE</a> |
				<a href="/switch_language.php?lang=en">EN</a> |
				<a href="/switch_language.php?lang=es">ES</a> |
				<a href="/switch_language.php?lang=fr">FR</a> |
				<a href="/switch_language.php?lang=id">ID</a> |
				<a href="/switch_language.php?lang=it">IT</a> |
				<a href="/switch_language.php?lang=nl">NL</a> |
				<a href="/switch_language.php?lang=pl">PL</a> |
				<a href="/switch_language.php?lang=pt">PT</a> |
				<a href="/switch_language.php?lang=ru">RU</a> |
				<a href="/switch_language.php?lang=sv">SV</a>
			</div>
		</div><!--/footer-ookla-->

		<iframe id="iframedl" name="iframedl" frameborder="0"></iframe>

	</div><!--/footer-content-wrapper-->

	

</div><!--/footer-->



<!-- comscore script -->
<script>
var _comscore = _comscore || [];
  _comscore.push({ c1: "2", c2: "6036316" });
(function() {
  var coms = document.createElement("script"), el_coms = document.getElementsByTagName("script")[0]; coms.async = true;
  coms.src = (document.location.protocol == "https:" ? "https://sb" : "http://b") + ".scorecardresearch.com/beacon.js";
  el_coms.parentNode.insertBefore(coms, el_coms);

})();

(function() {
  var nss = document.createElement("script"), el_nss = document.getElementsByTagName("script")[0];

  nss.src = "//secure-us.imrworldwide.com/v60.js";
  el_nss.parentNode.insertBefore(nss, el_nss);
  setTimeout(function() {
    pvar = { cid: "ziffdavis", content: "0", server: "secure-us" };
    try {
      var trac = nol_t(pvar);
      trac.record().post();
    } catch (e) {}
  }, 1000);

})();
</script>
<!-- /comscore script -->



</body>
</html>
