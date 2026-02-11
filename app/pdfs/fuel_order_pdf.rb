class FuelOrderPdf < Prawn::Document
  def initialize(fuel_order)
    super(page_size: 'LETTER', margin: 40)
    @fuel_order = fuel_order
    generate
  end

  def generate
    header
    order_info
    items_table
    totals
    signatures
  end

  private

  def header
    logo_path = Rails.root.join('app', 'assets', 'images', 'logo.png')
    if File.exist?(logo_path)
      image logo_path, width: 80, position: :right
    end
    
    text "OMS Fuels", size: 24, style: :bold, align: :center
    text "Fuel Order Receipt", size: 18, align: :center
    move_down 20
  end

  def order_info
    text "Order #: #{@fuel_order.formatted_number}", size: 14, style: :bold
    text "Date: #{@fuel_order.created_at.strftime('%B %d, %Y')}"
    text "Status: #{@fuel_order.status.titleize}"
    text "Requester: #{@fuel_order.requester_assignment.personal.full_name}"
    text "Department: #{@fuel_order.requester_assignment.department.name}"
    
    if @fuel_order.approver_assignment
      text "Approved by: #{@fuel_order.approver_assignment.personal.full_name}"
      text "Approved at: #{@fuel_order.approved_at.strftime('%B %d, %Y %H:%M')}" if @fuel_order.approved_at
    end
    
    move_down 20
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
    move_down 40
    
    # Requester signature
    bounding_box([0, cursor], width: 200) do
      if @fuel_order.requester_sign.attached?
        begin
          image StringIO.new(@fuel_order.requester_sign.download), fit: [150, 50], position: :center
        rescue => e
          Rails.logger.error "Error loading requester signature: #{e.message}"
        end
      end
      stroke_horizontal_rule
      move_down 5
      text "Requested by", align: :center, style: :bold
      text @fuel_order.requester_assignment.personal.full_name, align: :center, size: 10
      text @fuel_order.requester_assignment.position.name, align: :center, size: 9, style: :italic
    end

    # Approver signature
    if @fuel_order.approver_assignment
      bounding_box([bounds.width - 200, cursor + 85], width: 200) do
        if @fuel_order.approver_sign.attached?
          begin
            image StringIO.new(@fuel_order.approver_sign.download), fit: [150, 50], position: :center
          rescue => e
            Rails.logger.error "Error loading approver signature: #{e.message}"
          end
        end
        stroke_horizontal_rule
        move_down 5
        text "Approved by", align: :center, style: :bold
        text @fuel_order.approver_assignment.personal.full_name, align: :center, size: 10
        text @fuel_order.approver_assignment.position.name, align: :center, size: 9, style: :italic
      end
    end
  end

  def format_currency(amount)
    "Bs #{'%.2f' % amount}"
  end
end
