{*
/******************

 * Ishi Technolabs  Framework for Prestashop 1.7.x 
 * @package   	ishiblockwishlist
 * @version   	1.0
 * @author   	http://ishitechnolabs.com/
 * @license   GNU General Public License version 1
 
 * *****************/
*}
{extends file='page.tpl'}
{block name="page_content"}
<div id="mywishlist">
    {capture name=path}
        <a href="{$link->getPageLink('my-account', true)|escape:'html'}">{l s='My account' mod='ishiblockwishlist'}</a>
        <a href="{$link->getModuleLink('ishiblockwishlist', 'mywishlist')|escape:'html'}">{l s='My wishlists' mod='ishiblockwishlist'}</a>
		{if isset($current_wishlist)}
	        {$current_wishlist.name}
		{/if}
    {/capture}
    <header class="page-header">
          <h1 class="page-title">{l s='My wishlists' mod='ishiblockwishlist'}</h1>
    </header>

	{if $id_customer|intval neq 0}
		{foreach $errors as $error}
          <div class="alert alert-danger">{$error}</div>
        {/foreach}
		<form method="post" class="std page-content" id="form_wishlist">
			<fieldset>
				<h3 class="page-subtitle">{l s='New wishlist' mod='ishiblockwishlist'}</h3>
				<div class="input-group">
				  	<input type="hidden" name="token" value="{$token|escape:'html':'UTF-8'}" />
				  	<label class="left_title" for="name">
                        {l s='Name' mod='ishiblockwishlist'} 
                    </label>
					<input type="text" id="name" name="name" placeholder="" class="form-control" value="{if isset($smarty.post.name) and $errors|@count > 0}{$smarty.post.name|escape:'html':'UTF-8'}{/if}" />
				  	<span class="mywishlist-btn">
				        <button id="submitWishlist" name="submitWishlist" class="btn btn-secondary submitWishlist" type="submit">{l s='Save' mod='ishiblockwishlist'}</button>
				    </span>
				</div>
			</fieldset>
		</form>
		{if $wishlists}
		<div id="block-history" class="block-center">
			<table class="std table table-bordered">
				<thead>
					<tr>
						<th class="first_item">{l s='Name' mod='ishiblockwishlist'}</th>
						<th class="item mywishlist_first">{l s='Qty' mod='ishiblockwishlist'}</th>
						<th class="item mywishlist_first">{l s='Viewed' mod='ishiblockwishlist'}</th>
						<th class="item mywishlist_second">{l s='Created' mod='ishiblockwishlist'}</th>
						<th class="item mywishlist_second">{l s='Direct Link' mod='ishiblockwishlist'}</th>
						<th class="item mywishlist_second">{l s='Default' mod='ishiblockwishlist'}</th>
						<th class="last_item mywishlist_first">{l s='Delete' mod='ishiblockwishlist'}</th>
					</tr>
				</thead>
				<tbody>
				{section name=i loop=$wishlists}
					<tr id="wishlist_{$wishlists[i].id_wishlist|intval}">
						<td style="width:200px;">
							<a href="javascript:;" onclick="javascript:WishlistManage('block-order-detail', '{$wishlists[i].id_wishlist|intval}');">{$wishlists[i].name|truncate:30:'...'|escape:'html':'UTF-8'}</a>
						</td>
						<td class="bold align_center">
							{assign var=n value=0}
							{foreach from=$nbProducts item=nb name=i}
								{if $nb.id_wishlist eq $wishlists[i].id_wishlist}
									{assign var=n value=$nb.nbProducts|intval}
								{/if}
							{/foreach}
							{if $n}
								{$n|intval}
							{else}
								0
							{/if}
						</td>
						<td>{$wishlists[i].counter|intval}</td>
						<td>{$wishlists[i].date_add|date_format:"%Y-%m-%d"}</td>
						<td><a href="javascript:;" onclick="javascript:WishlistManage('block-order-detail', '{$wishlists[i].id_wishlist|intval}');">{l s='View' mod='ishiblockwishlist'}</a></td>
						<td class="wishlist_default">
							{if isset($wishlists[i].default) && $wishlists[i].default == 1}
								<p class="is_wish_list_default">
									<i class="material-icons">check_circle </i>
								</p>
							{else}
								<a href="#" onclick="javascript:event.preventDefault();(WishlistDefault('wishlist_{$wishlists[i].id_wishlist|intval}', '{$wishlists[i].id_wishlist|intval}'));">
									<i class="material-icons">done</i>
								</a>
							{/if}
						</td>
						<td class="wishlist_delete">
							<a href="javascript:;"onclick="return (WishlistDelete('wishlist_{$wishlists[i].id_wishlist|intval}', '{$wishlists[i].id_wishlist|intval}', '{l s='Do you really want to delete this wishlist ?' mod='ishiblockwishlist' js=1}'));">
							<span>{l s='Delete' mod='ishiblockwishlist'}</span>
							<i class="material-icons">delete</i>
							</a>
						</td>
					</tr>
				{/section}
				</tbody>
			</table>
		</div>
		<div id="block-order-detail">&nbsp;</div>
		{/if}
	{/if}

	<div class="footer_links page-footer clearfix">
		<a href="{$link->getPageLink('my-account', true)}" class="account-link">
			<i class="material-icons">&#xE5CB;</i>
			<span>{l s='Back to Your Account' mod='ishiblockwishlist'}</span>
		</a>
		<a href="{$urls.base_url}" class="account-link home">
			<i class="material-icons">&#xE88A;</i>
			<span>{l s='Home' mod='ishiblockwishlist'}</span>
		</a>
	</div>
</div>
{/block}