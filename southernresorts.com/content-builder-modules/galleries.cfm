<cfif isdefined('variables.thisexternalID') and LEN(variables.thisexternalID) and isValid('Integer', url.scodeID)>
	<cfquery datasource="#settings.dsn#" name="getGallery">
		Select ca.thefile
		From cms_galleries cg
		Inner Join cms_assets ca ON ca.galleryid = cg.id
		Where cg.id = <cfqueryparam value="#variables.thisexternalID#" cfsqltype="cf_sql_integer"> and ca.thefile <> <cfqueryparam value="" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfif getGallery.recordcount gt 0>
		<div class="row">
			<div class="col-md-12">
				<div class="owl-carousel owl-theme cms-carousel">
				<cfoutput query="getGallery">
					<img class="owl-lazy" data-src="/images/gallery/#thefile#">
				</cfoutput>
				</div>
			</div>
		</div>
	</cfif>
	<style>
		.owl-carousel.cms-carousel { padding: 0 50px; }
		.owl-carousel.cms-carousel .owl-nav { position: absolute; right: 0; top:50%; left: 0; transform:translate(0,-50%); }
		.owl-carousel.cms-carousel .owl-nav button.owl-prev, .owl-carousel.cms-carousel .owl-nav button.owl-next { width: 36px; height: 43px; position: absolute; background: rgba(0,0,0,0.75) !important; border-radius: 2px; text-align: center; }
		.owl-carousel.cms-carousel .owl-nav button.owl-prev { left: 0!important; }
		.owl-carousel.cms-carousel .owl-nav button.owl-next { right: 0!important; }
		.owl-carousel.cms-carousel .owl-nav button.owl-prev.disabled, .owl-carousel.cms-carousel .owl-nav button.owl-next.disabled { background: rgba(0,0,0,0.25) !important;; }
		.owl-carousel.cms-carousel .owl-prev .fa, .owl-carousel.cms-carousel .owl-next .fa { font-size: 18px; text-align: center; position:relative; top:3px; }
	</style>
	<script>
		$(document).ready(function(){ 
			$('.owl-carousel.cms-carousel').owlCarousel({
				responsive: {0:{items: 1}, 768:{items: 2}, 993:{items: 3}}, margin: 15, autoplay: false, smartSpeed: 1000, lazyLoad: true, loop: true, nav: true, navText: ["<i class='fa fa-arrow-left text-white'></i>","<i class='fa fa-arrow-right text-white'></i>"], dots: false
			  });
		})
	</script>
</cfif>

