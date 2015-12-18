<?php
namespace DummyTeam\WpInstallerComposerScripts;

use Composer\Script\Event;

class Script
{
    public static function getExtras(Event $event)
    {
        $extras = $event->getComposer()->getPackage()->getExtra();
        if (!isset($extras['dummyteam-parameters'])) {
            throw new \InvalidArgumentException('You have to specify settings via extra.dummyteam-parameters.');
        }
        return $extras;
    }
}