"use client"

import { useState } from "react"
import { Header } from "@/components/header"
import { Hero } from "@/components/hero"
import { Menu } from "@/components/menu"
import { Cart } from "@/components/cart"
import { Footer } from "@/components/footer"

export interface CartItem {
  id: string
  name: string
  price: number
  quantity: number
  image: string
  size?: string
}

export default function Home() {
  const [cartItems, setCartItems] = useState<CartItem[]>([])
  const [isCartOpen, setIsCartOpen] = useState(false)

  const addToCart = (item: Omit<CartItem, "quantity">) => {
    setCartItems((prev) => {
      const existingItem = prev.find((cartItem) => cartItem.id === item.id && cartItem.size === item.size)

      if (existingItem) {
        return prev.map((cartItem) =>
          cartItem.id === item.id && cartItem.size === item.size
            ? { ...cartItem, quantity: cartItem.quantity + 1 }
            : cartItem,
        )
      }

      return [...prev, { ...item, quantity: 1 }]
    })
  }

  const removeFromCart = (id: string, size?: string) => {
    setCartItems((prev) => prev.filter((item) => !(item.id === id && item.size === size)))
  }

  const updateQuantity = (id: string, quantity: number, size?: string) => {
    if (quantity === 0) {
      removeFromCart(id, size)
      return
    }

    setCartItems((prev) => prev.map((item) => (item.id === id && item.size === size ? { ...item, quantity } : item)))
  }

  const getTotalItems = () => {
    return cartItems.reduce((total, item) => total + item.quantity, 0)
  }

  const getTotalPrice = () => {
    return cartItems.reduce((total, item) => total + item.price * item.quantity, 0)
  }

  return (
    <div className="min-h-screen bg-white">
      <Header cartItemsCount={getTotalItems()} onCartClick={() => setIsCartOpen(true)} />
      <Hero />
      <Menu onAddToCart={addToCart} />
      <Footer />

      <Cart
        isOpen={isCartOpen}
        onClose={() => setIsCartOpen(false)}
        items={cartItems}
        onRemoveItem={removeFromCart}
        onUpdateQuantity={updateQuantity}
        totalPrice={getTotalPrice()}
      />
    </div>
  )
}