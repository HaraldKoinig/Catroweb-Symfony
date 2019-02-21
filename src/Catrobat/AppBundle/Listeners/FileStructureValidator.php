<?php

namespace Catrobat\AppBundle\Listeners;

use Catrobat\AppBundle\Services\ExtractedCatrobatFile;
use Symfony\Component\Finder\Finder;
use Catrobat\AppBundle\Events\ProgramBeforeInsertEvent;
use Catrobat\AppBundle\Exceptions\Upload\UnexpectedFileException;


/**
 * Class FileStructureValidator
 * @package Catrobat\AppBundle\Listeners
 */
class FileStructureValidator
{
  /**
   * @param ProgramBeforeInsertEvent $event
   */
  public function onProgramBeforeInsert(ProgramBeforeInsertEvent $event)
  {
    $this->validate($event->getExtractedFile());
  }

  /**
   * @param ExtractedCatrobatFile $file
   */
  public function validate(ExtractedCatrobatFile $file)
  {

    $finder = new Finder();
    $finder->in($file->getPath())
      ->name("*/*")
      ->exclude(['/^.*/sounds/', '/^.*/images/'])
      ->notPath('/^code.xml$/')
      ->notPath('/^permissions.txt$/')
      ->notPath('/^screenshot.png$/')
      ->notPath('/^manual_screenshot.png$/')
      ->notPath('/^automatic_screenshot.png$/');

    $test = "";
    foreach ($finder as $file1)
    {
      $test .= $file1->getRelativePathname() . "\n";
      file_put_contents("/home/catroweb/Catroweb/FileStructureValidator_error.log", $test);
    }

    if ($finder->count() > 0)
    {
      $list = [];
      foreach ($finder as $file)
      {
        $list[] = $file->getRelativePathname();
      }

      print_r($list);


      throw new UnexpectedFileException('unexpected files found: ' . implode(', ', $list));
    }
  }
}
