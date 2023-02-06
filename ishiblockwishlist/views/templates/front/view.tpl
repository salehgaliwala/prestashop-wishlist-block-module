{*
/******************

 * Ishi Technolabs  Framework for Prestashop 1.7.x 
 * @package     ishiblockwishlist
 * @version     1.0
 * @author      http://ishitechnolabs.com/
 * @license   GNU General Public License version 1
 
 * *****************/
*}

<div id="view_wishlist">
<h2>{l s='Wishlist' mod='ishiblockwishlist'}</h2>
{if $wishlists}
<p>
    {l s='Other wishlists of %1s %2s:' sprintf=[$current_wishlist.firstname, $current_wishlist.lastname] mod='ishiblockwishlist'}
	{foreach from=$wishlists item=wishlist name=i}
		{if $wishlist.id_wishlist != $current_wishlist.id_wishlist}
			<a href="{$link->getModuleLink('ishiblockwishlist', 'view', ['token' => $wishlist.token])|escape:'html':'UTF-8'}" title="{$wishlist.name}" >{$wishlist.name}</a>
			{if !$smarty.foreach.i.last}
				/
			{/if}
		{/if}
	{/foreach}
</p>
{/if}

<div class="wlp_bought">
    <ul class="clearfix wlp_bought_list">
        {foreach from=$products item=product name=i}
            <li id="wlp_{$product.id_product}_{$product.id_product_attribute}" class="clearfix address {if $smarty.foreach.i.index % 2}alternate_{/if}item">
                <div class="clearfix">
                    <div class="product_image">
                        <a href="{$link->getProductlink($product.id_product, $product.link_rewrite, $product.category_rewrite)|escape:'html'}" title="{l s='Product detail' mod='ishiblockwishlist'}">
                            <img src="{$link->getImageLink($product.link_rewrite, $product.cover, ImageType::getFormatedName('medium'))|escape:'html'}" alt="{$product.name|escape:'html':'UTF-8'}" />
                        </a>
                    </div>
                    <div class="product_infos">
                        <p id="s_title" class="product_name">{$product.name|truncate:30:'...'|escape:'html':'UTF-8'}</p>
                    <span class="wishlist_product_detail">
                    {if isset($product.attributes_small)}
                        <a href="{$link->getProductlink($product.id_product, $product.link_rewrite, $product.category_rewrite)|escape:'html'}" title="{l s='Product detail' mod='ishiblockwishlist'}">{$product.attributes_small|escape:'html':'UTF-8'}</a>
                    {/if}
                        <br />{l s='Quantity' mod='ishiblockwishlist'}:<input type="text" id="quantity_{$product.id_product}_{$product.id_product_attribute}" value="{$product.quantity|intval}" size="3"  />
                        <br /><br />
                        <span><strong>{l s='Priority' mod='ishiblockwishlist'}:</strong> {$product.priority_name}</span>
                    </span>
                    </div>
                </div>
                <div class="btn_action">
                    <a class="button_small clear" href="{$link->getProductLink($product.id_product,  $product.link_rewrite, $product.category_rewrite)|escape:'html'}" title="{l s='View' mod='ishiblockwishlist'}" >{l s='View' mod='ishiblockwishlist'}</a>
                    {if (isset($product.attribute_quantity) && $product.attribute_quantity >= 1) || (!isset($product.attribute_quantity) && $product.product_quantity >= 1) || $product.allow_oosp}
                        {if !$ajax}
                            <form id="addtocart_{$product.id_product|intval}_{$product.id_product_attribute|intval}" action="{$link->getPageLink('cart')|escape:'html'}" method="post">
                                <p class="hidden">
                                    <input type="hidden" name="id_product" value="{$product.id_product|intval}" id="product_page_product_id"  />
                                    <input type="hidden" name="add" value="1" />
                                    <input type="hidden" name="token" value="{$token}" />
                                    <input type="hidden" name="id_product_attribute" id="idCombination" value="{$product.id_product_attribute|intval}" />
                                </p>
                            </form>
                        {/if}
                        <a href="javascript:;" class="exclusive" onclick="WishlistBuyProduct('{$token|escape:'html':'UTF-8'}', '{$product.id_product}', '{$product.id_product_attribute}', '{$product.id_product}_{$product.id_product_attribute}', this, {$ajax});" title="{l s='Add to cart' mod='ishiblockwishlist'}" >{l s='Add to cart' mod='ishiblockwishlist'}</a>
                    {else}
                        <span class="exclusive">{l s='Add to cart' mod='ishiblockwishlist'}</span>
                    {/if}
                </div>
            </li>
        {/foreach}
    </ul>
</div>

</div>
