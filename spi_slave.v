/**
 * Copyright (C) 2009 Ubixum, Inc. 
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 **/

// Author:    Lane Brooks
// Date:      10/31/2009
// Desc: Implements a low level SPI slave interface. 
//
//       THIS IS NOT SYNTHESIZABLE.
//
//       The clock polarity and phasing of this master is set via the
//       CPOL and CPHA inputs. See
//       http://en.wikipedia.org/wiki/Serial_Peripheral_Interface_Bus
//       a description of these conventions.
//


module spi_slave
  #(parameter DATA_WIDTH=16)
  (input CPOL, 
   input CPHA,
   
   input [DATA_WIDTH-1:0] datai,
   output [DATA_WIDTH-1:0] datao,
   
   output  dout,
   input din,
   input csb,
   input sclk
   );

   reg [DATA_WIDTH-1:0] sro_p, sro_n, sri_p, sri_n;
   assign dout = (CPOL ^ CPHA) ? sro_p[DATA_WIDTH-1] : sro_n[DATA_WIDTH-1];
   assign datao= (CPOL ^ CPHA) ? sri_n : sri_p;
   
   always @(posedge sclk or posedge csb) begin
      if(csb) begin
	 sro_p <= datai;
      end else begin
	 sro_p <= sro_p << 1;
	 sri_p <= (sri_p << 1) | din;
      end
   end

   always @(negedge sclk or posedge csb) begin
      if(csb) begin
	 sro_n <= datai;
      end else begin
	 sro_n <= sro_n << 1;
	 sri_n <= (sri_n << 1) | din;
      end
   end


endmodule
   