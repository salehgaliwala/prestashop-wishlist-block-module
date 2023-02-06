{*
/******************

 * Ishi Technolabs  Framework for Prestashop 1.7.x 
 * @package   	ishiblockwishlist
 * @version   	1.0
 * @author   	http://ishitechnolabs.com/
 * @license   GNU General Public License version 1
 
 * *****************/
*}

{if $products}
	{if !$refresh}
	<div class="wishlistLinkTop">
		<p class="wishlisturl form-group">
			<label>{l s='Permalink' mod='ishiblockwishlist'}: </label>
			<input class="form-control" type="text" value="{$link->getModuleLink('ishiblockwishlist', 'view', ['token' => $token_wish])|escape:'html':'UTF-8'}"  readonly="readonly" />
		</p>
		<div id="showSendWishlist">
			<a href="#wishlist_form" id="send_wishlist" class="button_account exclusive btn-secondary" onclick="WishlistVisibility('wl_send', 'SendWishlist');" title="{l s='Send this wishlist' mod='ishiblockwishlist'}">{l s='Send this wishlist' mod='ishiblockwishlist'}</a>
		</div>
	</div>
	{/if}
	<div class="wlp_bought">
		<div class="clearfix row wlp_bought_list">
		{foreach from=$products item=product name=i}
			<div id="wlp_{$product.id_product}_{$product.id_product_attribute}" class=" col-lg-3 col-md-4 col-sm-6 col-xs-12 address {if $smarty.foreach.i.index % 2}alternate_{/if}item product-miniature">
				<div class="clearfix product-container">
					<div class="delete-container">
						<a href="javascript:;" class="lnkdel" onclick="WishlistProductManage('wlp_bought', 'delete', '{$id_wishlist}', '{$product.id_product}', '{$product.id_product_attribute}', $('#quantity_{$product.id_product}_{$product.id_product_attribute}').val(), $('#priority_{$product.id_product}_{$product.id_product_attribute}').val());" title="{l s='Delete' mod='ishiblockwishlist'}"><i class="material-icons delete">delete</i></a>
					</div>
					<div class="product_image thumbnail-container">
						<div class="thumbnail-inner">
							<a href="{$link->getProductlink($product.id_product, $product.link_rewrite, $product.category_rewrite)|escape:'html'}" title="{l s='Product detail' mod='ishiblockwishlist'}" class="product-thumbnail">
								<img src="{$link->getImageLink($product.link_rewrite, $product.cover, 'medium_default')|escape:'html'}" alt="{$product.name|escape:'html':'UTF-8'}" />
							</a>
						</div>
					</div>
					<div class="product_infos product-description">
						<h1 id="s_title" class="h3 product-title" itemprop="name">
							<a href="{$link->getProductlink($product.id_product, $product.link_rewrite, $product.category_rewrite)|escape:'html'}">{$product.name|truncate:30:'...'|escape:'html':'UTF-8'}</a>
						</h1>

						<div class="wishlist_product_detail">
							{*
							{if isset($product.attributes_small)}
								<a href="{$link->getProductlink($product.id_product, $product.link_rewrite, $product.category_rewrite)|escape:'html'}" title="{l s='Product detail' mod='ishiblockwishlist'}">{$product.attributes_small|escape:'html':'UTF-8'}</a>
							{/if}
							*}
							<div class="form-group">
  								<label>{l s='Quantity' mod='ishiblockwishlist'}:</label>
								<input type="text" class="form-control quantity" id="quantity_{$product.id_product}_{$product.id_product_attribute}" value="{$product.quantity|intval}"/>
								<label>{l s='Priority' mod='ishiblockwishlist'}:</label>
								<select id="priority_{$product.id_product}_{$product.id_product_attribute}" class="priority form-control grey">
									<option value="0"{if $product.priority eq 0} selected="selected"{/if}>{l s='High' mod='ishiblockwishlist'}</option>
									<option value="1"{if $product.priority eq 1} selected="selected"{/if}>{l s='Medium' mod='ishiblockwishlist'}</option>
									<option value="2"{if $product.priority eq 2} selected="selected"{/if}>{l s='Low' mod='ishiblockwishlist'}</option>
								</select>
							</div>
							{if $wishlists|count > 1}
								<div class="form-group">
									<label>{l s='Move'}:</label>
	                                {foreach name=wl from=$wishlists item=wishlist}
	                                    {if $smarty.foreach.wl.first}
	                                       <select class="wishlist_change_button form-control grey">
	                                       <option>---</option>
	                                    {/if}
	                                    {if $id_wishlist != {$wishlist.id_wishlist}}
		                                        <option title="{$wishlist.name}" value="{$wishlist.id_wishlist}" data-id-product="{$product.id_product}" data-id-product-attribute="{$product.id_product_attribute}" data-quantity="{$product.quantity|intval}" data-priority="{$product.priority}" data-id-old-wishlist="{$id_wishlist}" data-id-new-wishlist="{$wishlist.id_wishlist}">
		                                                {l s='Move to %s'|sprintf:$wishlist.name mod='ishiblockwishlist'}
		                                        </option>
	                                    {/if}
	                                    {if $smarty.foreach.wl.last}
	                                        </select>
	                                    {/if}
	                                {/foreach}
                            	</div>
                            {/if}
						</div>
					</div>
				</div>
				<div class="btn_action clearfix text-center">
					<a href="javascript:;" class="btn btn-default btn-secondary exclusive lnksave" onclick="WishlistProductManage('wlp_bought_{$product.id_product_attribute}', 'update', '{$id_wishlist}', '{$product.id_product}', '{$product.id_product_attribute}', $('#quantity_{$product.id_product}_{$product.id_product_attribute}').val(), $('#priority_{$product.id_product}_{$product.id_product_attribute}').val());" title="{l s='Save' mod='ishiblockwishlist'}">{l s='Save' mod='ishiblockwishlist'}</a>
				</div>
			</div>
		{/foreach}
		</div>
	</div>
	{if !$refresh}
	<form id="wishlist_form" method="post" class="wl_send std" onsubmit="return (false);" style="display: none;">
		<a id="hideSendWishlist" class="button_account icon"  href="#" onclick="WishlistVisibility('wl_send', 'SendWishlist'); return false;"  title="{l s='Close this wishlist' mod='ishiblockwishlist'}">
			<i class="material-icons close">close</i>
		</a>
		<fieldset>
			<p class="required">
				<label for="email1">{l s='Email' mod='ishiblockwishlist'}1 <sup>*</sup></label>
				<input type="text" class="form-control" name="email1" id="email1" />
			</p>
			{section name=i loop=11 start=2}
			<p>
				<label for="email{$smarty.section.i.index}">{l s='Email' mod='ishiblockwishlist'}{$smarty.section.i.index}</label>
				<input type="text" name="email{$smarty.section.i.index}" class="form-control" id="email{$smarty.section.i.index}" />
			</p>
			{/section}
			<p class="submit">
				<input class="btn btn-default" type="submit" value="{l s='Send' mod='ishiblockwishlist'}" name="submitWishlist" onclick="WishlistSend('wl_send', '{$id_wishlist}', 'email');" />
			</p>
			<p class="required">
				<sup>*</sup> {l s='Required field' mod='ishiblockwishlist'}
			</p>
		</fieldset>
	</form>
	{if count($productsBoughts)}
	<table class="wlp_bought_infos hidden std">
		<thead>
			<tr>
				<th class="first_item">{l s='Product' mod='ishiblockwishlist'}</th>
				<th class="item">{l s='Quantity' mod='ishiblockwishlist'}</th>
				<th class="item">{l s='Offered by' mod='ishiblockwishlist'}</th>
				<th class="last_item">{l s='Date' mod='ishiblockwishlist'}</th>
			</tr>
		</thead>
		<tbody>
		{foreach from=$productsBoughts item=product name=i}
			{foreach from=$product.bought item=bought name=j}
			{if $bought.quantity > 0}
				<tr>
					<td class="first_item">
						<span style="float:left;"><img src="{$link->getImageLink($product.link_rewrite, $product.cover, 'small')|escape:'html'}" alt="{$product.name|escape:'html':'UTF-8'}" /></span>
						<span style="float:left;">
							{$product.name|truncate:40:'...'|escape:'html':'UTF-8'}
						{if isset($product.attributes_small)}
							<br /><i>{$product.attributes_small|escape:'html':'UTF-8'}</i>
						{/if}
						</span>
					</td>
					<td class="item align_center">{$bought.quantity|intval}</td>
					<td class="item align_center">{$bought.firstname} {$bought.lastname}</td>
					<td class="last_item align_center">{$bought.date_add|date_format:"%Y-%m-%d"}</td>
				</tr>
			{/if}
			{/foreach}
		{/foreach}
		</tbody>
	</table>
	{/if}
	{/if}
{else}
	<p class="warning alert alert-warning">{l s='No products' mod='ishiblockwishlist'}</p>
{/if}
