package com.elecstore.dao;

import com.elecstore.model.Cart;
import com.elecstore.model.Favourite;
import com.elecstore.model.Product;

import java.util.List;

public interface FavouriteDAO {

    Favourite createFavourite(int userId);

    Favourite findByUserId(int userId);

    Favourite findById(int favouriteId);

    boolean updateFavourite(Favourite favourite);

    boolean deleteFavourite(int favouriteId);
}
