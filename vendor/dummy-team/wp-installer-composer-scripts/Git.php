<?php
namespace DummyTeam\WpInstallerComposerScripts;

use Composer\Script\Event;

class Git
{
    public static function build(Event $event)
    {
        // prepare output
        $io = $event->getIO();

        $ask = 'Do you wan\'t to create a Git Repository? ';
        $hasToCreateAGitRepository = $io->askConfirmation(sprintf('<question>%s</question>: ', $ask), true);

        if($hasToCreateAGitRepository) {
            // repository initialization
            exec('git init');
            $io->write(PHP_EOL.'<info>Git repository initialization</info>'.PHP_EOL);

            // remote initialization
            $ask = 'Git repository remote URL';
            $comment = 'let it blank if don\'t have one yet';
            $repositoryUrl = $io->ask(sprintf('<question>%s</question> (<comment>%s</comment>): ', $ask, $comment), '');
            if($repositoryUrl != '') {
                $io->write(PHP_EOL.sprintf('<info>Set repository origin as: %s</info>', $repositoryUrl).PHP_EOL);
                exec(sprintf('git remote add origin %s', $repositoryUrl));
            }
        }
    }
}