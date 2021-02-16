import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/product.dart';
import 'package:shop/provider/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = './edit-productc';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocuseNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
    isFavorite: false,
  );

  Map<String, String> _intialValue = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void didChangeDependencies() {
    final productId = ModalRoute.of(context).settings.arguments as String;
    _editedProduct = Provider.of<Products>(context).getItemById(productId);
    _intialValue = {
      'title': _editedProduct.title,
      'description': _editedProduct.description,
      'price': _editedProduct.price.toString(),
      'imageUrl': '',
    };
    _imageUrlController.text = _editedProduct.imageUrl;
    super.didChangeDependencies();
  }

  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocuseNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((_imageUrlController.text.isEmpty) &&
          (!_imageUrlController.text.startsWith('http') ||
              !_imageUrlController.text.startsWith('https'))) {
        return;
      }

      setState(() {});
    }
  }

  void _saveForm() {
    final validate = _form.currentState.validate();

    if (!validate) {
      return;
    }
    _form.currentState.save();
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _intialValue['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocuseNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter title';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: value,
                    description: _editedProduct.description,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
              ),
              TextFormField(
                initialValue: _intialValue['price'],
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: _priceFocuseNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the price';
                  }
                  if (double.parse(value) <= 0) {
                    return 'enter price greter than zero';
                  }
                  if (value.isEmpty) {
                    return 'please enter price';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    price: double.parse(value),
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
              ),
              TextFormField(
                initialValue: _intialValue['description'],
                decoration: InputDecoration(labelText: 'Descriptions'),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                focusNode: _descriptionFocusNode,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the descrption';
                  }
                  if (value.length < 10) {
                    return 'please enter with length greter than 10';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    description: value,
                    title: _editedProduct.title,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      // margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: (_imageUrlController.text.isEmpty)
                          ? Text('Enter URL')
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Url'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'please enter url';
                          }
                          if (!value.startsWith('http') ||
                              !value.startsWith('https')) {
                            return 'enter valid url';
                          } else {
                            return null;
                          }
                        },
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            imageUrl: value,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            title: _editedProduct.title,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
