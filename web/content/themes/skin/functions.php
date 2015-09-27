<?php

class SkinSite extends TimberSite
{

    public function __construct()
    {
        $this->disableBar();
        $this->removeAction();
        $this->registerScripts();
        parent::__construct();
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
        if(!is_admin()) {
            wp_deregister_script('jquery');
            wp_register_script('jquery', (""), false, '');
            wp_enqueue_script('jquery');
        }
    }
}

new SkinSite();