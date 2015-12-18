<?php
namespace DummyTeam\WpInstallerComposerScripts;

use Composer\Script\Event;

class Structure extends Script
{
    public static function build(Event $event)
    {
        $extras = parent::getExtras($event);
        $config = $extras['dummyteam-parameters'];
        if (!isset($config['destination-folder'])) {
            throw new \InvalidArgumentException('You must set installation path in extra.dummyteam-parameters.destination-folder');
        }
        if (!isset($config['wordpress-folder'])) {
            throw new \InvalidArgumentException('You must set wordpress folder name in extra.dummyteam-parameters.wordpress-folder');
        }
        if (!isset($config['wp-content-folder'])) {
            throw new \InvalidArgumentException('You must set wp-content folder name in extra.dummyteam-parameters.wp-content-folder');
        }

        // prepare output
        $io = $event->getIO();
        $io->write('<info>Prepare the directory structure</info>');

        // write the new parameters to target file
        if(!file_exists($config['destination-folder'].$config['wp-content-folder'])) {
            mkdir($config['destination-folder'].$config['wp-content-folder']);
        }
        $targetFile = $config['destination-folder'].'index.php';
        $f = fopen($targetFile, 'w');
        fwrite($f, "
<?php
define('WP_USE_THEMES', true);
define('WP_CONTENT_DIR', dirname(__FILE__).'/wp-content');
require(dirname(__FILE__).'/".$config['wordpress-folder']."wp-blog-header.php');
        ");
        fclose($f);
        $io->write('<info>Create index file.</info>');
    }
}