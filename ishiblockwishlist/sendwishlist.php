<?php
/******************

 * Ishi Technolabs  Framework for Prestashop 1.7.x 
 * @package   	ishiblockwishlist
 * @version   	1.0
 * @author   	http://ishitechnolabs.com/
 * @license   GNU General Public License version 1
 
 * *****************/

require_once(dirname(__FILE__).'/../../config/config.inc.php');
require_once(dirname(__FILE__).'/../../init.php');
require_once(dirname(__FILE__).'/WishList.php');
require_once(dirname(__FILE__).'/ishiblockwishlist.php');

$context = Context::getContext();

// Instance of module class for translations
$module = new IshiBlockWishList();

if (Configuration::get('PS_TOKEN_ENABLE') == 1 AND
	strcmp(Tools::getToken(false), Tools::getValue('token')) AND
	$context->customer->isLogged() === true
)
	exit($module->l('invalid token', 'sendwishlist'));

if ($context->customer->isLogged())
{
	$id_wishlist = (int)Tools::getValue('id_wishlist');
	if (empty($id_wishlist) === true)
		exit($module->l('Invalid wishlist', 'sendwishlist'));
	for ($i = 1; empty(Tools::getValue('email'.strval($i))) === false; ++$i)
	{
		$to = Tools::getValue('email'.$i);
		$wishlist = WishList::exists($id_wishlist, $context->customer->id, true);
		if ($wishlist === false)
			exit($module->l('Invalid wishlist', 'sendwishlist'));
		if (WishList::addEmail($id_wishlist, $to) === false)
			exit($module->l('Wishlist send error', 'sendwishlist'));
		$toName = strval(Configuration::get('PS_SHOP_NAME'));
		$customer = $context->customer;
		if (Validate::isLoadedObject($customer))
			Mail::Send(
				$context->language->id,
				'wishlist',
				sprintf(Mail::l('Message from %1$s %2$s', $context->language->id), $customer->lastname, $customer->firstname),
				array(
					'{lastname}' => $customer->lastname,
					'{firstname}' => $customer->firstname,
					'{wishlist}' => $wishlist['name'],
					'{message}' => $context->link->getModuleLink('ishiblockwishlist', 'view', array('token' => $wishlist['token']))
				),
				$to, $toName, $customer->email, $customer->firstname.' '.$customer->lastname, null, null, dirname(__FILE__).'/mails/'
			);
	}
}
