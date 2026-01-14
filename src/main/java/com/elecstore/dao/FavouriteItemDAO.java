package com.elecstore.dao;

import com.elecstore.model.CartItem;
import com.elecstore.model.FavouriteItem;

import java.util.List;

public interface FavouriteItemDAO {

    FavouriteItem addItem(FavouriteItem item);

    List<FavouriteItem> getFavouriteItems(int favouriteId);

    boolean updateQuantity(int itemId, int quantity);

    boolean removeItem(int itemId);

    FavouriteItem findById(int itemId);

    FavouriteItem findByFavouriteAndProduct(int favouriteId, int productId);

    boolean clearFavourite(int favouriteId);

}
