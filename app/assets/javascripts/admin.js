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
//= require jquery.min
//= require jquery_ujs
//= require bootstrap.min
//= require turbolinks
//= require gritter
//= require dataTables/jquery.dataTables
//= require moment
//= require bootstrap-datetimepicker
//= require bootstrapValidator.min
//= require jquery.dd.min
//= require jquery.select2
// require ckeditor/init
// require ckeditor/config
// $(document).ready(function(){
//     setTimeout(function(){
//       $.fn.DataTable.isDataTable($( "table[id$='table']" ))
//     },1500);
// });

window.addEventListener('popstate', function (e) {
  $(document).on('turbolinks:before-cache', function() {
    Turbolinks.Location = location.reload()
  });
});