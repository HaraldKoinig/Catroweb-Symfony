<?php

namespace App\Admin;

use Sonata\AdminBundle\Admin\AbstractAdmin;
use Sonata\AdminBundle\Datagrid\DatagridMapper;
use Sonata\AdminBundle\Datagrid\ListMapper;
use Sonata\AdminBundle\Form\FormMapper;
use Sonata\AdminBundle\Form\Type\ModelType;
use Sonata\AdminBundle\Route\RouteCollection;
use Symfony\Component\Form\Extension\Core\Type\TextType;

/**
 * Class LimitedUsersAdmin.
 */
class LimitedUsersAdmin extends AbstractAdmin
{
  /**
   * @var string
   */
  protected $baseRouteName = 'admin_limited_users';

  /**
   * @var string
   */
  protected $baseRoutePattern = 'limited_users';

  /**
   * @param ListMapper $listMapper
   *
   * Fields to be shown on lists
   */
  protected function configureListFields(ListMapper $listMapper): void
  {
    $listMapper->addIdentifier('username')
      ->add('email')
      ->add('limited', 'boolean', [
        'editable' => true,
      ])
      ->remove('batch')
      ->add('enabled', 'boolean', [
        'editable' => true,
      ])
    ;
  }

  protected function configureDefaultSortValues(array &$sortValues): void
  {
    $sortValues['_page'] = 1;
    $sortValues['_sort_order'] = 'DESC';
    $sortValues['_sort_by'] = 'limited';
  }

  /**
   * @param DatagridMapper $datagridMapper
   *
   * Fields to be shown on filter forms
   */
  protected function configureDatagridFilters(DatagridMapper $datagridMapper): void
  {
    $datagridMapper->add('username', null, [
      'show_filter' => true,
    ])
      ->add('email')
      ->add('limited')
      ->add('enabled')
    ;
  }

  protected function configureRoutes(RouteCollection $collection): void
  {
    $collection->clearExcept([
      'list',
      'edit',
      'delete',
    ]);
  }

  /**
   * @param FormMapper $formMapper
   *
   * Fields to be shown on create/edit forms
   */
  protected function configureFormFields(FormMapper $formMapper): void
  {
    $formMapper
      ->tab('User')
      ->with('General', ['class' => 'col-md-6'])->end()
      ->end()
    ;

    $formMapper
      ->tab('User')
      ->with('General')
      ->add('username')
      ->add('email')
      ->add('plainPassword', TextType::class, [
        'required' => (!$this->getSubject() || null === $this->getSubject()->getId()),
      ])
      ->add('enabled', null, ['required' => false])
      ->add('limited')
      ->end()
      ->with('Groups')
      ->add('groups', ModelType::class, [
        'required' => false,
        'expanded' => true,
        'multiple' => true,
      ])
      ->end()
    ;
  }
}
