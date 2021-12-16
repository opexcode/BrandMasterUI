//
//  MyToggle.swift
//  BMaster
//
//  Created by Алексей on 27.02.2021.
//

import SwiftUI

struct MySwitcher: View {
	
	@Binding var binding: Bool
	var leftText: String
	var rightText: String
	
	var body: some View {
		
		ZStack {
			GeometryReader { g in
				
				Color(UIColor.systemGray6)
					.frame(height: 28)
					.cornerRadius(5)
				
				Color(UIColor.systemGray5)
					.frame(width: g.size.width/2, height: 28)
					.cornerRadius(5)
					.offset(x: binding ? g.size.width/2 : 0)
					.shadow(radius: 2 )
					.animation(.easeOut(duration: 0.1))
							
				HStack {
					Text(leftText)
						.frame(width: g.size.width/2)
					
					Text(rightText)
						.frame(width: g.size.width/2-10)
				} //HStack
				.font(.system(size: 14))
				.frame(height: 28)
			
			} //GeometryReader
		}
		.frame(height: 28)
		.onTapGesture {
            self.binding.toggle()
		}
	}
}
