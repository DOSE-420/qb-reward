const rewardhud = {
    data() {
        return {
            show: false,
        }
    },
    destroyed() {
        window.removeEventListener('message', this.listener);
    },
    mounted() {
        this.listener = window.addEventListener('message', (event) => {
            if (event.data.action === 'tick') {
                this.Tick(event.data);
            }
        });
    },
    methods: {
        Tick(data) {
			document.getElementById("rewardtime").innerHTML = data.timer;
			document.getElementById("rewardprice").innerHTML = data.pricetext;
            this.show = data.show;
        }
    }
}
const app = Vue.createApp(rewardhud);
app.use(Quasar)
app.mount('#container');