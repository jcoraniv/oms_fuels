class FuelOrderPdf < Prawn::Document
  def initialize(fuel_order)
    super(page_size: 'LETTER', margin: 40)
    @fuel_order = fuel_order
    generate
  end

  def generate
    draw_header
    items_table
    totals
    signatures
    add_page_numbers
  end

  private

  def draw_header
    # Logo at top right
    logo_path = Rails.root.join('app', 'assets', 'images', 'logo.png')
    if File.exist?(logo_path)
      bounding_box([bounds.right - 80, bounds.top], width: 80, height: 80) do
        image logo_path, width: 80, position: :center
      end
    end
    
    text "Fuel Order Receipt", size: 14, align: :center
    text "Order #: #{@fuel_order.formatted_number}", size: 11, style: :bold, align: :center
    move_down 10
    
    text "Date: #{@fuel_order.created_at.strftime('%B %d, %Y')}", size: 9
    text "Status: #{@fuel_order.status.titleize}", size: 9
    text "Requester: #{@fuel_order.requester_assignment.personal.full_name}", size: 9
    text "Department: #{@fuel_order.requester_assignment.department.name}", size: 9
    
    if @fuel_order.approver_assignment
      text "Approved by: #{@fuel_order.approver_assignment.personal.full_name}", size: 9
      text "Approved at: #{@fuel_order.approved_at.strftime('%B %d, %Y %H:%M')}", size: 9 if @fuel_order.approved_at
    end
    
    move_down 15
  end

  def add_page_numbers
    string = "Page <page> of <total>"
    options = { at: [bounds.right - 150, 0], width: 150, align: :right, size: 10 }
    number_pages string, options
  end

def items_table
    table_data = [["Fuel", "Vehicle", "Quantity", "Unit Price", "Subtotal"]]
    
    @fuel_order.fuel_order_items.each do |item|
      table_data << [
        item.fuel.description,
        item.vehicle&.plate || "N/A",
        item.quantity_ordered.to_s,
        format_currency(item.unit_price),
        format_currency(item.partial_price)
      ]
    end

    table(table_data, header: true, width: bounds.width) do
      row(0).font_style = :bold
      columns(3..4).align = :right
      self.row_colors = ["FFFFFF", "F0F0F0"]
      self.header = true
    end
    
    move_down 10
  end

  def totals
    move_down 10
    text "Total: #{format_currency(@fuel_order.total)}", size: 14, style: :bold, align: :right
    move_down 30
  end

  def signatures
    signature_height = 120
    
    if cursor < signature_height + 50
      start_new_page
      draw_header
    else
      move_cursor_to signature_height + 30
    end
    
    # Requester signature
    bounding_box([0, cursor], width: bounds.width / 2 - 10) do
      if @fuel_order.requester_sign.attached?
        begin
          image StringIO.new(@fuel_order.requester_sign.download), fit: [150, 50], position: :center
        rescue => e
          Rails.logger.error "Error loading requester signature: #{e.message}"
          move_down 50
        end
      else
        move_down 50
      end
      stroke_horizontal_rule
      move_down 5
      text "Requested by", align: :center, style: :bold, size: 10
      text @fuel_order.requester_assignment.personal.full_name, align: :center, size: 9
      text @fuel_order.requester_assignment.position.name, align: :center, size: 8, style: :italic
    end

    # Approver signature
    if @fuel_order.approver_assignment
      bounding_box([bounds.width / 2 + 10, cursor + 85], width: bounds.width / 2 - 10) do
        if @fuel_order.approver_sign.attached?
          begin
            image StringIO.new(@fuel_order.approver_sign.download), fit: [150, 50], position: :center
          rescue => e
            Rails.logger.error "Error loading approver signature: #{e.message}"
            move_down 50
          end
        else
          move_down 50
        end
        stroke_horizontal_rule
        move_down 5
        text "Approved by", align: :center, style: :bold, size: 10
        text @fuel_order.approver_assignment.personal.full_name, align: :center, size: 9
        text @fuel_order.approver_assignment.position.name, align: :center, size: 8, style: :italic
      end
    end
  end

  def format_currency(amount)
    "Bs #{'%.2f' % amount}"
  end
end
