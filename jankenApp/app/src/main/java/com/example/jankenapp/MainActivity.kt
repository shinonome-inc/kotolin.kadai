package com.example.jankenapp

import android.graphics.drawable.AnimationDrawable
import android.os.Bundle
import android.os.Handler
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {
    private val mHandler = Handler()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }

    fun rockButton(view: View) {
        jankenSystem(HandType.rock)
    }

    fun paperButton(view: View) {
        jankenSystem(HandType.paper)
    }

    fun scisserButton(view: View) {
        jankenSystem(HandType.Scissor)
    }

    fun randomAnimation(quit: Boolean) {
        cpHandIV.setImageResource(R.drawable.spin_animation)
        val frameAnimation = cpHandIV.drawable as AnimationDrawable
        frameAnimation.start()
        if (quit) {
            frameAnimation.stop()
        }
    }

    enum class HandType(val id: Int) {
        rock(0), Scissor(1), paper(2);

        companion object {
            fun fromInt(value: Int) = HandType.values().first { it.ordinal == value }
        }
    }

    fun jankenSystem(hand: HandType){
        val cp = HandType.fromInt((0..2).shuffled().first())
        randomAnimation(quit = false)
        resulttext.text = "result"

        Handler().postDelayed(Runnable {
            randomAnimation(quit = true)

            when(cp){
                HandType.rock -> cpHandIV.setImageResource(R.drawable.rock)
                HandType.Scissor -> cpHandIV.setImageResource(R.drawable.scissers)
                HandType.paper -> cpHandIV.setImageResource(R.drawable.paper)
            }

            when {
                hand.id == cp.id ->
                    resulttext.text = "draw"

                (hand.id + 1) % 3 == cp.id ->
                    resulttext.text = "win!"

                else ->
                    resulttext.text = "lose..."
                }
            }, 2000)
        }
    }
