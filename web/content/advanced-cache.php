<?php
defined( 'ABSPATH' ) or die( 'Cheatin\' uh?' );

define( 'WP_ROCKET_ADVANCED_CACHE', true );
$rocket_cache_path = '/Users/matteo/Sites/la-grenouillere/la-grenouillere/web/content/cache/wp-rocket/';
$rocket_config_path = '/Users/matteo/Sites/la-grenouillere/la-grenouillere/web/content/wp-rocket-config/';

if ( file_exists( '/Users/matteo/Sites/la-grenouillere/la-grenouillere/web/content/plugins/wp-rocket/inc/front/process.php' ) ) {
	include( '/Users/matteo/Sites/la-grenouillere/la-grenouillere/web/content/plugins/wp-rocket/inc/front/process.php' );
} else {
	define( 'WP_ROCKET_ADVANCED_CACHE_PROBLEM', true );
}