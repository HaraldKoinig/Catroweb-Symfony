<?php

namespace Catrobat\AppBundle\Entity;

use Doctrine\ORM\EntityRepository;

/**
 * ScratchProgramRepository.
 *
 * This class was generated by the Doctrine ORM. Add your own custom
 * repository methods below.
 */
class ScratchProgramRepository extends EntityRepository
{
  /**
   * @param int[] $scratch_program_ids
   *
   * @return array
   */
  public function getProgramDataByIds(array $scratch_program_ids)
  {
    $qb = $this->createQueryBuilder('s');

    return $qb
      ->select(['s.id', 's.name', 's.username'])
      ->where('s.id IN (:scratch_program_ids)')
      ->setParameter('scratch_program_ids', $scratch_program_ids)
      ->distinct()
      ->getQuery()
      ->getResult();
  }
}
