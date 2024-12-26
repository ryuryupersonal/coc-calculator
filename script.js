
let defense_data = [];

fetch('data/defenses.json')
    .then(response => {
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
    })
    .then(data => {})


class DmgComponent {
    constructor(jsondata) {
        this.id = jsondata.id;
        this.name = jsondata.name;
        this.img = jsondata.img;
        this.damage = jsondata.damage;
    }

    create() {
        const wrapperDiv = document.createElement('div');
        wrapperDiv.setAttribute("id", id);
        wrapperDiv.className = 'dmg-component';

        const imgContainer = document.createElement("div");
        imgContainer.className = 'img-container';


    }
}