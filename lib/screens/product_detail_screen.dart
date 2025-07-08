import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/product_detail/product_detail_cubit.dart';
import '../blocs/product_detail/product_detail_state.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/wishlist/wishlist_cubit.dart';
import '../blocs/wishlist/wishlist_state.dart';
import '../utils/auth_guard.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  String? selectedSize;
  final PageController _pageController = PageController();
  int _currentIndex = 0;


  @override
  void initState() {
    super.initState();
    context.read<ProductDetailCubit>().loadProduct(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailCubit, ProductDetailState>(
      builder: (context, state) {
        if (state is ProductDetailLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (state is ProductDetailError) {
          return Scaffold(body: Center(child: Text(state.message)));
        }

        if (state is ProductDetailLoaded) {
          final product = state.product;

          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.only(bottom: 100),
                  children: [
                    // Image Carousel
                  // Remplace le bloc actuel de PageView par ceci dans ton build()
                    SizedBox(
                      height: 320,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: PageView.builder(
                          controller: PageController(viewportFraction: 0.8),
                          onPageChanged: (index) {
                            setState(() => _currentIndex = index);
                          },
                          itemCount: product.gallery.isNotEmpty ? product.gallery.length : 1,
                          itemBuilder: (context, index) {
                            final imageUrls = product.gallery.isNotEmpty
                                ? product.gallery
                                : [product.image];

                            final imageUrl = imageUrls[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => FullScreenImageViewer(
                                    imageUrls: imageUrls,
                                    initialIndex: index,
                                  ),
                                ));
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: EdgeInsets.symmetric(horizontal: 8, vertical: _currentIndex == index ? 0 : 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 6,
                                      offset: const Offset(0, 4),
                                    )
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

// Les indicateurs (dots)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        product.gallery.isNotEmpty ? product.gallery.length : 1,
                            (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentIndex == index ? 10 : 6,
                          height: _currentIndex == index ? 10 : 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentIndex == index ? Colors.black : Colors.grey[400],
                          ),
                        ),
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Text('${product.price.toStringAsFixed(0)} FCFA',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 24),
                          // Size dropdown
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: selectedSize,
                              hint: const Text('Choisir une taille'),
                              underline: const SizedBox(),
                              onChanged: (value) {
                                setState(() => selectedSize = value);
                              },
                              items: product.sizes
                                  .map((e) => DropdownMenuItem<String>(
                                value: e.size,
                                child: Text('${e.size}'),
                              ))
                                  .toList(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Quantity selector
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Quantité", style: TextStyle(fontSize: 16)),
                                Row(
                                  children: [
                                    _circleIcon(
                                      icon: Icons.remove,
                                      onTap: quantity > 1
                                          ? () => setState(() => quantity--)
                                          : null,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      child: Text(quantity.toString(),
                                          style: const TextStyle(fontSize: 16)),
                                    ),
                                    _circleIcon(
                                      icon: Icons.add,
                                      onTap: () => setState(() => quantity++),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Description
                          const Text('Description',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Text(
                            product.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Back and Heart buttons
                Positioned(
                  top: 40,
                  left: 16,
                  child: _iconCircle(Icons.arrow_back, () {
                    Navigator.of(context).pop();
                  }),
                ),
                BlocBuilder<WishlistCubit, WishlistState>(
                  builder: (context, state) {
                    bool isWishlisted = false;

                    if (state is WishlistLoaded) {
                      isWishlisted = state.wishlistItems.any((item) => item.product.id == product.id);
                    }

                    return Positioned(
                      top: 40,
                      right: 16,
                      child: GestureDetector(
                        onTap: () async {
                          final allowed = await checkAuthOrPrompt(context);
                          if (!allowed) return;

                          final cubit = context.read<WishlistCubit>();
                          if (isWishlisted) {
                            cubit.remove(product.id);
                          } else {
                            cubit.add(product.id);
                          }
                        },
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder: (child, animation) => ScaleTransition(
                            scale: animation,
                            child: child,
                          ),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isWishlisted ? Icons.favorite : Icons.favorite_border,
                              key: ValueKey(isWishlisted),
                              color: isWishlisted ? Colors.red : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

              ],
            ),

            // Bottom Add to Bag
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        '${product.price.toStringAsFixed(0)} FCFA',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(40),
                        onTap: () async {
                          final allowed = await checkAuthOrPrompt(context);
                          if (!allowed) return;

                          if (selectedSize == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Veuillez sélectionner une taille'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          context.read<CartBloc>().add(AddToCart(
                            productId: product.id,
                            quantity: quantity,
                            size: selectedSize!,
                          ));

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Maillot ajouté au panier'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        child: const Center(
                          child: Text(
                            'Ajouter',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _circleIcon({required IconData icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _iconCircle(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.black),
      ),
    );
  }
}

class FullScreenImageViewer extends StatelessWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(initialPage: initialIndex);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: controller,
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return Center(
                child: InteractiveViewer(
                  child: Image.network(imageUrls[index]),
                ),
              );
            },
          ),
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.close, color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}

