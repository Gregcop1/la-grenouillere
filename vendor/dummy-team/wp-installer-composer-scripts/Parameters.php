<?php
namespace DummyTeam\WpInstallerComposerScripts;

use Composer\Script\Event;

class Parameters extends Script
{
    public static function getExtras(Event $event)
    {
        $extras = parent::getExtras($event);
        if (!isset($extras['dummyteam-parameters']['destination-folder'])) {
            $extras['dummyteam-parameters']['destination-folder'] = ($extras['webroot-dir'] ? $extras['webroot-dir'] .'/../' : 'web/');
        }
        if (!isset($extras['dummyteam-parameters']['wordpress-folder'])) {
            throw new \InvalidArgumentException('You must set wordpress folder name in extra.dummyteam-parameters.wordpress-folder');
        }
        if (!isset($extras['dummyteam-parameters']['parameter-file'])) {
            throw new \InvalidArgumentException('You must set wordpress config file path in  extra.dummyteam-parameters.parameter-file');
        }
        if(!file_exists($extras['dummyteam-parameters']['destination-folder'].$extras['dummyteam-parameters']['wordpress-folder'].$extras['dummyteam-parameters']['parameter-file'])) {
            throw new \InvalidArgumentException('File "'.$extras['dummyteam-parameters']['parameter-file'].'" set in extra.dummyteam-parameters.parameter-file doesn\'t exist');
        }
        return $extras;
    }

    public static function build(Event $event)
    {
        // manage package configuration
        $globalConfig = self::getExtras($event);
        $config = $globalConfig['dummyteam-parameters'];

        // prepare output
        $io = $event->getIO();

        // copy source file to destination
        $distFile = $config['destination-folder'].'wp-config.php.dist';
        if(!file_exists($distFile)) {
            $io->write(sprintf('<info>Create "%s" file</info>', $distFile));
            copy($config['destination-folder'].$config['wordpress-folder'].$config['parameter-file'], $distFile);
        }

        // get constants definition from dist file
        $distContent  = file_get_contents($distFile);
        preg_match_all("/define\('([\w ]*)',([ \t]*)('?)([\w ]*)('?)\);/", $distContent, $constantsDist);

        $targetFile = $config['destination-folder'].'wp-config.php';
        $targetContent  = $distContent;
        if(!file_exists($targetFile)) {
            $io->write(sprintf('<info>Create "%s" file</info>', $targetFile));
            copy($config['destination-folder'].$config['wordpress-folder'].$config['parameter-file'], $targetFile);
            $constantsTarget = [];
        }else {
            $targetContent  = file_get_contents($targetFile);
            preg_match_all("/define\('([\w ]*)',(.*)/", $targetContent, $matches);
            if($matches) {
                $constantsTarget = $matches[1];
            }else {
                $constantsTarget = [];
            }
        }

        // compare parameters and ask for new one
        $diff = array_diff($constantsDist[1], $constantsTarget);
        if(count($diff)) {
            $io->write('<info>There\'s still some parameters to set. Please fill them.</info>');
            foreach($diff as $key) {
                $index = array_search($key, $constantsDist[1]);
                $default = $constantsDist[4][$index];
                $value = $io->ask(sprintf('<question>%s</question> (<comment>%s</comment>): ', $key, $default), $default);

                $pattern = "/define\('".$key."',([ \t]*)('?)([\w ]*)('?)\);/";
                if(preg_match($pattern, $targetContent, $matches)) {
                    // replace existing entry (it only happen when wp-config.php doesn't exist)
                    $targetContent = preg_replace($pattern,
                        "define('".$key."',$1$2".$value."$4);",
                        $targetContent);
                }else {
                    // it's a new entry
                    $targetContent .= PHP_EOL."define('".$key."', ".$constantsDist[3][$index].$value.$constantsDist[5][$index].");".PHP_EOL;
                }
            }

            // write the new parameters to target file
            $f = fopen($targetFile, 'w');
            fwrite($f, $targetContent);
            fclose($f);
        }
    }
}