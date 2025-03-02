const canvas = document.getElementById("canvas");
const ctx = canvas.getContext("2d");

function resizeCanvas() {
  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;
}
resizeCanvas();
window.addEventListener("resize", resizeCanvas);

const stars = [];
const shootingStars = [];
const numStars = 500;
let mouse = { x: -9999, y: -9999 };

window.addEventListener("mousemove", (e) => {
  mouse.x = e.clientX;
  mouse.y = e.clientY;
});

class Star {
  constructor() {
    this.originX = Math.random() * canvas.width; // Store original position
    this.originY = Math.random() * canvas.height;
    this.x = this.originX;
    this.y = this.originY;
    this.size = Math.random() * 3;
    this.twinkleSpeed = Math.random() * 0.06;
    this.alpha = Math.random() * 0.5 + 0.5;
    this.baseAlpha = this.alpha;
    this.twinkleType = Math.random() < 0.5 ? 1 : 0;
  }

  update() {
    let dx = mouse.x - this.x;
    let dy = mouse.y - this.y;
    let distance = Math.sqrt(dx * dx + dy * dy);
    let force = Math.max(100 - distance, 0) / 100;
    let angle = Math.atan2(dy, dx);

    if (distance < 100) {
      this.x += Math.cos(angle) * force * 3;
      this.y += Math.sin(angle) * force * 3;
    } else {
      // Smooth return to origin when cursor is far
      this.x += (this.originX - this.x) * 0.02;
      this.y += (this.originY - this.y) * 0.02;
    }

    if (this.twinkleType === 1) {
      this.alpha += Math.random() * this.twinkleSpeed - this.twinkleSpeed / 2;
      this.alpha = Math.min(Math.max(this.alpha, 0.3), 1);
    }
  }

  draw() {
    ctx.globalAlpha = this.alpha;
    let gradient = ctx.createRadialGradient(
      this.x,
      this.y,
      0,
      this.x,
      this.y,
      this.size * 4
    );
    gradient.addColorStop(0, "rgba(255, 255, 255, 1)");
    gradient.addColorStop(0.4, "rgba(255, 255, 255, 0.8)");
    gradient.addColorStop(1, "rgba(255, 255, 255, 0)");

    ctx.fillStyle = gradient;
    ctx.beginPath();
    ctx.arc(this.x, this.y, this.size * 3, 0, Math.PI * 2);
    ctx.fill();
    ctx.globalAlpha = 1;
  }
}

class ShootingStar {
  constructor() {
    this.reset();
  }

  reset() {
    this.x = Math.random() * canvas.width;
    this.y = Math.random() * canvas.height * 0.3; // Appear in upper sky
    this.length = Math.random() * 120 + 50;
    this.speed = Math.random() * 10 + 4;
    this.angle = Math.PI / 4 + (Math.random() * 0.3 - 0.15); // More random angles
    this.opacity = 1;
    this.trail = [];
  }

  update() {
    this.trail.push({ x: this.x, y: this.y, opacity: this.opacity });

    if (this.trail.length > 10) {
      this.trail.shift(); // Remove old trail points
    }

    this.x += Math.cos(this.angle) * this.speed;
    this.y += Math.sin(this.angle) * this.speed;
    this.opacity -= 0.02;

    if (this.opacity <= 0) {
      this.reset();
    }
  }

  draw() {
    ctx.globalAlpha = this.opacity;
    ctx.strokeStyle = "rgba(255, 255, 255, 0.9)";
    ctx.lineWidth = 2;
    ctx.shadowBlur = 20;
    ctx.shadowColor = "white";

    ctx.beginPath();
    ctx.moveTo(this.x, this.y);
    ctx.lineTo(
      this.x - Math.cos(this.angle) * this.length,
      this.y - Math.sin(this.angle) * this.length
    );
    ctx.stroke();

    // Draw trail
    for (let i = 0; i < this.trail.length; i++) {
      let p = this.trail[i];
      ctx.globalAlpha = p.opacity * 0.5;
      ctx.fillStyle = "white";
      ctx.beginPath();
      ctx.arc(p.x, p.y, 2, 0, Math.PI * 2);
      ctx.fill();
    }
    ctx.globalAlpha = 1;
  }
}

function initStars() {
  stars.length = 0;
  for (let i = 0; i < numStars; i++) {
    stars.push(new Star());
  }
}

function initShootingStars() {
  shootingStars.length = 0;
  for (let i = 0; i < 3; i++) {
    shootingStars.push(new ShootingStar());
  }
}

initStars();
initShootingStars();

function animate() {
  ctx.fillStyle = "black";
  ctx.fillRect(0, 0, canvas.width, canvas.height);

  // Ambient Glow Effect
  let ambientGlow = ctx.createRadialGradient(
    canvas.width / 2,
    canvas.height / 2,
    50,
    canvas.width / 2,
    canvas.height / 2,
    canvas.width / 2
  );
  ambientGlow.addColorStop(0, "rgba(10, 10, 30, 0.3)");
  ambientGlow.addColorStop(1, "rgba(0, 0, 0, 0)");

  ctx.fillStyle = ambientGlow;
  ctx.fillRect(0, 0, canvas.width, canvas.height);

  stars.forEach((star) => {
    star.update();
    star.draw();
  });

  shootingStars.forEach((shootingStar) => {
    shootingStar.update();
    shootingStar.draw();
  });

  requestAnimationFrame(animate);
}

animate();
