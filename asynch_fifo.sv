module asynch_fifo
(input logic clkw,clkr,wrst,rrst,we,re,
input logic [7:0] din,
output logic [7:0] dout,
output logic flagf,flage,flagaf,flagae);

reg [7:0] ram [15:0];
int wp,rp;
int cw,cr,maxcw;
always @ (posedge clkw)
begin
	if (wrst)
	begin
	wp<=-1; //rp<=-1;
	//flage<=1'b0; flagae<=1'b0;
	flagf<=1'b0; flagaf<=1'b0;
	end
	
	else if (we==1&&re==0)
	begin
	if (cr)
	flagf<=0;
		begin
			if (flagf!=1)
			begin
				if (wp==-1)
				begin
				wp<=0; flagf<=0; cw<=1; //flage<=0;
				end
				else if ((wp==15&&rp==-1))
				begin
				wp<=-1;
				cw<=16;
				flagf<=1;	
				//flage<=0;		
				end
				else if (wp==15&&rp!=16)
				begin
				wp<=0;
				cw<=cw+1;
				end
				else if (rp!=(wp))
				begin
				wp<=wp+1;
				cw<=cw+1;
				end
				else
				begin
				wp<=-1;
				flagf<=1;	
				cw<=16;
				//flage<=0;		
				end
			end
			
			else
			begin
			flagf<=flagf; wp<=wp; //flage<=flage;
			end
		end
	if (cw==15)
	flagaf<=1;
	else
	flagaf<=0;
	end
	
	else if (we==0&&re==0)
	begin
	flagf<=flagf;flagaf<=flagaf;wp<=wp;cw<=cw;
	end
	
	else if (we==0&&re==1)
	begin
		if (cr)
		flagf<=0;
	flagaf<=flagaf;wp<=wp;cw<=cw;
	end
	else 
	begin
			if (flagf!=1)
			begin
				if (wp==-1)
				begin
				wp<=0; flagf<=0; cw<=1; //flage<=0;
				end
				else if ((wp==15&&rp==-1))
				begin
				wp<=-1;
				cw<=16;
				flagf<=1;	
				//flage<=0;		
				end
				else if (wp==15&&rp!=16)
				begin
				wp<=0;
				cw<=cw+1;
				end
				else if (rp!=(wp))
				begin
				wp<=wp+1;
				cw<=cw+1;
				end
				else
				begin
				wp<=-1;
				flagf<=1;	
				cw<=16;
				//flage<=0;		
				end
			end
			
			else
			begin
			flagf<=flagf; wp<=wp; //flage<=flage;
			end
	if (cw==15)
	flagaf<=1;
	else
	flagaf<=0;
	end
maxcw<=cw;
end

always @ (posedge clkr)
begin
	if (rrst)
	begin
	//wp<=-1;
	rp<=-1;
	flage<=1'b0; flagae<=1'b0;
	//flagf<=1'b0; flagaf<=1'b0;
	end

	else if (re==1&&we==0)
	begin
	if (cw)
	flage<=0;

	//cr<=maxcw;
			if (flage!=1)
			begin
				if (rp==-1)
				begin
				rp<=0; cr<=maxcw;
				//flagf<=0;
				end
				else if (rp==wp||cr==1)
				begin
				flage<=1;
				cr<=0;
				//flagf<=0;
				rp<=-1; wp<=-1;
				end
				else if (rp==15)
				begin
				//flagf<=0;
				cr<=cr-1;
				rp<=0;
				end
				else
				begin
				//flagf<=0;
				cr<=cr-1;
				rp<=rp+1;
				end
			end
			
			else
			begin
			flage<=flage; rp<=rp; //flagf<=flagf;
			end

	if (cr==1)
	flagae<=1;
	else
	flagae<=0;

	cw<=0;
	end

	else if (we==0&&re==0)
	begin
	flage<=flage;flagae<=flagae;rp<=rp;cr<=cr;
	end
	else if (we==1&&re==0)
	begin
	if (cw)
	flage<=0;
	flagae<=flagae;rp<=rp;cr<=cr;
	end
	else
	begin
	//cr<=maxcw;
		//if (cr)
		//begin		
			if (cw)
			flage<=0;
	//cr<=maxcw;
			if (flage!=1&&cr!=(maxcw-1))
			begin
				if (rp==-1)
				begin
				rp<=0; cr<=maxcw;
				//flagf<=0;
				end
				else if (rp==wp||cr==1)
				begin
				flage<=1;
				cr<=0;
				//flagf<=0;
				rp<=-1; wp<=-1;
				end
				else if (rp==15)
				begin
				//flagf<=0;
				cr<=cr-1;
				rp<=0;
				end
				else
				begin
				//flagf<=0;
				cr<=cr-1;
				rp<=rp+1;
				end
			end
			
			else
			begin
			flage<=flage; rp<=rp; //flagf<=flagf;
			end

	if (cr==1)
	flagae<=1;
	else
	flagae<=0; 
	end

end

always @ (posedge clkw,posedge clkr)
begin
case({we,re})
2'b00:dout<=16'bx;
2'b01:dout<=ram[rp];
2'b10:ram[wp]<=din;
2'b11: begin
	ram[wp]<=din;
	dout<=ram[rp];
	end
endcase
end
endmodule



