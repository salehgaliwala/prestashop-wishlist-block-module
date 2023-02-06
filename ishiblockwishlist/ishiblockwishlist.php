<?php
/******************

 * Ishi Technolabs  Framework for Prestashop 1.7.x 
 * @package   	ishiblockwishlist
 * @version   	1.0
 * @author   	http://ishitechnolabs.com/
 * @license   GNU General Public License version 1
 
 * *****************/

if (!defined('_PS_VERSION_'))
	exit;

include_once(dirname(__FILE__).'/WishList.php');

class IshiBlockWishList extends Module
{
	const INSTALL_SQL_FILE = 'install.sql';

	private $html = '';

	public function __construct()
	{
		$this->name = 'ishiblockwishlist';
		$this->tab = 'front_office_features';
		$this->version = '1.0.0';
		$this->author = 'Ishi Technolabs';
		$this->need_instance = 0;

		$this->controllers = array('mywishlist', 'view');

		$this->bootstrap = true;
		parent::__construct();

		$this->displayName = $this->l('Ishi Wishlist Block');
		$this->description = $this->l('Adds a block containing the customer\'s wishlists.');
		$this->default_wishlist_name = $this->l('My wishlist');
		$this->ps_versions_compliancy = array('min' => '1.6', 'max' => _PS_VERSION_);
		$this->html = '';
	}

	public function install($delete_params = true)
	{
		if ($delete_params)
		{
			if (!file_exists(dirname(__FILE__).'/'.self::INSTALL_SQL_FILE))
				return (false);
			else if (!$sql = Tools::file_get_contents(dirname(__FILE__).'/'.self::INSTALL_SQL_FILE))
				return (false);
			$sql = str_replace(array('PREFIX_', 'ENGINE_TYPE'), array(_DB_PREFIX_, _MYSQL_ENGINE_), $sql);
			$sql = preg_split("/;\s*[\r\n]+/", $sql);
			foreach ($sql as $query)
				if ($query)
					if (!Db::getInstance()->execute(trim($query)))
						return false;
		}

		if (!parent::install() ||
			!$this->registerHook('rightColumn') ||
			!$this->registerHook('productActions') ||
			!$this->registerHook('cart') ||
			!$this->registerHook('customerAccount') ||
			!$this->registerHook('header') ||
			!$this->registerHook('adminCustomers') ||
			!$this->registerHook('displayQuickviewWishlist') ||
			!$this->registerHook('displayProductAdditionalInfo') ||
			!$this->registerHook('displayProductListFunctionalButtons'))
			return false;
		/* This hook is optional */
		$this->registerHook('displayMyAccountBlock');

		return true;
	}

	public function uninstall($delete_params = true)
	{
		if (($delete_params && !$this->deleteTables()) || !parent::uninstall())
			return false;

		return true;
	}

	private function deleteTables()
	{
		return Db::getInstance()->execute(
			'DROP TABLE IF EXISTS
			`'._DB_PREFIX_.'wishlist`,
			`'._DB_PREFIX_.'wishlist_email`,
			`'._DB_PREFIX_.'wishlist_product`,
			`'._DB_PREFIX_.'wishlist_product_cart`'
		);
	}

	public function reset()
	{
		if (!$this->uninstall(false))
			return false;
		if (!$this->install(false))
			return false;

		return true;
	}

	public function getContent()
	{

		if (Tools::isSubmit('viewishiblockwishlist') && $id = Tools::getValue('id_product'))
			Tools::redirect($this->context->link->getProductLink($id));
		elseif (Tools::isSubmit('submitSettings'))
		{
			$activated = Tools::getValue('activated');
			if ($activated != 0 && $activated != 1)
				$this->html .= '<div class="alert error alert-danger">'.$this->l('Activate module : Invalid choice.').'</div>';
			$this->html .= '<div class="conf confirm alert alert-success">'.$this->l('Settings updated').'</div>';
		}

		$this->html .= $this->renderJS();
		$this->html .= $this->renderForm();
		if (Tools::getValue('id_customer') && Tools::getValue('id_wishlist'))
			$this->html .= $this->renderList((int)Tools::getValue('id_wishlist'));

		return $this->html;
	}

	public function hookDisplayProductListFunctionalButtons($params)
	{
		//TODO : Add cache
		if ($this->context->customer->isLogged())
			$this->smarty->assign('wishlists', Wishlist::getByIdCustomer($this->context->customer->id));

		$this->smarty->assign('product', $params['product']);
		return $this->display(__FILE__, 'ishiblockwishlist_button.tpl');
	}

