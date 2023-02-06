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

$error = '';

// Instance of module class for translations
$module = new IshiBlockWishList();

$token = Tools::getValue('token');
$id_product = (int)Tools::getValue('id_product');
$id_product_attribute = (int)Tools::getValue('id_product_attribute');
if (Configuration::get('PS_TOKEN_ENABLE') == 1 && strcmp(Tools::getToken(false), Tools::getValue('static_token')))
	$error = $module->l('Invalid token', 'buywishlistproduct');

if (!Tools::strlen($error) &&
	empty($token) === false &&
	empty($id_product) === false)
{
	$wishlist = WishList::getByToken($token);
	if ($wishlist !== false)
		WishList::addBoughtProduct($wishlist['id_wishlist'], $id_product, $id_product_attribute, $cart->id, 1);
}
else
	$error = $module->l('You must log in', 'buywishlistproduct');

if (empty($error) === false)
	echo $error;

