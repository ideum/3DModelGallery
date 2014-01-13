<?xml version="1.0" encoding="UTF-8"?>
<GestureMarkupLanguage xmlns:gml="http://gestureworks.com/gml/version/3.0">		

	<Gesture_set gesture_set_name="sensor-wiimote-gestures">
	
					<Gesture id="3dsensor-1-accelerometer-b-3drotateY" type="sensor_rotate">
							<match>
								<action>
									<initial>
										<cluster type="accelerometer" input_type="sensor" device_type="wiimote" point_number="1" point_number_min="1" point_number_max="1"/>
										<button_event="b_press"/>
									</initial>
								</action>
							</match>	
							<analysis>
								<algorithm class="3d_kinemetric" type="continuous">
									<library module="3d_accelerometer"/>
									<returns>
										<property id="dthetaY" result="dthetaY"/>
									</returns>
								</algorithm>
							</analysis>	
							<mapping>
								<update dispatch_type="continuous">
									<gesture_event type="sensor_rotate">
										<property ref="dthetaY" target="rotationY"/>
									</gesture_event>
								</update>
							</mapping>
					</Gesture>
					
					<Gesture id="3dsensor-1-accelerometer-a-3drotateX" type="sensor_rotate">
							<match>
								<action>
									<initial>
										<cluster type="accelerometer" input_type="sensor" device_type="wiimote" point_number="1" point_number_min="1" point_number_max="1"/>
										<button_event="a_press"/>
									</initial>
								</action>
							</match>	
							<analysis>
								<algorithm class="3d_kinemetric" type="continuous">
									<library module="3d_accelerometer"/>
									<returns>
										<property id="dthetaX" result="dthetaX"/>
									</returns>
								</algorithm>
							</analysis>	
							<mapping>
								<update dispatch_type="continuous">
									<gesture_event type="sensor_rotate">
										<property ref="dthetaX" target="rotationX"/>
									</gesture_event>
								</update>
							</mapping>
					</Gesture>
					
		</Gesture_set>		
					
		<Gesture_set gesture_set_name="sensor-voice-gestures">
					
					<Gesture id="voice-select-taurine" type="sensor_voice">
							<match>
								<action>
									<initial>
										<cluster type="voice" input_type="sensor" device_type="mic" point_number="1" point_number_min="1" point_number_max="1"/>
										<phrase="taurine"/>
									</initial>
								</action>
							</match>	
							<analysis>
								<algorithm class="audiometric" type="continuous">
									<library module="voice"/>
									<returns>
										<property id="item" result="name"/>
									</returns>
								</algorithm>
							</analysis>	
							<mapping>
								<update dispatch_type="discrete">
									<gesture_event type="sensor_voice">
										<property ref="item" target="name"/>
									</gesture_event>
								</update>
							</mapping>
					</Gesture>
					
					<Gesture id="voice-select-caffine" type="sensor_voice">
							<match>
								<action>
									<initial>
										<cluster type="voice" input_type="sensor" device_type="mic" point_number="1" point_number_min="1" point_number_max="1"/>
										<phrase="caffine"/>
									</initial>
								</action>
							</match>	
							<analysis>
								<algorithm class="audiometric" type="continuous">
									<library module="voice"/>
									<returns>
										<property id="item" result="name"/>
									</returns>
								</algorithm>
							</analysis>	
							<mapping>
								<update dispatch_type="discrete">
									<gesture_event type="sensor_voice">
										<property ref="item" target="name"/>
									</gesture_event>
								</update>
							</mapping>
					</Gesture>
					
					<Gesture id="voice-select-vitamin" type="sensor_voice">
							<match>
								<action>
									<initial>
										<cluster type="voice" input_type="sensor" device_type="mic" point_number="1" point_number_min="1" point_number_max="1"/>
										<phrase="vitamin"/>
									</initial>
								</action>
							</match>	
							<analysis>
								<algorithm class="audiometric" type="continuous">
									<library module="voice"/>
									<returns>
										<property id="item" result="name"/>
									</returns>
								</algorithm>
							</analysis>	
							<mapping>
								<update dispatch_type="discrete">
									<gesture_event type="sensor_voice">
										<property ref="item" target="name"/>
									</gesture_event>
								</update>
							</mapping>
					</Gesture>

		</Gesture_set>


		<Gesture_set gesture_set_name="motion-gestures">	
				
				<Gesture id="3dmotion-1-pinch-2dtranslate" type="motion_drag">
							<match>
								<action>
									<initial>
										<cluster type="pinch" input_type="motion" point_number="1" point_number_min="1" point_number_max="10"/>
									</initial>
								</action>
							</match>	
							<analysis>
								<algorithm class="3d_kinemetric" type="continuous">
									<library module="3d_translate"/>
									<returns>
										<property id="dx" result="dx"/>
										<property id="dy" result="dy"/>
									</returns>
								</algorithm>
							</analysis>	
							<mapping>
								<update dispatch_type="continuous">
									<gesture_event type="motion_drag">
										<property ref="dx" target="x"/>
										<property ref="dy" target="y"/>
									</gesture_event>
								</update>
							</mapping>
				</Gesture>
		
				
				<Gesture id="3dmotion-1-fist-2dtranslate" type="motion_drag">
							<match>
								<action>
									<initial>
										<cluster type="fist" flatness="1" input_type="motion" point_number="1" point_number_min="1" point_number_max="10"/>
									</initial>
								</action>
							</match>	
							<analysis>
								<algorithm class="3d_kinemetric" type="continuous">
									<library module="3d_translate"/>
									<returns>
										<property id="dx" result="dx"/>
										<property id="dy" result="dy"/>
									</returns>
								</algorithm>
							</analysis>	
							<mapping>
								<update dispatch_type="continuous">
									<gesture_event type="motion_drag">
										<property ref="dx" target="x"/>
										<property ref="dy" target="y"/>
									</gesture_event>
								</update>
							</mapping>
					</Gesture>
				
			
			
				<Gesture id="3dmotion-1-trigger-3dhold" type="motion_hold">
							<match>
								<action>
									<initial>
										<cluster type="trigger" input_type="motion" point_number="1" point_number_min="1" point_number_max="1"/>
									</initial>
								</action>
							</match>	
							<analysis>
								<algorithm class="3d_kinemetric" type="continuous">
									<library module="3d_hold"/>
									<returns>
										<property id="x" result="x"/>
										<property id="y" result="y"/>
										<property id="z" result="z"/>
									</returns>
								</algorithm>
							</analysis>	
							<mapping>
								<update dispatch_type="discrete">
									<gesture_event type="motion_hold">
										<property ref="x" target=""/>
										<property ref="y" target=""/>
										<property ref="z" target=""/>
									</gesture_event>
								</update>
							</mapping>
					</Gesture>
		</Gesture_set>		
			
		<Gesture_set gesture_set_name="touch-gestures">

					<Gesture id="n-drag-inertia" type="drag">
						
						<match>
							<action>
								<initial>
									<cluster type="point" input_type="touch" point_number="0" point_number_min="1" point_number_max="10"/>
								</initial>
							</action>
						</match>	
						<analysis>
							<algorithm class="kinemetric" type="continuous">
								<library module="drag"/>
								<returns>
									<property id="drag_dx" result="dx"/>
									<property id="drag_dy" result="dy"/>
								</returns>
							</algorithm>
						</analysis>
						<processing>
							<inertial_filter>
								<property ref="drag_dx" active="true" friction="0.9"/>
								<property ref="drag_dy" active="true" friction="0.9"/>
							</inertial_filter>
							<delta_filter>
								<property ref="drag_dx" active="true" delta_min="0.05" delta_max="500"/>
								<property ref="drag_dy" active="true" delta_min="0.05" delta_max="500"/>
							</delta_filter>
						</processing>
						<mapping>
							<update dispatch_type="continuous">
								<gesture_event type="drag">
									<property ref="drag_dx" target="x"/>
									<property ref="drag_dy" target="y"/>
								</gesture_event>
							</update>
						</mapping>
					</Gesture>
					

					<Gesture id="n-scale" type="scale">
					
						<comment>The 'n-scale' gesture can be activated by any number of touch points between 2 and 10. When two or more touch points are recognized on a touch object the relative separation
						of the touch points are tracked and grouped into a cluster. Changes in the separation of the cluster are mapped directly to the scale of the touch object.</comment>
						
						<match>
							<action>
								<initial>
									<cluster point_number="0" point_number_min="2" point_number_max="10"/>
								</initial>
							</action>
						</match>
						<analysis>
							<algorithm class="kinemetric" type="continuous">
								<library module="scale"/>
								<returns>
									<property id="scale_dsx" result="ds"/>
									<property id="scale_dsy" result="ds"/>
								</returns>
							</algorithm>
						</analysis>	
						<mapping>
							<update dispatch_type="continuous">
								<gesture_event type="scale">
									<property ref="scale_dsx" target="scaleX"/>
									<property ref="scale_dsy" target="scaleY"/>
								</gesture_event>
							</update>
						</mapping>
					</Gesture>
					
					<Gesture id="n-tap" type="tap">
							<match>
								<action>
									<initial>
										<point event_duration_max="200" translation_max="10"/>
										<cluster point_number="0" point_number_min="1" point_number_max="5"/>
										<event touch_event="gwTouchEnd"/>
									</initial>
								</action>
							</match>	
							<analysis>
								<algorithm class="temporalmetric" type="discrete">
									<library module="tap"/>
									<returns>
										<property id="tap_x" result="x"/>
										<property id="tap_y" result="y"/>
										<property id="tap_n" result="n"/>
									</returns>
								</algorithm>
							</analysis>	
							<mapping>
								<update dispatch_type="discrete" dispatch_mode="batch" dispatch_interval="200">
									<gesture_event  type="tap">
										<property ref="tap_x"/>
										<property ref="tap_y"/>
										<property ref="tap_n"/>
									</gesture_event>
								</update>
							</mapping>
					</Gesture>
					
	</Gesture_set>
	
</GestureMarkupLanguage>