	public function hookHeader($params)
	{
		
		$this->context->controller->addCSS(($this->_path).'ishiblockwishlist.css', 'all');
		$this->context->controller->addJS(($this->_path).'js/ajax-wishlist.js');

		$this->smarty->assign(array('wishlist_link' => $this->context->link->getModuleLink('ishiblockwishlist', 'mywishlist')));		
		
		
		if ($this->context->customer->isLogged())
		{
			$wishlists = Wishlist::getByIdCustomer($this->context->customer->id);
			if (empty($this->context->cookie->id_wishlist) === true ||
				WishList::exists($this->context->cookie->id_wishlist, $this->context->customer->id) === false)
			{
				if (!count($wishlists))
					$id_wishlist = false;
				else
				{
					$id_wishlist = (int)$wishlists[0]['id_wishlist'];
					$this->context->cookie->id_wishlist = (int)$id_wishlist;
				}
			}
			else
				$id_wishlist = $this->context->cookie->id_wishlist;

			Media::addJsDef(array(
				'wishlistProductsIds' => ($id_wishlist == false ? false : WishList::getProductByIdCustomer($id_wishlist,
				$this->context->customer->id, $this->context->language->id, null, true)),
				'mywishlist_url'	=> $this->context->link->getModuleLink('ishiblockwishlist', 'mywishlist', array(), true)
			));
			
			Media::addJsDef(array(
				'isLoggedWishlist' => true,
				'isLogged' => true,
			));				
		
			$this->smarty->assign(
				array(
					'id_wishlist' => $id_wishlist,
					'isLogged' => true,
					'wishlists' => $wishlists,
					'ptoken' => Tools::getToken(false)
				)
			);
			
			
		}
		else{
			Media::addJsDef(array(
				'isLoggedWishlist' => false,
				'isLogged' => false,
			));	
			
			$this->smarty->assign(array('wishlist_products' => false, 'wishlists' => false));
		}
		
		Media::addJsDefL('loggin_required', $this->l('You must be login in to manage your wishlist.'));
		Media::addJsDefL('loggin_url', $this->context->link->getPageLink('my-account', true));
		Media::addJsDefL('loggin_url_text', $this->l('login here'));	
		Media::addJsDefL('added_to_wishlist', $this->l('The product was successfully added to your wishlist.'));	
		Media::addJsDefL('wishlist_url', $this->context->link->getModuleLink('ishiblockwishlist', 'mywishlist', array(), true));
		Media::addJsDefL('wishlist_url_text', $this->l('Your Wishlist'));			

		$this->smarty->assign(
			array(
				'baseDir' => __PS_BASE_URI__,
				'static_token' => Tools::getToken(false)					
			)
		);				

		return $this->display(__FILE__, 'ishiblockwishlist_top.tpl');
	}

	public function hookRightColumn($params)
	{
		if ($this->context->customer->isLogged())
		{
			$wishlists = Wishlist::getByIdCustomer($this->context->customer->id);
			if (empty($this->context->cookie->id_wishlist) === true ||
				WishList::exists($this->context->cookie->id_wishlist, $this->context->customer->id) === false)
			{
				if (!count($wishlists))
					$id_wishlist = false;
				else
				{
					$id_wishlist = (int)$wishlists[0]['id_wishlist'];
					$this->context->cookie->id_wishlist = (int)$id_wishlist;
				}
			}
			else
				$id_wishlist = $this->context->cookie->id_wishlist;
			$this->smarty->assign(
				array(
					'id_wishlist' => $id_wishlist,
					'isLogged' => true,
					'wishlist_products' => ($id_wishlist == false ? false : WishList::getProductByIdCustomer($id_wishlist,
						$this->context->customer->id, $this->context->language->id, null, true)),
					'wishlists' => $wishlists,
					'ptoken' => Tools::getToken(false)
				)
			);
		}
		else
			$this->smarty->assign(array('wishlist_products' => false, 'wishlists' => false));

		return ($this->display(__FILE__, 'ishiblockwishlist.tpl'));
	}

	public function hookLeftColumn($params)
	{
		return $this->hookRightColumn($params);
	}

	public function hookProductActions($params)
	{
		$cookie = $params['cookie'];

		$this->smarty->assign(array(
			'id_product' => (int)Tools::getValue('id_product'),
		));

		if (isset($cookie->id_customer))
			$this->smarty->assign(array(
				'wishlists' => WishList::getByIdCustomer($cookie->id_customer),
			));

		return ($this->display(__FILE__, 'ishiblockwishlist-extra.tpl'));
	}

	public function hookDisplayQuickviewWishlist($params)
	{
		$cookie = $params['cookie'];

		$this->smarty->assign(array(
			'id_product' => (int)Tools::getValue('id_product'),
		));

		if (isset($cookie->id_customer))
			$this->smarty->assign(array(
				'wishlists' => WishList::getByIdCustomer($cookie->id_customer),
			));

		return ($this->display(__FILE__, 'ishiblockwishlist-extra.tpl'));
	}

