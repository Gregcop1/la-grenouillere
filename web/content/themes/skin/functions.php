<?php

class SkinSite extends TimberSite
{

    public function __construct()
    {
        $this->disableBar();
        $this->addAction();
        $this->removeAction();
        $this->registerScripts();
        $this->register_menus();
        $this->registerL18nStrings();

        parent::__construct();
    }

    public static function isReallyHome()
    {
        return $_SERVER['REQUEST_URI'] === '/';
    }

    private function addAction()
    {
        add_action('wp_footer', array($this, 'print_inline_script'));
    }

    private function removeAction()
    {
        remove_action('wp_head', 'print_emoji_detection_script', 7);
        remove_action('admin_print_scripts', 'print_emoji_detection_script');
        remove_action('wp_print_styles', 'print_emoji_styles');
        remove_action('admin_print_styles', 'print_emoji_styles');
        remove_filter('the_content_feed', 'wp_staticize_emoji');
        remove_filter('comment_text_rss', 'wp_staticize_emoji');
        remove_filter('wp_mail', 'wp_staticize_emoji_for_email');
    }

    private function disableBar()
    {
        show_admin_bar(false);
    }

    private function registerScripts()
    {
        //Ultimate_VC_Addons/assets/min-css/ultimate.min.css
        wp_enqueue_script('modernizr', get_stylesheet_directory_uri() . '/web/js/vendors/modernizr.js');
        wp_enqueue_script('snap/svg', get_stylesheet_directory_uri() . '/web/js/vendors/snap.svg-min.js');
        wp_enqueue_script('ultimateVC-modernizr', plugins_url('Ultimate_VC_Addons/assets/min-js/modernizr-custom.min.js'), ['jquery'], '3.13.17');
        wp_enqueue_script('ultimateVC-ultimate', plugins_url('Ultimate_VC_Addons/assets/min-js/ultimate.min.js'), ['jquery'], '3.13.17');
        wp_enqueue_script('ultimateVC-modal', get_stylesheet_directory_uri() . '/web/js/vendors/modal.js', ['jquery'], '3.13.17');

        wp_enqueue_style('ultimateVC', plugins_url('Ultimate_VC_Addons/assets/min-css/ultimate.min.css')); // Add composer files to all templates
    }

    public function print_inline_script()
    {
        if ($_SERVER['SERVER_NAME'] == 'localhost') {
            echo "<script type='text/javascript' id='__bs_script__'>
                    document.write(\"<script async src='http://HOST:3000/browser-sync/browser-sync-client.2.9.11.js'><\/script>\".replace(\"HOST\", location.hostname));
                </script>";
        }
    }

    private function register_menus()
    {
        //this is where you can register menus
        register_nav_menus(array(
            'first-level' => __('Niveau 1', 'skin-dummy')
        ));
    }

    public function registerL18nStrings() {
        pll_register_string('otherSites', 'Les autres établissements d\'Alexandre Gauthier');
        pll_register_string('nextStep', 'prochaine étape...');
    }

    public static function getL18nStrings() {
        $context = array();
        $context['nextStep'] = pll__('prochaine étape...');
        $context['otherSites'] = pll__('Les autres établissements d\'Alexandre Gauthier');

        return $context;
    }
}

new SkinSite();
