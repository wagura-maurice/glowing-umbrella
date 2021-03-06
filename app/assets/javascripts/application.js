// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require dataTables/jquery.dataTables
//= require_tree .
//= require moment
//= require bootstrap-datetimepicker
//= require reports_kit/application
//= require Chart.bundle
//= require chartkick

$(document).on('turbolinks:load', function(event) {
	if (window.firstPageLoadDone) {
			$('.reports_kit_report').each(function(index, el) {
	    var el = $(el);
	    var reportClass = el.data('report-class');
	    new ReportsKit[reportClass]().render({ 'el': el });
	  });
	} else {
		window.firstPageLoadDone = true;
	}
})