	public function hookDisplayProductAdditionalInfo($params)
	{
		$cookie = $params['cookie'];

		$this->smarty->assign(array(
			'id_product' => (int)Tools::getValue('id_product'),
		));

		if (isset($cookie->id_customer))
			$this->smarty->assign(array(
				'wishlists' => WishList::getByIdCustomer($cookie->id_customer),
			));

		return ($this->display(__FILE__, 'ishiblockwishlist-extra.tpl'));
	}

	public function hookCustomerAccount($params)
	{
		return $this->display(__FILE__, 'my-account.tpl');
	}

	public function hookDisplayMyAccountBlock($params)
	{
		return $this->hookCustomerAccount($params);
	}

	private function _displayProducts($id_wishlist)
	{
		include_once(dirname(__FILE__).'/WishList.php');

		$wishlist = new WishList($id_wishlist);
		$products = WishList::getProductByIdCustomer($id_wishlist, $wishlist->id_customer, $this->context->language->id);
		$nb_products = count($products);
		for ($i = 0; $i < $nb_products; ++$i)
		{
			$obj = new Product((int)$products[$i]['id_product'], false, $this->context->language->id);
			if (!Validate::isLoadedObject($obj))
				continue;
			else
			{
				$images = $obj->getImages($this->context->language->id);
				foreach ($images as $image)
				{
					if ($image['cover'])
					{
						$products[$i]['cover'] = $obj->id.'-'.$image['id_image'];
						break;
					}
				}
				if (!isset($products[$i]['cover']))
					$products[$i]['cover'] = $this->context->language->iso_code.'-default';
			}
		}
		$this->html .= '
		<table class="table">
			<thead>
				<tr>
					<th class="first_item" style="width:600px;">'.$this->l('Product').'</th>
					<th class="item" style="text-align:center;width:150px;">'.$this->l('Quantity').'</th>
					<th class="item" style="text-align:center;width:150px;">'.$this->l('Priority').'</th>
				</tr>
			</thead>
			<tbody>';
		$priority = array($this->l('High'), $this->l('Medium'), $this->l('Low'));
		foreach ($products as $product)
		{
			$this->html .= '
				<tr>
					<td class="first_item">
						<img src="'.$this->context->link->getImageLink($product['link_rewrite'], $product['cover'],
							ImageType::getFormatedName('small')).'" alt="'.htmlentities($product['name'], ENT_COMPAT, 'UTF-8').'" style="float:left;" />
						'.$product['name'];
			if (isset($product['attributes_small']))
				$this->html .= '<br /><i>'.htmlentities($product['attributes_small'], ENT_COMPAT, 'UTF-8').'</i>';
			$this->html .= '
					</td>
					<td class="item" style="text-align:center;">'.(int)$product['quantity'].'</td>
					<td class="item" style="text-align:center;">'.$priority[(int)$product['priority'] % 3].'</td>
				</tr>';
		}
		$this->html .= '</tbody></table>';
	}

	public function hookAdminCustomers($params)
	{
		$customer = new Customer((int)$params['id_customer']);
		if (!Validate::isLoadedObject($customer))
			die (Tools::displayError());

		$this->html = '<h2>'.$this->l('Wishlists').'</h2>';

		$wishlists = WishList::getByIdCustomer((int)$customer->id);
		if (!count($wishlists))
			$this->html .= $customer->lastname.' '.$customer->firstname.' '.$this->l('No wishlist.');
		else
		{
			$this->html .= '<form action="'.Tools::safeOutput($_SERVER['REQUEST_URI']).'" method="post" id="listing">';

			$id_wishlist = (int)Tools::getValue('id_wishlist');
			if (!$id_wishlist)
				$id_wishlist = $wishlists[0]['id_wishlist'];

			$this->html .= '<span>'.$this->l('Wishlist').': </span> <select name="id_wishlist" onchange="$(\'#listing\').submit();">';

			if (is_array($wishlists))
				foreach ($wishlists as $wishlist)
				{
					$this->html .= '<option value="'.(int)$wishlist['id_wishlist'].'"';
					if ($wishlist['id_wishlist'] == $id_wishlist)
					{
						$this->html .= ' selected="selected"';
						$counter = $wishlist['counter'];
					}
					$this->html .= '>'.htmlentities($wishlist['name'], ENT_COMPAT, 'UTF-8').'</option>';
				}
			$this->html .= '</select>';

			$this->_displayProducts((int)$id_wishlist);

			$this->html .= '</form><br />';

			return $this->html;
		}

	}

	/*
	* Display Error from controler
	*/
	public function errorLogged()
	{
		return $this->l('You must be logged in to manage your wishlists.');
	}

	public function renderJS()
	{
		return "<script>
			$(document).ready(function () { $('#id_customer, #id_wishlist').change( function () { $('#module_form').submit();}); });
		</script>";
	}

	public function renderForm()
	{
		$_customers = WishList::getCustomers();

        	foreach ($_customers as $c)
        	{
            		$_customers[$c['id_customer']]['id_customer'] = $c['id_customer'];
            		$_customers[$c['id_customer']]['name'] = $c['firstname'].' '.$c['lastname'];
        	}

		$fields_form = array(
			'form' => array(
				'legend' => array(
					'title' => $this->l('Listing'),
					'icon' => 'icon-cogs'
				),
				'input' => array(
					array(
						'type' => 'select',
						'label' => $this->l('Customers :'),
						'name' => 'id_customer',
						'options' => array(
							'default' => array('value' => 0, 'label' => $this->l('Choose customer')),
							'query' => $_customers,
							'id' => 'id_customer',
							'name' => 'name'
						),
					)
				),
			),
		);

		if ($id_customer = Tools::getValue('id_customer'))
		{
			$wishlists = WishList::getByIdCustomer($id_customer);
			$fields_form['form']['input'][] = array(
				'type' => 'select',
				'label' => $this->l('Wishlist :'),
				'name' => 'id_wishlist',
				'options' => array(
					'default' => array('value' => 0, 'label' => $this->l('Choose wishlist')),
					'query' => $wishlists,
					'id' => 'id_wishlist',
					'name' => 'name'
				),
			);
		}

		$helper = new HelperForm();
		$helper->show_toolbar = false;
		$helper->table = $this->table;
		$lang = new Language((int)Configuration::get('PS_LANG_DEFAULT'));
		$helper->default_form_language = $lang->id;
		$helper->allow_employee_form_lang = Configuration::get('PS_BO_ALLOW_EMPLOYEE_FORM_LANG') ? Configuration::get('PS_BO_ALLOW_EMPLOYEE_FORM_LANG') : 0;

		$helper->identifier = $this->identifier;
		$helper->submit_action = 'submitModule';
		$helper->currentIndex = $this->context->link->getAdminLink('AdminModules', false).'&configure='.$this->name
			.'&tab_module='.$this->tab.'&module_name='.$this->name;
		$helper->token = Tools::getAdminTokenLite('AdminModules');
		$helper->tpl_vars = array(
			'fields_value' => $this->getConfigFieldsValues(),
			'languages' => $this->context->controller->getLanguages(),
			'id_language' => $this->context->language->id
		);

		return $helper->generateForm(array($fields_form));
	}

	public function getConfigFieldsValues()
	{
		return array(
			'id_customer' => Tools::getValue('id_customer'),
			'id_wishlist' => Tools::getValue('id_wishlist'),
		);
	}

	public function renderList($id_wishlist)
	{
		$wishlist = new WishList($id_wishlist);
		$products = WishList::getProductByIdCustomer($id_wishlist, $wishlist->id_customer, $this->context->language->id);

		foreach ($products as $key => $val)
		{
			$image = Image::getCover($val['id_product']);
			$products[$key]['image'] = $this->context->link->getImageLink($val['link_rewrite'], $image['id_image'], ImageType::getFormatedName('small'));
		}

		$fields_list = array(
			'image' => array(
				'title' => $this->l('Image'),
				'type' => 'image',
			),
			'name' => array(
				'title' => $this->l('Product'),
				'type' => 'text',
			),
			'attributes_small' => array(
				'title' => $this->l('Combination'),
				'type' => 'text',
			),
			'quantity' => array(
				'title' => $this->l('Quantity'),
				'type' => 'text',
			),
			'priority' => array(
				'title' => $this->l('Priority'),
				'type' => 'priority',
				'values' => array($this->l('High'), $this->l('Medium'), $this->l('Low')),
			),
		);

		$helper = new HelperList();
		$helper->shopLinkType = '';
		$helper->simple_header = true;
		$helper->no_link = true;
		$helper->actions = array('view');
		$helper->show_toolbar = false;
		$helper->module = $this;
		$helper->identifier = 'id_product';
		$helper->title = $this->l('Product list');
		$helper->table = $this->name;
		$helper->token = Tools::getAdminTokenLite('AdminModules');
		$helper->currentIndex = AdminController::$currentIndex.'&configure='.$this->name;
		$helper->tpl_vars = array('priority' => array($this->l('High'), $this->l('Medium'), $this->l('Low')));

		return $helper->generateList($products, $fields_list);
	}
}
