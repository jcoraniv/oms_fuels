document.addEventListener("DOMContentLoaded", () => {
  console.log("Dashboard loaded");
  if (window.$ && $.AdminLTE) {
    console.log("AdminLTE ready in dashboard");
    $('[data-widget="pushmenu"]').PushMenu();
  }
});