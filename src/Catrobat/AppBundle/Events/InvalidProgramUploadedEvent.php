<?php

namespace Catrobat\AppBundle\Events;

use Symfony\Component\EventDispatcher\Event;
use Symfony\Component\HttpFoundation\File\File;
use Catrobat\AppBundle\Exceptions\InvalidCatrobatFileException;

/**
 * Class InvalidProgramUploadedEvent
 * @package Catrobat\AppBundle\Events
 */
class InvalidProgramUploadedEvent extends Event
{
  /**
   * @var File
   */
  protected $file;
  /**
   * @var InvalidCatrobatFileException
   */
  protected $exception;

  /**
   * InvalidProgramUploadedEvent constructor.
   *
   * @param File                         $file
   * @param InvalidCatrobatFileException $exception
   */
  public function __construct(File $file, InvalidCatrobatFileException $exception)
  {
    $this->file = $file;
    $this->exception = $exception;
  }

  /**
   * @return File
   */
  public function getFile()
  {
    return $this->file;
  }

  /**
   * @return InvalidCatrobatFileException
   */
  public function getException()
  {
    return $this->exception;
  }
}
