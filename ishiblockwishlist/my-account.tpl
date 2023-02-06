{*

/******************

 * Ishi Technolabs  Framework for Prestashop 1.7.x 
 * @package   	ishiblockwishlist
 * @version   	1.0
 * @author   	http://ishitechnolabs.com/
 * @license   GNU General Public License version 1
 
 * *****************/
*}

<!-- MODULE WishList -->
<!-- <div class="link_wishlist">
	<a href="{$link->getModuleLink('ishiblockwishlist', 'mywishlist', array(), true)|escape:'html':'UTF-8'}" title="{l s='My Wishlists' mod='ishiblockwishlist'}">
		<i class="fa fa-heart"></i>{l s='My Wishlists' mod='ishiblockwishlist'}
	</a>
</div> -->
{if $page.page_name != 'my-account'}
	<li> 
		<a id="mywishlist-link" href="{$link->getModuleLink('ishiblockwishlist', 'mywishlist', array(), true)|escape:'html':'UTF-8'}" title="{l s='My Wishlists' mod='ishiblockwishlist'}" class="col-lg-4 col-md-6 col-sm-6 col-xs-12">
			<span class="link-item">
	           <i class="fa fa-heart"></i>
	           {l s='My Wishlists' mod='ishiblockwishlist'}
	        </span>
		</a>
	</li>
{/if}
{if $page.page_name == 'my-account'}
	<a id="mywishlist-link" href="{$link->getModuleLink('ishiblockwishlist', 'mywishlist', array(), true)|escape:'html':'UTF-8'}" title="{l s='My Wishlists' mod='ishiblockwishlist'}" class="col-lg-4 col-md-6 col-sm-6 col-xs-12">
		<span class="link-item">
           <i class="fa fa-heart"></i>
           {l s='My Wishlists' mod='ishiblockwishlist'}
        </span>
	</a>
{/if}
<!-- END : MODULE WishList -->