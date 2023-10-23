require "test_helper"

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  
  test "product attributes must not be empty" do
    product = Product.new

    assert product.invalid?

    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
    
  end
  
  test "product price must be positive" do #the test method creates a method in order to run the test.
    product = Product.new(title: "My book title",
                          description: "yyy",
                          image_url: "zzz.jpg")
    
    product.price = -1
    
    assert product.invalid?
    
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]
    
    product.price = 1
    
    assert product.valid?, "The price #{product.price} is not valid :("
  end
  
  def new_product(image_url)
    Product.new(title: "My Book Title", 
                description: "yyy", 
                price: 1, 
                image_url: image_url)
  end
  
  test "image_url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.PNG FRED.GIF 
             http://a.b.c/x/w/z/fred.gif }
    
    bad = %w{ fred.doc fred.gif/more fred.gif.more }
    
    ok.each do |image_url|
      assert new_product(image_url).valid?,
             "#{image_url} must be valid."
    end
    
    bad.each do |image_url|
      assert new_product(image_url).invalid?,
             "#{image_url} must be invalid."
    end
  end
  
  test "product is not valid without a unique title" do
    product = Product.new(title: products(:ruby).title,
                          description: "yyy",
                          price: 9.99,
                          image_url: "image.jpg")
    
    assert product.invalid? 
    
    # assert_equal ["has already been taken"], product.errors[:title]
    # using a built-in error message
    
    assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]
  end
  
end