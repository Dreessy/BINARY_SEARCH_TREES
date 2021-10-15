require_relative 'node'

class Tree
  include Comparable
  def initialize(arr = [])
    @root = build_tree(arr.uniq.sort)
  end

  def build_tree(arr)
    middle = arr.length / 2
    root = Node.new(arr[middle])
    left = arr[0...middle]
    right = arr[middle + 1..-1]
    root.left = build_tree(left) unless left.empty?
    root.right = build_tree(right) unless right.empty?
    root
  end

  def insert(value, node = @root)
    return Node.new(value) if node.nil?

    if value < node.data
      node.left = insert(value, node.left)
    elsif value > node.data
      node.right = insert(value, node.right)
    end
    node
  end

  def delete(value, node = @root)
    return node if node.nil?

    if value < node.data
      node.left = delete(value, node.left)
    elsif value > node.data
      node.right = delete(value, node.right)
    else
      return node.right if node.left.nil?
      return node.left if node.right.nil?

      node.data = min(node.right)
      node.right = delete(node.data, node.right)
    end
    node
  end

  def min(node)
    return node.data if node.left.nil?

    value_min(node.left)
  end

  def find(value, node = @root)
    return node if node.nil? || node.data == value

    value < node.data ? find(value, node.left) : find(value, node.right)
  end

  def lvl_order(values = [], queue = [@root])
    until queue.empty?
      node = queue.shift
      values << node.data
      queue << node.left unless node.left.nil?
      queue << node.right unless node.right.nil?
    end
    values
  end

  def order(values = [], node = @root)
    return if node.nil?

    order(values, node.left)
    values << node.data
    order(values, node.right)
    values
  end

  def preorder(values = [], node = @root)
    return if node.nil?

    values << node.data
    preorder(values, node.left)
    preorder(values, node.right)
    values
  end

  def post(values = [], node = @root)
    return if node.nil?

    post(values, node.left)
    post(values, node.right)
    values << node.data
    values
  end

  def height(node)
    return -1 if node.nil?

    left_height = height(node.left)
    right_height = height(node.right)
    left_height > right_height ? 1 + left_height : 1 + right_height
  end

  def depth(node, current_node = @root, depth = 0)
    return 0 if node.nil?
    return depth if current_node == node

    node.data < current_node.data ? depth(node, current_node.left, depth + 1) : depth(node, current_node.right, depth + 1)
  end

  def balanced? (node = @root)
    return true if node.nil?

    height_difference = height(node.left) - height(node.right)
    return false if height_difference > 1 || height_difference < -1

    balanced?(node.left) && balanced?(node.right)
  end

  def rebalance
    @root = build_tree(lvl_order.sort)
  end

  def printt(node = @root, prefix = '', is_left = true)
    printt(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    printt(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

tree = Tree.new(Array.new(15) { rand(1..100) })
tree.printt
p tree.balanced?
p tree.lvl_order
p tree.preorder
p tree.order
p tree.post
tree.insert(110)
tree.insert(180)
tree.insert(200)
tree.insert(300)
tree.printt
p tree.balanced?
tree.rebalance
tree.printt
p tree.balanced?
p tree.lvl_order
p tree.preorder
p tree.order
p tree.post