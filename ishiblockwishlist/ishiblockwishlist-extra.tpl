{*
/******************

 * Ishi Technolabs  Framework for Prestashop 1.7.x 
 * @package   	ishiblockwishlist
 * @version   	1.0
 * @author   	http://ishitechnolabs.com/
 * @license   GNU General Public License version 1
 
 * *****************/
*}

{if isset($wishlists) && !empty($wishlists) > 1}
<div class="buttons_bottom_block no-print wishlist_container">
	<div id="wishlist_button">
		<select id="idWishlist" class="form-control form-control-select  grey">
			{foreach $wishlists as $wishlist}
				<option value="{$wishlist.id_wishlist}">{$wishlist.name}</option>
			{/foreach}
		</select>
		<div class="product_wishlist_btn" onclick="WishlistCart('wishlist_block_list', 'add', '{$id_product|intval}', $('#idCombination').val(), document.getElementById('quantity_wanted').value, $('#idWishlist').val()); return false;"  title="{l s='Add to wishlist' mod='ishiblockwishlist'}">
			<span>{l s='Add to wishlist' mod='ishiblockwishlist'}</span>
		</div>
	</div>
</div>
{else}
<p class="buttons_bottom_block no-print wishlist_login">
	<a class="wishlist_button" href="#" onclick="WishlistCart('wishlist_block_list', 'add', '{$id_product|intval}', $('#idCombination').val(), document.getElementById('quantity_wanted').value); return false;"   title="{l s='Add to my wishlist' mod='ishiblockwishlist'}">
		<span>{l s='Add to wishlist' mod='ishiblockwishlist'}</span>
	</a>
</p>
{/if}
